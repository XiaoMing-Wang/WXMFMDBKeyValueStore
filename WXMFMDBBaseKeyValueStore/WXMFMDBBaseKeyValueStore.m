//
//  WXMFMDBKeyValueStore.m
//  ModuleDebugging
//
//  Created by edz on 2019/6/26.
//  Copyright © 2019 wq. All rights reserved.
//

#import "WXMFMDBBaseKeyValueStore.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "FMDatabaseQueue.h"
#import "WXMFMDBConfiguration.h"

@implementation WXMKeyValueItem @end
@interface WXMFMDBBaseKeyValueStore ()
@property (strong, nonatomic) FMDatabaseQueue *dbQueue;
@end

@implementation WXMFMDBBaseKeyValueStore
static NSString *const DEFAULT_DB_NAME = @"userdatabase.sqlite";
static NSString *const CREATE_TABLE_SQL =
@"CREATE TABLE IF NOT EXISTS %@ ( \
id TEXT NOT NULL, \
json TEXT NOT NULL, \
createdTime TEXT NOT NULL, \
PRIMARY KEY(id)) ";

/** sql语句 */
static NSString *const UPDATE_ITEM_SQL = @"REPLACE INTO %@ (id, json, createdTime) values (?, ?, ?)";
static NSString *const QUERY_ITEM_SQL = @"SELECT json, createdTime from %@ where id = ? Limit 1";
static NSString *const SELECT_ALL_SQL = @"SELECT * from %@";
static NSString *const COUNT_ALL_SQL = @"SELECT count(*) as num from %@";
static NSString *const CLEAR_ALL_SQL = @"DELETE from %@";
static NSString *const DELETE_ITEM_SQL = @"DELETE from %@ where id = ?";
static NSString *const DELETE_ITEMS_SQL = @"DELETE from %@ where id in ( %@ )";
static NSString *const DELETE_ITEMS_WITH_PREFIX_SQL = @"DELETE from %@ where id like ? ";
static NSString *const DROP_TABLE_SQL = @" DROP TABLE '%@' ";

/** 存储NSArray NSDictionary NSString */
- (void)saveAssembleWithAssemble:(id<NSCoding,NSObject>)object primaryKey:(NSString *)primaryKey fromTable:(NSString *)tableName {
    tableName = [NSString stringWithFormat:PrefixFormat,tableName.uppercaseString];
    if ([self checkTableName:tableName] == NO) return;
    
    if ([object isKindOfClass:[NSArray class]] || [object isKindOfClass:[NSDictionary class]] ) {
        
        [self putObject:object withId:primaryKey intoTable:tableName];
        
    } else if ([object isKindOfClass:[NSString class]]) {
        
        NSString *aString = (NSString *)object;
        [self putString:aString withId:primaryKey intoTable:tableName];
        
    } else if ([object isKindOfClass:[NSNumber class]]) {
        
        NSNumber *aNumber = (NSNumber *) object;
        [self putNumber:aNumber withId:primaryKey intoTable:tableName];
        
    } else if ([object isKindOfClass:[NSObject class]]) {
        
        debugLog(@"ERROR, object class is NSObject");
    }
}

- (id)getAssembleWithPrimaryKey:(NSString *)primaryKey fromTable:(NSString *)tableName {
    
    tableName = [NSString stringWithFormat:PrefixFormat, tableName.uppercaseString];
    if ([self checkTableName:tableName] == NO) return nil;
    WXMKeyValueItem *item = [self getWXMKeyValueItem:primaryKey fromTable:tableName];
    return item.itemObject ?: nil;
    
}

/************************ 数据库操作 *****************************************/

+ (void)load {
    BOOL isDir = NO;
    BOOL isExists = [kFileManager fileExistsAtPath:kTargetPath isDirectory:&isDir];
    if (!isExists || !isDir) {
        [kFileManager createDirectoryAtPath:kTargetPath
                withIntermediateDirectories:YES
                                 attributes:nil
                                      error:nil];
    }
}

- (id)init {
    return [self initDBWithName:DEFAULT_DB_NAME];
}

- (id)initDBWithName:(NSString *)dbName {
    if (self = [super init]) {
        NSString *dbPath = [kTargetPath stringByAppendingPathComponent:dbName];
        if (_dbQueue) [self close];
        _dbQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
        debugLog(@"dbPath = %@", dbPath);
    }
    return self;
}

