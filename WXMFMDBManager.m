//
//  WXMFMDBManager.m
//  ModuleDebugging
//
//  Created by edz on 2019/6/27.
//  Copyright © 2019 wq. All rights reserved.
//
#import "WXMFMDBManager.h"
#import "NSObject+WXMFMDBModel.h"

@implementation WXMFMDBManager

+ (void)wf_setUserID:(NSString *)userID {
    [self setUserID:userID];
}

/** 对象 */
+ (void)wf_saveModelWithObject:(id)object {
    @try {
        
        NSString *tableName = NSStringFromClass([object class]);
        NSDictionary *dictionary = [object modelToJSONObject];
        [self wf_saveAssembleWithObject:dictionary instanceType:tableName];
        
    } @catch (NSException *exception) {} @finally {}
}

+ (id)wf_getModelWithClass:(Class)aClass {
    @try {
        
        NSString *tableName = NSStringFromClass(aClass);
        id dictionary = [self wf_getAssembleWithInstanceType:tableName];
        if ([dictionary isKindOfClass:[NSDictionary class]]) {
            return [aClass modelWithDictionary:dictionary];
        }
        
        return nil;
    } @catch (NSException *exception) {} @finally {}
}

/** 数组 */
+ (void)wf_saveModelArraysWithObjects:(NSArray *)objects {
    @try {
        
        id firstObject = objects.firstObject;
        NSString *tableName = NSStringFromClass([firstObject class]);
        NSMutableArray *mutableArray = @[].mutableCopy;
        
        for (id object in objects) {
            NSDictionary *dictionary = [object modelToJSONObject];
            [mutableArray addObject:dictionary];
        }
        
        [self wf_saveAssembleWithObject:mutableArray instanceType:tableName];
        
    } @catch (NSException *exception) {} @finally {}
}

+ (NSArray *)wf_getModelArraysWithClass:(Class)aClass {
    @try {
        
        NSMutableArray *mutableArray = @[].mutableCopy;
        NSString *tableName = NSStringFromClass(aClass);
        id arrays = [self wf_getAssembleWithInstanceType:tableName];
        
        if ([arrays isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dictionary in arrays) {
                [mutableArray addObject:[aClass modelWithDictionary:dictionary]];
            }
            return mutableArray;
        }
        
        return nil;
    } @catch (NSException *exception) {} @finally {}
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

/** 删除缓存 */
+ (void)wf_deleteObjectWithClass:(Class)aClass {
    NSString *tableName = NSStringFromClass(aClass);
    [self wf_deleteObjectWithInstanceType:tableName];
}

+ (void)wf_deleteObjectWithInstanceType:(WXMFMDBTableType)instanceType {
    [self deleteObjectFromTable:instanceType];
}

@end
