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

@interface WXMFMDBKeyValueStore : NSObject

+ (instancetype)sharedInstance;

/************************ 数据库操作 *****************************************/

- (id)initDBWithName:(NSString *)dbName;
- (id)initWithDBWithPath:(NSString *)dbPath;
- (void)createTableWithName:(NSString *)tableName;
- (BOOL)isTableExists:(NSString *)tableName;
- (void)clearTable:(NSString *)tableName;
- (void)dropTable:(NSString *)tableName;
- (void)close;

/************************ Put&Get methods<model> *****************************************/

/** 存储model */
- (void)saveModelWithObject:(NSObject *)object primaryKey:(NSString *)primaryKey;
- (id)getModelWithPrimaryKey:(NSString *)primaryKey;


/** 存储NSArray NSDictionary NSString NSNumber */
- (void)saveAssembleWithAssemble:(id<NSCoding,NSObject,NSMutableCopying>)object
                      primaryKey:(NSString *)primaryKey
                       fromTable:(NSString *)tableName;

- (id<NSCoding>)getAssembleWithPrimaryKey:(NSString *)primaryKey;

/************************ Put&Get methods<封装对象> *****************************************/


/** 把json封装成对象存储 */
/** 获取对象 */
- (WXMKeyValueItem *)getWXMKeyValueItemById:(NSString *)objectId fromTable:(NSString *)tableName;

///** 获取对象 NSDictionary NSArray */
//- (void)putObject:(id)object withId:(NSString *)objectId intoTable:(NSString *)tableName;
//- (id)getObjectById:(NSString *)objectId fromTable:(NSString *)tableName;
//
///** 存储string */
//- (void)putString:(NSString *)string withId:(NSString *)stringId intoTable:(NSString *)tableName;
//- (NSString *)getStringById:(NSString *)stringId fromTable:(NSString *)tableName;
//
///** 存储number */
//- (void)putNumber:(NSNumber *)number withId:(NSString *)numberId intoTable:(NSString *)tableName;
//- (NSNumber *)getNumberById:(NSString *)numberId fromTable:(NSString *)tableName;

/** 获取所有的item */
- (NSArray *)getAllItemsFromTable:(NSString *)tableName;
- (NSUInteger)getCountFromTable:(NSString *)tableName;

/** 删除 */
- (void)deleteObjectById:(NSString *)objectId fromTable:(NSString *)tableName;
- (void)deleteObjectsByIdArray:(NSArray *)objectIdArray fromTable:(NSString *)tableName;
- (void)deleteObjectsByIdPrefix:(NSString *)objectIdPrefix fromTable:(NSString *)tableName;

@end

NS_ASSUME_NONNULL_END
