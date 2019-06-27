//
//  WXMFMDBManager.m
//  ModuleDebugging
//
//  Created by edz on 2019/6/27.
//  Copyright © 2019 wq. All rights reserved.
//

#import "WXMFMDBManager.h"

@implementation WXMFMDBManager

+ (void)saveCustomModelWithObject:(id)object {
    [super saveCustomModelWithObject:object];
}

+ (id)getCustomModelWithClass:(Class)aClass {
    return [super getCustomModelWithClass:aClass];
}

+ (void)saveAssembleWithObject:(id)object instanceType:(WXMFMDBInstanceType)instanceType {
    NSString *tableName = WXMFMDBTypeConversion(instanceType);
    if (instanceType != WXMFMDBInstanceTypeUseClassName) {
        NSAssert(tableName != nil, @"请设置表名,否则无法判断哪个表");
    } else if ((instanceType == WXMFMDBInstanceTypeUseClassName) &&
               [object isKindOfClass:[NSObject class]]) {
        [self saveCustomModelWithObject:object];
    }
}

+ (id)getAssembleWithInstanceType:(WXMFMDBInstanceType)instanceType {
    return [self getAssembleWithTable:WXMFMDBTypeConversion(instanceType)];
}


@end
