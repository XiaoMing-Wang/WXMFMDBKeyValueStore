//
//  WXMFMDBManager.h
//  ModuleDebugging
//
//  Created by edz on 2019/6/27.
//  Copyright © 2019 wq. All rights reserved.
//
#import "WXMFMDBWrapKeyValueStore.h"
NS_ASSUME_NONNULL_BEGIN

typedef NSString *WXMFMDBTableType NS_STRING_ENUM;

/******************************** 表名 ********************************/
static WXMFMDBTableType const CUSTOM_CLASS = @"CUSTOM_CLASS";            /* model */
static WXMFMDBTableType const USER_INFORMATION = @"USER_INFORMATION";    /* 用户列表 */
static WXMFMDBTableType const USER_LIMITS = @"USER_LIMITS";              /* 权限 */
static WXMFMDBTableType const USER_BILL = @"USER_BILL";                  /* 账本 */
/******************************** 表名 ********************************/

@interface WXMFMDBManager : WXMFMDBWrapKeyValueStore

#pragma mark 父类的方法
/** 需要调用改方法设置userID 数据库所有的表都使用userid作为key */
 + (void)wxm_setUserID:(NSString *)userID;

/** 父类的方法 type为 WXMFMDBInstanceTypeUseClassName */
+ (void)wxm_saveCustomModelWithObject:(id)object;
+ (void)wxm_saveCustomModelWithObjects:(NSArray <NSObject *>*)objectArray;

+ (id)wxm_getCustomModelWithClass:(Class)aClass;
+ (NSArray <NSObject *>*)wxm_getCustomModelArrayWithClass:(Class)aClass;

#pragma mark 自己的方法
+ (void)wxm_saveAssembleWithObject:(id)object instanceType:(WXMFMDBTableType)instanceType;
+ (id)wxm_getAssembleWithInstanceType:(WXMFMDBTableType)instanceType;
@end

NS_ASSUME_NONNULL_END
