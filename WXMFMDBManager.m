//
//  WXMFMDBManager.m
//  ModuleDebugging
//
//  Created by edz on 2019/6/27.
//  Copyright © 2019 wq. All rights reserved.
//
#import "WXMFMDBManager.h"

@implementation WXMFMDBManager

+ (void)setUserID:(NSString *)userID {
    [super setUserID:userID];
}

+ (void)saveCustomModelWithObject:(id)object {
    [super saveCustomModelWithObject:object];
}

+ (id)getCustomModelWithClass:(Class)aClass {
    return [super getCustomModelWithClass:aClass];
}

+ (void)saveCustomModelWithObjects:(NSArray <NSObject *>*)objectArray {
    [super saveCustomModelWithObjects:objectArray];
}

+ (NSArray <NSObject *>*)getCustomModelArrayWithClass:(Class)aClass {
    return [super getCustomModelArrayWithClass:aClass];
}

+ (void)saveAssembleWithObject:(id)object instanceType:(WXMFMDBInstanceType)instanceType {
    NSString *tableName = WXMEnumToString(instanceType);
    if (instanceType > CUSTOM_CLASS) {
        NSAssert(tableName != nil, @"请设置表名,否则无法判断哪个表");
        [self saveAssembleWithAssemble:object fromTable:tableName];
    } else if ((instanceType == CUSTOM_CLASS) && [object isKindOfClass:[NSObject class]]) {
        [self saveCustomModelWithObject:object];
    }
}

+ (id)getAssembleWithInstanceType:(WXMFMDBInstanceType)instanceType {
    return [self getAssembleWithTable:WXMEnumToString(instanceType)];
}

@end
