//
//  WXMFMDBInstanceKeyValueStore.m
//  ModuleDebugging
//
//  Created by edz on 2019/6/27.
//  Copyright © 2019 wq. All rights reserved.
//
#import "WXMFMDBWrapKeyValueStore.h"

@interface WXMFMDBWrapKeyValueStore ()
@property (nonatomic, strong, readwrite) NSString *userID;
@end

@implementation WXMFMDBWrapKeyValueStore

+ (instancetype)sharedInstance {
    static WXMFMDBWrapKeyValueStore *instance = nil;
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
    return [[self sharedInstance] userID];
}

+ (void)saveAssembleWithAssemble:(id)object fromTable:(NSString *)tableName {
    NSAssert([self judgeExsitUserID], @"请设置userID");
    if (![self judgeExsitUserID]) return;
    [self.sharedInstance saveAssembleWithAssemble:object primaryKey:self.userID fromTable:tableName];
}

+ (id)getAssembleWithTable:(NSString *)tableName {
    NSAssert([self judgeExsitUserID], @"请设置userID");
    if (![self judgeExsitUserID]) return nil;
    return [[self sharedInstance] getAssembleWithPrimaryKey:self.userID fromTable:tableName];
}

+ (void)deleteObjectFromTable:(NSString *)tableName {
    NSAssert([self judgeExsitUserID], @"请设置userID");
    if (![self judgeExsitUserID]) return;
    [[self.class sharedInstance] deleteObject:self.userID fromTable:tableName];
}

+ (void)clearCustomTable:(NSString *)tableName {
    NSAssert([self judgeExsitUserID], @"请设置userID");
    if (![self judgeExsitUserID]) return;
    [[self.class sharedInstance] clearTable:tableName];
}
@end
