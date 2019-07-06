//
//  WXMFMDBManager.m
//  ModuleDebugging
//
//  Created by edz on 2019/6/27.
//  Copyright © 2019 wq. All rights reserved.
//
#import "WXMFMDBManager.h"

@implementation WXMFMDBManager

+ (void)wxm_setUserID:(NSString *)userID {
    [super setUserID:userID];
}

+ (void)wxm_saveCustomModelWithObject:(id)object {
    [super saveCustomModelWithObject:object];
}

+ (id)wxm_getCustomModelWithClass:(Class)aClass {
    return [super getCustomModelWithClass:aClass];
}

+ (void)wxm_saveCustomModelWithObjects:(NSArray <NSObject *>*)objectArray {
    [super saveCustomModelWithObjects:objectArray];
}

+ (NSArray <NSObject *>*)wxm_getCustomModelArrayWithClass:(Class)aClass {
    return [super getCustomModelArrayWithClass:aClass];
}

+ (void)wxm_saveAssembleWithObject:(id)object instanceType:(WXMFMDBTableType)instanceType {
    if ([instanceType isEqualToString:CUSTOM_CLASS] == NO) {
        NSAssert(instanceType != nil, @"请设置表名,否则无法判断哪个表");
        [self saveAssembleWithAssemble:object fromTable:instanceType];
    } else if(([instanceType isEqualToString:CUSTOM_CLASS]) && [object isKindOfClass:NSObject.class]) {
        [self saveCustomModelWithObject:object];
    }
}

+ (id)wxm_getAssembleWithInstanceType:(WXMFMDBTableType)instanceType {
    return [self getAssembleWithTable:instanceType];
}

@end
