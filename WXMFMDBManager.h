//
//  WXMFMDBManager.h
//  ModuleDebugging
//
//  Created by edz on 2019/6/27.
//  Copyright © 2019 wq. All rights reserved.
//

#import "WXMFMDBWrapKeyValueStore.h"

NS_ASSUME_NONNULL_BEGIN

/** 忽略大小写 自动转化成全大写 */
/** 数据库自动加前缀 建议不使用前缀 */
/** WXMFMDBInstanceType = 0时使用model 如WXMFORM_XXMODEL_LIST */
/** WXMFMDBInstanceType > 0时使用枚举名 如WXMFORM_USER_INFORMATION_LIST */
typedef NS_ENUM(NSInteger, WXMFMDBInstanceType) {
    
    /** 使用ClassName */
    CUSTOM_CLASS = 0,
    
    /** 用户资料 */
    USER_INFORMATION,
    
    /** 用户权限 */
    USER_LIMITS,
    
    /** 账本 */
    USER_BILL,
};

@interface WXMFMDBManager : WXMFMDBWrapKeyValueStore

#pragma mark 父类的方法
/** 需要调用改方法设置userID 数据库所有的表都使用userid作为key */
 + (void)setUserID:(NSString *)userID;

/** 父类的方法 type为 WXMFMDBInstanceTypeUseClassName */
+ (void)saveCustomModelWithObject:(id)object;
+ (id)getCustomModelWithClass:(Class)aClass;

+ (void)saveCustomModelWithObjects:(NSArray <NSObject *>*)objectArray;
+ (NSArray <NSObject *>*)getCustomModelArrayWithClass:(Class)aClass;

#pragma mark 自己的方法
/** 自己命名的表 传自定义model会调用saveCustomModelWithObject */
+ (void)saveAssembleWithObject:(id)object instanceType:(WXMFMDBInstanceType)instanceType;
+ (id)getAssembleWithInstanceType:(WXMFMDBInstanceType)instanceType;
@end

NS_ASSUME_NONNULL_END
