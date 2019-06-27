//
//  WXMFMDBManager.h
//  ModuleDebugging
//
//  Created by edz on 2019/6/27.
//  Copyright © 2019 wq. All rights reserved.
//

#import "WXMFMDBWrapKeyValueStore.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, WXMFMDBInstanceType) {
    /** 使用ClassName */
    WXMFMDBInstanceTypeUseClassName = 0,
    
    /** 用户资料 */
    WXMFMDBInstanceTypeUser,
    
    /** 用户权限 */
    WXMFMDBInstanceTypeLimits,
    
    /** 账本 */
    WXMFMDBInstanceTypeBill,
};

/** 设置tableName */
static inline NSString *WXMFMDBTypeConversion(WXMFMDBInstanceType type) {
    if (type == WXMFMDBInstanceTypeUseClassName) return nil;
    if (type == WXMFMDBInstanceTypeUser) return @"USER";
    if (type == WXMFMDBInstanceTypeLimits) return @"USERLIMITS";
    if (type == WXMFMDBInstanceTypeBill) return @"BILL";
    return nil;
}

@interface WXMFMDBManager : WXMFMDBWrapKeyValueStore

/** 需要调用改方法设置userID 数据库所有的表都使用userid作为key
 + (void)setUserID:(NSString *)userID; */

/** 父类的方法 type为 WXMFMDBInstanceTypeUseClassName */
+ (void)saveCustomModelWithObject:(id)object;
+ (id)getCustomModelWithClass:(Class)aClass;

/** 自己命名的表 */
+ (void)saveAssembleWithObject:(id)object instanceType:(WXMFMDBInstanceType)instanceType;
+ (id)getAssembleWithInstanceType:(WXMFMDBInstanceType)instanceType;
@end

NS_ASSUME_NONNULL_END
