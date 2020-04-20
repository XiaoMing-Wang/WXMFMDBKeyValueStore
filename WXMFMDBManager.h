//
//  WXMFMDBManager.h
//  ModuleDebugging
//
//  Created by edz on 2019/6/27.
//  Copyright © 2019 wq. All rights reserved.
//
#import "WXMFMDBTableHeader.h"
#import "WXMFMDBWrapKeyValueStore.h"
NS_ASSUME_NONNULL_BEGIN

@interface WXMFMDBManager : WXMFMDBWrapKeyValueStore

#pragma mark 父类的方法

/** 需要调用改方法设置userID 数据库所有的表都使用userid作为key */
+ (void)wf_setUserID:(NSString *)userID;

/** 存取对象 */
+ (void)wf_saveModelWithObject:(id)object;
+ (id)wf_getModelWithClass:(Class)aClass;

/** 存取对象数组 */
+ (void)wf_saveModelArraysWithObjects:(NSArray *)objects;
+ (NSArray *)wf_getModelArraysWithClass:(Class)aClass;

/** 存取json */
+ (void)wf_saveAssembleWithObject:(id)object instanceType:(WXMFMDBTableType)instanceType;
+ (id)wf_getAssembleWithInstanceType:(WXMFMDBTableType)instanceType;

/** 删除缓存 */
+ (void)wf_deleteObjectWithClass:(Class)aClass;
+ (void)wf_deleteObjectWithInstanceType:(WXMFMDBTableType)instanceType;

@end

NS_ASSUME_NONNULL_END
