//
//  WXMFMDBManager.h
//  ModuleDebugging
//
//  Created by edz on 2019/6/27.
//  Copyright © 2019 wq. All rights reserved.
//

#import "WXMFMDBWrapKeyValueStore.h"

NS_ASSUME_NONNULL_BEGIN

@interface WXMFMDBManager : WXMFMDBWrapKeyValueStore
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

static inline NSString *WXMFMDBTypeConversion(WXMFMDBInstanceType type) {
    if (type == WXMFMDBInstanceTypeUseClassName) return nil;
    if (type == WXMFMDBInstanceTypeUser) return @"USER";
    if (type == WXMFMDBInstanceTypeLimits) return @"USERLIMITS";
    if (type == WXMFMDBInstanceTypeBill) return @"BILL";
    return nil;
}

/** WXMFMDBInstanceTypeUseClassName */
/** 父类的方法 */
+ (void)saveCustomModelWithObject:(id)object;
+ (id)getCustomModelWithClass:(Class)aClass;

/** 自己命名的表 */
+ (void)saveAssembleWithObject:(id)object instanceType:(WXMFMDBInstanceType)instanceType;
+ (id)getAssembleWithInstanceType:(WXMFMDBInstanceType)instanceType;
@end




NS_ASSUME_NONNULL_END
