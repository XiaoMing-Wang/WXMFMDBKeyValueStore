//
//  WXMFMDBManager.m
//  ModuleDebugging
//
//  Created by edz on 2019/6/27.
//  Copyright © 2019 wq. All rights reserved.
//
#import "WXMFMDBManager.h"

@implementation WXMFMDBManager

+ (void)wf_setUserID:(NSString *)userID {
    [self setUserID:userID];
}

/** 对象 */
+ (void)wf_saveCustomModelWithObject:(id)object {
    [self saveCustomModelWithObject:object];
}

+ (id)wf_getCustomModelWithClass:(Class)aClass {
    return [self getCustomModelWithClass:aClass];
}

/** json */
+ (void)wf_saveAssembleWithObject:(id)object instanceType:(WXMFMDBTableType)instanceType {
    NSAssert(instanceType != nil, @"请设置表名, 否则无法判断哪个表");
    [self saveAssembleWithAssemble:object fromTable:instanceType];
}

+ (id)wf_getAssembleWithInstanceType:(WXMFMDBTableType)instanceType {
    NSAssert(instanceType != nil, @"请设置表名, 否则无法判断哪个表");
    return [self getAssembleWithTable:instanceType];
}

@end
