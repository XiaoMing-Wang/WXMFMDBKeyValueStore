//
//  WXMFMDBInstanceKeyValueStore.m
//  ModuleDebugging
//
//  Created by edz on 2019/6/27.
//  Copyright © 2019 wq. All rights reserved.
//

#import "WXMFMDBWrapKeyValueStore.h"
#import "NSObject+WXMFMDBConversion.h"

@interface WXMFMDBWrapKeyValueStore ()
@property (nonatomic, strong, readwrite) NSString *userID;
@end

@implementation WXMFMDBWrapKeyValueStore

+ (instancetype)sharedInstance {
    static WXMFMDBWrapKeyValueStore * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

/** 设置userID 所有的表使用userID作为key */
+ (void)setUserID:(NSString *)userID {
    [self.sharedInstance setUserID:userID];
}

+ (BOOL)judgeExsitUserID {
    return ([self.sharedInstance userID].length > 0);
}

+ (NSString *)userID {
    return [self.sharedInstance userID];
}

#pragma mark _____________________________________________ model

+ (void)saveCustomModelWithObject:(NSObject *)object {
    NSAssert([self judgeExsitUserID], @"请设置userID");
    
    NSString *tableName = NSStringFromClass([object class]);
    NSDictionary *dictionary = [object wxm_modelToKeyValue];
    [self saveAssembleWithAssemble:dictionary fromTable:tableName];
}

/** 存数组 */
+ (void)saveCustomModelWithObjectArray:(NSArray <NSObject *>*)objectArray {
    NSAssert([self judgeExsitUserID], @"请设置userID");
    
    id firstObj = objectArray.firstObject;
    if (objectArray.count == 0 || !firstObj) return;
    
    NSMutableArray *array = @[].mutableCopy;
    NSString *tableName = NSStringFromClass([firstObj class]);
    [objectArray enumerateObjectsUsingBlock:^(NSObject *obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *json = obj.wxm_modelToKeyValue;
        [array addObject:json];
    }];
    
    [self saveAssembleWithAssemble:array fromTable:tableName];
}

+ (NSObject *)getCustomModelWithClass:(Class)aClass {
    NSAssert([self judgeExsitUserID], @"请设置userID");
    
    id dictionary = [self getAssembleWithTable:NSStringFromClass(aClass)];
    if ([dictionary isKindOfClass:[NSDictionary class]]) {
        return [aClass wxm_modelWithKeyValue:dictionary];
    }
    return nil;
}

+ (NSArray <NSObject *>*)getCustomModelArrayWithClass:(Class)aClass {
    NSAssert([self judgeExsitUserID], @"请设置userID");
    
    NSString *tableName = NSStringFromClass(aClass);
    NSArray *array = (NSArray *) [self getAssembleWithTable:tableName];
    NSMutableArray *modelArray = @[].mutableCopy;
    [array enumerateObjectsUsingBlock:^(NSDictionary *dictionary, NSUInteger idx, BOOL *stop) {
        id object = [aClass wxm_modelWithKeyValue:dictionary];
        if (object) [modelArray addObject:object];
    }];
    return modelArray.copy;
}

#pragma mark _____________________________________________ json

+ (void)saveAssembleWithAssemble:(id)object fromTable:(NSString *)tableName {
    NSAssert([self judgeExsitUserID], @"请设置userID");
    [self.sharedInstance saveAssembleWithAssemble:object
                                       primaryKey:self.userID
                                        fromTable:tableName];
}

+ (id)getAssembleWithTable:(NSString *)tableName {
    NSAssert([self judgeExsitUserID], @"请设置userID");
    return [self.sharedInstance getAssembleWithPrimaryKey:self.userID fromTable:tableName];
}

/** 删除列表 */
- (void)clearCustomTable:(NSString *)tableName {
    [self.class.sharedInstance clearTable:tableName];
}
@end
