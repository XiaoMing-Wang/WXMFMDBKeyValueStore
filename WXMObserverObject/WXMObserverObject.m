//
//  WXMFMDBObserverObject.m
//  ModuleDebugging
//
//  Created by edz on 2019/6/28.
//  Copyright © 2019 wq. All rights reserved.
//

#import <objc/runtime.h>
#import "WXMObserverObject.h"

@interface WXMObserverObject ()
@property (nonatomic, strong) NSMutableArray<NSString *> *attributeArray;
@end

@implementation WXMObserverObject

- (instancetype)init {
    if (self = [super init]) [self listeningAllProperty];
    return self;
}

/** 监听所有属性 */
- (void)listeningAllProperty {
    [self removeAllProperty];
    for (NSString *key in self.attributeArray) {
        if (key.length == 0) return;
        [self addObserver:self
               forKeyPath:key
                  options:NSKeyValueObservingOptionNew
                  context:nil];
    }
}

/** 删除所有属性监听 */
- (void)removeAllProperty {
    if (!self.attributeArray || self.attributeArray.count == 0) return;
    for (NSString *key in self.attributeArray) {
        @try {
            if (key) [self removeObserver:self forKeyPath:key];
        } @catch (NSException *exception) {} @finally {}
    }
}

/** 属性变换 */
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if ([self.attributeArray containsObject:keyPath]) {
        [self wf_parametersChange];
    }
}

/** 参数变化调用 */
- (void)wf_parametersChange {
    NSLog(@"%@",@"有参数变化");
}

/** 获取所有属性 */
+ (NSArray *)wf_getFropertys {
    unsigned int count = 0;
    NSMutableArray *_arrayM = @[].mutableCopy;
    objc_property_t *propertys = class_copyPropertyList([self class], &count);
    for (int i = 0; i < count; i++) {
        objc_property_t property = propertys[i];
        NSString *pro = [NSString stringWithCString:property_getName(property)
                                           encoding:NSUTF8StringEncoding];
        [_arrayM addObject:pro];
    }
    return _arrayM;
}

- (NSMutableArray<NSString *> *)attributeArray {
    if (!_attributeArray) {
        _attributeArray = [[self class] wf_getFropertys].mutableCopy;
    }
    return _attributeArray;
}

- (void)dealloc {
    @try {
        [self removeAllProperty];
    } @catch (NSException *exception) {} @finally {}
    NSLog(@"%@被释放",NSStringFromClass(self.class));
}
@end
