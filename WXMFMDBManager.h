//
//  WXMFMDBManager.h
//  ModuleDebugging
//
//  Created by edz on 2019/6/27.
//  Copyright © 2019 wq. All rights reserved.
//
#import "WXMFMDBConfiguration.h"
#import "WXMFMDBWrapKeyValueStore.h"
NS_ASSUME_NONNULL_BEGIN

@interface WXMFMDBManager : WXMFMDBWrapKeyValueStore

#pragma mark 父类的方法
/** 需要调用改方法设置userID 数据库所有的表都使用userid作为key */
+ (void)wf_setUserID:(NSString *)userID;

/** 对象 */
+ (void)wf_saveCustomModelWithObject:(id)object;
+ (id)wf_getCustomModelWithClass:(Class)aClass;

/** json */
+ (void)wf_saveAssembleWithObject:(id<NSCoding>)object instanceType:(WXMFMDBTableType)instanceType;
+ (id)wf_getAssembleWithInstanceType:(WXMFMDBTableType)instanceType;
@end

NS_ASSUME_NONNULL_END
