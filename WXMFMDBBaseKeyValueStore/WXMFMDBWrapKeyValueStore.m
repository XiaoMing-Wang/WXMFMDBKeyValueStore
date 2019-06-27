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

+ (void)saveCustomModelWithObject:(id)object {
    NSAssert([self judgeExsitUserID], @"请设置userID");
    [[self sharedInstance] saveCustomModelWithObject:object primaryKey:self.userID];
}

+ (id)getCustomModelWithClass:(Class)aClass {
    NSAssert([self judgeExsitUserID], @"请设置userID");
    return [[self sharedInstance] getCustomModelWithClass:aClass primaryKey:self.userID];
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