/** 校验tableName合法性和创建表单 */
- (BOOL)checkTableName:(NSString *)tableName {
    if (tableName == nil || tableName.length == 0 || [tableName rangeOfString:@" "].location != NSNotFound) {
        debugLog(@"ERROR, table name: %@ format error.", tableName);
        return NO;
    }
    
    if (![self isTableExists:tableName]) [self createTableWithName:tableName];
    return YES;
}

/** 是否存在表 */
- (BOOL)isTableExists:(NSString *)tableName {
    if (!tableName) return NO;
    __block BOOL result;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        result = [db tableExists:tableName];
    }];
    
    if (!result) {
        debugLog(@"table: %@ not exists in current DB", tableName);
    }
    return result;
}

/** 创建表 */
- (void)createTableWithName:(NSString *)tableName {
    if (!tableName) return;
    NSString * sql = [NSString stringWithFormat:CREATE_TABLE_SQL, tableName];
    __block BOOL result;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:sql];
    }];
    
    if (!result) {
        debugLog(@"ERROR, failed to create table: %@", tableName);
    }
}

/** 清空表 */
- (void)clearTable:(NSString *)tableName {
    if ([self checkTableName:tableName] == NO)  return;
   
    NSString * sql = [NSString stringWithFormat:CLEAR_ALL_SQL, tableName];
    __block BOOL result;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:sql];
    }];
    if (!result) {
        debugLog(@"ERROR, failed to clear table: %@", tableName);
    }
}

/** 删除表 */
- (void)dropTable:(NSString *)tableName {
    if (!tableName) return;
    
    NSString * sql = [NSString stringWithFormat:DROP_TABLE_SQL, tableName];
    __block BOOL result;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:sql];
    }];
    if (!result) {
        debugLog(@"ERROR, failed to drop table: %@", tableName);
    }
}

/************************ Put&Get methods<封装对象> *****************************************/

/** obj */
- (void)putObject:(id)object withId:(NSString *)objectId intoTable:(NSString *)tableName {
    if ([self checkTableName:tableName] == NO) return;
   
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:object options:0 error:&error];
    if (error) {
        debugLog(@"ERROR, faild to get json data");
        return;
    }
    
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:(NSUTF8StringEncoding)];
    NSDate *createdTime = [NSDate date];
    NSString *sql = [NSString stringWithFormat:UPDATE_ITEM_SQL, tableName];
    __block BOOL result;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:sql, objectId, jsonString, createdTime];
    }];
    
    if (!result) {
        debugLog(@"ERROR, failed to insert/replace into table: %@", tableName);
    }
}

/** 获取保存的WXMKeyValueItem */
- (WXMKeyValueItem *)getWXMKeyValueItem:(NSString *)primaryKey fromTable:(NSString *)tableName {
    if ([self checkTableName:tableName] == NO) return nil;
    
    NSString * sql = [NSString stringWithFormat:QUERY_ITEM_SQL, tableName];
    __block NSString * json = nil;
    __block NSDate * createdTime = nil;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet * rs = [db executeQuery:sql, primaryKey];
        if ([rs next]) {
            json = [rs stringForColumn:@"json"];
            createdTime = [rs dateForColumn:@"createdTime"];
        }
        [rs close];
    }];
    
    if (json) {
        NSError * error;
        id result = [NSJSONSerialization
                     JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding]
                     options:(NSJSONReadingAllowFragments)
                     error:&error];
        if (error) {
            debugLog(@"ERROR, faild to prase to json");
            return nil;
        }
        WXMKeyValueItem * item = [[WXMKeyValueItem alloc] init];
        item.itemId = primaryKey;
        item.itemObject = result;
        item.createdTime = createdTime;
        return item;
    }
    return nil;
    
}

/** NSString */
- (void)putString:(NSString *)string withId:(NSString *)stringId intoTable:(NSString *)tableName {
    if (string == nil) {
        debugLog(@"error, string is nil");
        return;
    }
    [self putObject:@[string] withId:stringId intoTable:tableName];
}

