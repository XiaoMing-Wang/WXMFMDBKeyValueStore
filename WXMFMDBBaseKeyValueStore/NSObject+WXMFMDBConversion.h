//
//  NSObject+WXMFMDBConversion.h
//  ModuleDebugging
//
//  Created by edz on 2019/6/27.
//  Copyright © 2019 wq. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (WXMFMDBConversion)

#pragma mark - 公用方法

/** 设置对应的key  */
//- (NSDictionary *)wxm_modelMapPropertyNames;

/** 字典->模型 */
+ (instancetype)wxm_modelWithKeyValue:(NSDictionary *)dictionary;

/** 模型->字典 */
- (NSDictionary *)wxm_modelToKeyValue;

@end

NS_ASSUME_NONNULL_END
