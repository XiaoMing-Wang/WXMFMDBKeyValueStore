//
//  WXMFMDBInstanceKeyValueStore.h
//  ModuleDebugging
//
//  Created by edz on 2019/6/27.
//  Copyright © 2019 wq. All rights reserved.
//
/** tableName不区分大小写 */
#import "WXMFMDBBaseKeyValueStore.h"

NS_ASSUME_NONNULL_BEGIN

@interface WXMFMDBWrapKeyValueStore : WXMFMDBBaseKeyValueStore

/** 以用户ID作为key */
@property (nonatomic, strong, readonly) NSString *userID;

/** 设置userID 所有的表都使用userID作为key */
+ (void)setUserID:(NSString *)userID;

/** 存取json (NSString, NSArray,NSDictionary) */
+ (void)saveAssembleWithAssemble:(id<NSCopying>)object fromTable:(NSString *)tableName;

/** 获取json (NSString, NSArray,NSDictionary)  */
+ (id<NSCopying>)getAssembleWithTable:(NSString *)tableName;

/** 删除缓存 */
+ (void)deleteObjectFromTable:(NSString *)tableName;

/** 删除列表 */
+ (void)clearCustomTable:(NSString *)tableName;

@end

NS_ASSUME_NONNULL_END
