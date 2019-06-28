//
//  NSObject+WXMFMDBConversion.m
//  ModuleDebugging
//
//  Created by edz on 2019/6/27.
//  Copyright © 2019 wq. All rights reserved.
//
#import <objc/runtime.h>
#import "NSObject+WXMFMDBConversion.h"
@implementation NSObject (WXMFMDBConversion)

#pragma mark - 公用方法

/** 获取映射的key(无使用原来的key) */
- (NSString *)wxm_isExistKey:(NSString *)key {
    
    /** 有映射 */
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    SEL sel = NSSelectorFromString(@"wxm_modelMapPropertyNames");
    if([self respondsToSelector:sel]){
        NSDictionary *map = [self performSelector:sel];
#pragma clang diagnostic pop
        __block NSString *newKey = nil;
        [map enumerateKeysAndObjectsUsingBlock:^(NSString* dkey, NSString* obj, BOOL *stop) {
            if([key isEqualToString:dkey]) newKey = obj;
        }];
        if (newKey) return newKey;
    }
    
    /** 无映射 */
    unsigned int count = 0;
    objc_property_t *propertys = class_copyPropertyList([self class], &count);
    for (int i = 0; i < count; i++) {
        objc_property_t property = propertys[i];
        NSString *pro = [NSString stringWithCString:property_getName(property)
                                           encoding:NSUTF8StringEncoding];
        if ([pro isEqualToString:key]) return key;
    }
    free(propertys);
    return nil;
}

- (void)setNilValueForKey:(NSString *)key {}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {}

/**  key是否是系统的类 */
- (BOOL)wxm_isSystemClass:(NSString *)key {
    Class class = [self wxm_getAttributeClass:key];
    if (class == nil ||
        class == NSString.class ||
        class == NSArray.class ||
        class == NSDictionary.class ||
        class == NSSet.class ||
        class == NSData.class ||
        class == NSValue.class ||
        class == NSURL.class ||
        class == NSNumber.class) {
        return YES;
    }
    
    if ([class isKindOfClass:NSObject.class]) return NO;
    return YES;
}

/** 获取Model属性的类 */
- (Class)wxm_getAttributeClass:(NSString *)key {
    Class aClass;
    unsigned int count;
    NSRange objRange;
    NSMutableString *aAttribute;
    const char *att = "";
    
    objc_property_t *propertyList = class_copyPropertyList([self class], &count);
    for (int i = 0 ; i < count; i++) {
        const char *propertyName = property_getName(propertyList[i]);
        NSString *tStr = [NSString stringWithUTF8String:propertyName];
        if([key isEqualToString:tStr]){
            att = property_getAttributes(propertyList[i]);
            break;
        }
    }
    free(propertyList);
    
    aAttribute  = [[NSMutableString alloc] initWithUTF8String:att];
    objRange = [aAttribute rangeOfString:@"@"];
    
    /**  NSArray NSData NSString等 以及自定义类 */
    if(objRange.location != NSNotFound) {
        NSString *aString = [aAttribute componentsSeparatedByString:@","].firstObject;
        if (aString.length > 4) {
            aString = [aString substringWithRange:NSMakeRange(3, aString.length - 4)];
            aClass = NSClassFromString(aString);
        }
    } else {
        return nil;
    }
    return aClass;
}

#pragma mark - 字典->模型

+ (instancetype)wxm_modelWithKeyValue:(NSDictionary *)dictionary {
    return [[self alloc] wxm_initWithKeyValue:dictionary];;
}

- (instancetype)wxm_initWithKeyValue:(NSDictionary *)dictionary {
    NSAssert([dictionary isKindOfClass:[NSDictionary class]], @"此数据为非字典，无法解析");
    [dictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
        NSString *tKey = [self wxm_isExistKey:key];
        if (tKey && obj) [self wxm_setKey:tKey withValue:obj];
    }];
    return self;
}

- (void)wxm_setKey:(NSString *)key withValue:(id)value {
    id aValue;
    
    BOOL isSystemClass = [self wxm_isSystemClass:key];
    Class aClass = [self wxm_getAttributeClass:key];
    
    /** int float NSString NSArray */
    if (isSystemClass) {
        aValue = value;
    } else if (!isSystemClass && aClass && [value isKindOfClass:[NSDictionary class]]) {
        aValue = [aClass wxm_modelWithKeyValue:value];
    }
    
    if (aValue) [self setValue:aValue forKey:key];
}

#pragma mark - 模型->字典

- (NSDictionary *)wxm_modelToKeyValue {
    unsigned int count;
    id value;
    NSMutableDictionary *dic = [NSMutableDictionary new];
    
    objc_property_t *propertyList = class_copyPropertyList([self class], &count);
    for (int i = 0 ; i < count; i++) {
        const char *propertyName = property_getName(propertyList[i]);
        NSString *tPropertyName = [NSString stringWithUTF8String:propertyName];
        id propertyValue = [self valueForKey:tPropertyName];
        NSString *dicKey = [NSString stringWithUTF8String:propertyName];
        
        if([self wxm_isSystemClass:tPropertyName]){
            
            /**  系统类 */
            value = propertyValue;
            if (value) [dic setValue:value forKey:dicKey];
        } else {
            
            /**  自定义类 */
            value =  [propertyValue wxm_modelToKeyValue];
            if (value) [dic setValue:value forKey:dicKey];
        }
    }
    
    return dic;
}

@end
