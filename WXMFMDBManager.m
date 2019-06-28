//
//  WXMFMDBManager.m
//  ModuleDebugging
//
//  Created by edz on 2019/6/27.
//  Copyright © 2019 wq. All rights reserved.
//
#define WXMEnumToString(enumSign) [NSString stringWithFormat:@"%s",(#enumSign)]
#import "WXMFMDBManager.h"

@implementation WXMFMDBManager

+ (void)saveCustomModelWithObject:(id)object {
    [super saveCustomModelWithObject:object];
}

+ (id)getCustomModelWithClass:(Class)aClass {
    return [super getCustomModelWithClass:aClass];
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