- (NSString *)getStringById:(NSString *)stringId fromTable:(NSString *)tableName {
    NSArray *array = [self getWXMKeyValueItem:stringId fromTable:tableName].itemObject;
    if (array && [array isKindOfClass:[NSArray class]]) return array.firstObject;
    return nil;
}

/** NSNumber */
- (void)putNumber:(NSNumber *)number withId:(NSString *)numberId intoTable:(NSString *)tableName {
    if (number == nil) {
        debugLog(@"error, number is nil");
        return;
    }
    [self putObject:@[number] withId:numberId intoTable:tableName];
}

- (NSNumber *)getNumberById:(NSString *)numberId fromTable:(NSString *)tableName {
    NSArray *array = [self getWXMKeyValueItem:numberId fromTable:tableName].itemObject;
    if (array && [array isKindOfClass:[NSArray class]]) return array.firstObject;
    return nil;
}

/** 获取所有表所有的数据 */
- (NSArray <id>*)getAllItemsFromTable:(NSString *)tableName {
    
    if ([self checkTableName:tableName] == NO) return nil;
    NSString * sql = [NSString stringWithFormat:SELECT_ALL_SQL, tableName];
    __block NSMutableArray *result = [NSMutableArray array];
    [_dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]) {
            WXMKeyValueItem *item = [[WXMKeyValueItem alloc] init];
            item.itemId = [rs stringForColumn:@"id"];
            id object = [rs stringForColumn:@"json"];
            item.itemObject = [NSJSONSerialization JSONObjectWithData:[object dataUsingEncoding:NSUTF8StringEncoding] options:(NSJSONReadingAllowFragments) error:nil];
            item.createdTime = [rs dateForColumn:@"createdTime"];
            if (item.itemObject) [result addObject:item.itemObject];
        }
        [rs close];
    }];

    return result;
}

/** 获取个数 */
- (NSUInteger)getCountFromTable:(NSString *)tableName {
    if ([self checkTableName:tableName] == NO) return 0;
    
    NSString * sql = [NSString stringWithFormat:COUNT_ALL_SQL, tableName];
    __block NSInteger num = 0;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet * rs = [db executeQuery:sql];
        if ([rs next]) {
            num = [rs unsignedLongLongIntForColumn:@"num"];
        }
        [rs close];
    }];
    return num;
}

/** 删除表中的primaryKey数据 */
- (void)deleteObject:(NSString *)primaryKey fromTable:(NSString *)tableName {
    if ([self checkTableName:tableName] == NO) return;
   
    NSString * sql = [NSString stringWithFormat:DELETE_ITEM_SQL, tableName];
    __block BOOL result;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:sql, primaryKey];
    }];
    if (!result) {
        debugLog(@"ERROR, failed to delete item from table: %@", tableName);
    }
}

- (void)deleteObjects:(NSArray *)primaryKeyArray fromTable:(NSString *)tableName {
    if ([self checkTableName:tableName] == NO) return;
   
    NSMutableString *stringBuilder = [NSMutableString string];
    for (id objectId in primaryKeyArray) {
        NSString *item = [NSString stringWithFormat:@" '%@' ", objectId];
        if (stringBuilder.length == 0) {
            [stringBuilder appendString:item];
        } else {
            [stringBuilder appendString:@","];
            [stringBuilder appendString:item];
        }
    }
    NSString *sql = [NSString stringWithFormat:DELETE_ITEMS_SQL, tableName, stringBuilder];
    __block BOOL result;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:sql];
    }];
    if (!result) {
        debugLog(@"ERROR, failed to delete items by ids from table: %@", tableName);
    }
}

/** 删除前缀是objectIdPrefix的 */
- (void)deleteObjectsByIdPrefix:(NSString *)objectIdPrefix fromTable:(NSString *)tableName {
    if ([self checkTableName:tableName] == NO) return;
    
    NSString *sql = [NSString stringWithFormat:DELETE_ITEMS_WITH_PREFIX_SQL, tableName];
    NSString *prefixArgument = [NSString stringWithFormat:@"%@%%", objectIdPrefix];
    __block BOOL result;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:sql, prefixArgument];
    }];
    if (!result) {
        debugLog(@"ERROR, failed to delete items by id prefix from table: %@", tableName);
    }
}

- (void)close {
    [_dbQueue close];
    _dbQueue = nil;
}

@end
