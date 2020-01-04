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
- (NSString *)wf_isExistKey:(NSString *)key {
    
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
- (BOOL)wf_isSystemClass:(NSString *)key {
    Class class = [self wf_getAttributeClass:key];
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
- (Class)wf_getAttributeClass:(NSString *)key {
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

+ (instancetype)wf_modelWithKeyValue:(NSDictionary *)dictionary {
    return [[self alloc] wf_initWithKeyValue:dictionary];;
}

- (instancetype)wf_initWithKeyValue:(NSDictionary *)dictionary {
    NSAssert([dictionary isKindOfClass:[NSDictionary class]], @"此数据为非字典，无法解析");
    [dictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
        NSString *tKey = [self wf_isExistKey:key];
        if (tKey && obj) [self wf_setKey:tKey withValue:obj];
    }];
    return self;
}

- (void)wf_setKey:(NSString *)key withValue:(id)value {
    id aValue;
    
    BOOL isSystemClass = [self wf_isSystemClass:key];
    Class aClass = [self wf_getAttributeClass:key];
    
    /** int float NSString NSArray */
    if (isSystemClass) {
        aValue = value;
    } else if (!isSystemClass && aClass && [value isKindOfClass:[NSDictionary class]]) {
        aValue = [aClass wf_modelWithKeyValue:value];
    }
    
    if (aValue) [self setValue:aValue forKey:key];
}

#pragma mark - 模型->字典

- (NSDictionary *)wf_modelToKeyValue {
    unsigned int count;
    id value;
    NSMutableDictionary *dic = [NSMutableDictionary new];
    
    objc_property_t *propertyList = class_copyPropertyList([self class], &count);
    for (int i = 0 ; i < count; i++) {
        const char *propertyName = property_getName(propertyList[i]);
        NSString *tPropertyName = [NSString stringWithUTF8String:propertyName];
        id propertyValue = [self valueForKey:tPropertyName];
        NSString *dicKey = [NSString stringWithUTF8String:propertyName];
        
        if([self wf_isSystemClass:tPropertyName]){
            
            /**  系统类 */
            value = propertyValue;
            if (value) [dic setValue:value forKey:dicKey];
        } else {
            
            /**  自定义类递归赋值 */
            value =  [propertyValue wf_modelToKeyValue];
            if (value) [dic setValue:value forKey:dicKey];
        }
    }
    
    return dic;
}

@end
