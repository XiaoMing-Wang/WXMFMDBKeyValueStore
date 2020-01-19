//
//  WXMFMDBKeyValueStore.h
//  ModuleDebugging
//
//  Created by edz on 2019/6/26.
//  Copyright © 2019 wq. All rights reserved.
//
#define PrefixFormat @"WXMFORM_%@_LIST"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/** 存储到sql里的对象 */
@interface WXMKeyValueItem : NSObject
@property (strong, nonatomic) NSString *itemId;
@property (strong, nonatomic) id<NSCopying> itemObject;
@property (strong, nonatomic) NSDate *createdTime;
@end

@interface WXMFMDBBaseKeyValueStore : NSObject

/** 数据库操作 */
- (id)initDBWithName:(NSString *)dbName;
- (void)createTableWithName:(NSString *)tableName;
- (BOOL)isTableExists:(NSString *)tableName;
- (void)clearTable:(NSString *)tableName;
- (void)dropTable:(NSString *)tableName;
- (void)close;

/** 存储NSArray NSDictionary NSString NSNumber */
- (void)saveAssembleWithAssemble:(id<NSCopying>)object primaryKey:(NSString *)primaryKey fromTable:(NSString *)tableName;

/** 获取NSArray NSDictionary NSString NSNumber */
- (id)getAssembleWithPrimaryKey:(NSString *)primaryKey fromTable:(NSString *)tableName;

/** 删除 */
- (void)deleteObject:(NSString *)primaryKey fromTable:(NSString *)tableName;
- (void)deleteObjects:(NSArray *)primaryKeyArray fromTable:(NSString *)tableName;
- (void)deleteObjectsByIdPrefix:(NSString *)objectIdPrefix fromTable:(NSString *)tableName;

/** 获取所有的item */
- (NSArray <id>*)getAllItemsFromTable:(NSString *)tableName;
- (NSUInteger)getCountFromTable:(NSString *)tableName;

@end

NS_ASSUME_NONNULL_END
