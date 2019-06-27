//
//  WXMFMDBKeyValueStore.h
//  ModuleDebugging
//
//  Created by edz on 2019/6/26.
//  Copyright © 2019 wq. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/** 存储对象 */
@interface WXMKeyValueItem : NSObject
@property (strong, nonatomic) NSString *itemId;
@property (strong, nonatomic) id itemObject;
@property (strong, nonatomic) NSDate *createdTime;
@end

@interface WXMFMDBBaseKeyValueStore : NSObject

/************************ 数据库操作 *****************************************/

- (id)initDBWithName:(NSString *)dbName;
- (id)initWithDBWithPath:(NSString *)dbPath;
- (void)createTableWithName:(NSString *)tableName;
- (BOOL)isTableExists:(NSString *)tableName;
- (void)clearTable:(NSString *)tableName;
- (void)dropTable:(NSString *)tableName;
- (void)close;

/** 存储model */
- (void)saveCustomModelWithObject:(NSObject *)object primaryKey:(NSString *)primaryKey;
- (id)getCustomModelWithClass:(Class)aClass primaryKey:(NSString *)primaryKey;

/** 存储NSArray NSDictionary NSString NSNumber */
- (void)saveAssembleWithAssemble:(id<NSCopying,NSMutableCopying>)object
                      primaryKey:(NSString *)primaryKey
                       fromTable:(NSString *)tableName;

- (id)getAssembleWithPrimaryKey:(NSString *)primaryKey fromTable:(NSString *)tableName;

/** 获取 */
- (WXMKeyValueItem *)getWXMKeyValueItem:(NSString *)primaryKey fromTable:(NSString *)tableName;

/** 删除 */
- (void)deleteObject:(NSString *)primaryKey fromTable:(NSString *)tableName;
- (void)deleteObjects:(NSArray *)primaryKeyArray fromTable:(NSString *)tableName;
- (void)deleteObjectsByIdPrefix:(NSString *)objectIdPrefix fromTable:(NSString *)tableName;

/** 获取所有的item */
- (NSArray <WXMKeyValueItem *>*)getAllItemsFromTable:(NSString *)tableName;
- (NSUInteger)getCountFromTable:(NSString *)tableName;

@end

NS_ASSUME_NONNULL_END
