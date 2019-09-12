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
    
    @try {
        NSString *tableName = NSStringFromClass([object class]);
        NSDictionary *dictionary = [object wxm_modelToKeyValue];
        [self saveAssembleWithAssemble:dictionary fromTable:tableName];
    } @catch (NSException *exception) {} @finally {}
}

+ (NSObject *)getCustomModelWithClass:(Class)aClass {
    NSAssert([self judgeExsitUserID], @"请设置userID");
    
    @try {
        id dictionary = [self getAssembleWithTable:NSStringFromClass(aClass)];
        if ([dictionary isKindOfClass:[NSDictionary class]]) {
            return [aClass wxm_modelWithKeyValue:dictionary];
        }
    } @catch (NSException *exception) {} @finally {}
    
    return nil;
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
