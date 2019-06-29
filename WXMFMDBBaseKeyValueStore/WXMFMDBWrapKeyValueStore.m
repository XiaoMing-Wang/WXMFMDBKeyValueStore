//
//  WXMFMDBInstanceKeyValueStore.m
//  ModuleDebugging
//
//  Created by edz on 2019/6/27.
//  Copyright © 2019 wq. All rights reserved.
//

#import "WXMFMDBWrapKeyValueStore.h"
#import "NSObject+WXMFMDBConversion.h"

@interface WXMFMDBWrapKeyValueStore ()
@property (nonatomic, strong, readwrite) NSString *userID;
@end

@implementation WXMFMDBWrapKeyValueStore

+ (instancetype)sharedInstance {
    static WXMFMDBWrapKeyValueStore * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

/** 设置userID 所有的表使用userID作为key */
+ (void)setUserID:(NSString *)userID {
    [[self sharedInstance] setUserID:userID];
}

+ (BOOL)judgeExsitUserID {
    return ([[self sharedInstance] userID].length > 0);
}

+ (NSString *)userID {
    return [WXMFMDBWrapKeyValueStore sharedInstance].userID;
}

+ (void)saveCustomModelWithObject:(NSObject *)object {
    NSAssert([self judgeExsitUserID], @"请设置userID");
    [[self sharedInstance] saveCustomModelWithObject:object primaryKey:self.userID];
}

+ (id)getCustomModelWithClass:(Class)aClass {
    NSAssert([self judgeExsitUserID], @"请设置userID");
    return [[self sharedInstance] getCustomModelWithClass:aClass primaryKey:self.userID];
}

+ (void)saveCustomModelWithObjects:(NSArray <NSObject *>*)objectArray {
    id firstObj = objectArray.firstObject;
    if (objectArray.count == 0 || !firstObj) return;
    
    NSMutableArray *array = @[].mutableCopy;
    NSString * tableName = NSStringFromClass([firstObj class]);
    [objectArray enumerateObjectsUsingBlock:^(NSObject *obj, NSUInteger idx, BOOL *stop) {
        NSDictionary * json = obj.wxm_modelToKeyValue;
        [array addObject:json];
    }];
    [self saveAssembleWithAssemble:array fromTable:tableName];
}

+ (NSArray <NSObject *>*)getCustomModelArrayWithClass:(Class)aClass {
    NSString *tableName = NSStringFromClass(aClass);
    NSArray *array = (NSArray *) [self getAssembleWithTable:tableName];
    NSMutableArray *modelArray = @[].mutableCopy;
    [array enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
        id model = [aClass wxm_modelWithKeyValue:obj];
        if (model) [modelArray addObject:model];
    }];
    return modelArray.copy;
}

+ (void)saveAssembleWithAssemble:(id)object fromTable:(NSString *)tableName {
    WXMFMDBWrapKeyValueStore * instance = [self sharedInstance];
    NSAssert([self judgeExsitUserID], @"请设置userID");
    [instance saveAssembleWithAssemble:object primaryKey:self.userID fromTable:tableName];
}

+ (id)getAssembleWithTable:(NSString *)tableName {
    NSAssert([self judgeExsitUserID], @"请设置userID");
    return [[self sharedInstance] getAssembleWithPrimaryKey:self.userID fromTable:tableName];
}


@end
