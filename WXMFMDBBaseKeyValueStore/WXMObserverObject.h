//
//  WXMObserverObject.h
//  ModuleDebugging
//
//  Created by edz on 2019/6/28.
//  Copyright © 2019 wq. All rights reserved.
//

/** 监听属性变化的object 适用与自定义model 更新属性时需要同步缓存 */
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol WXMObserverObjectCallBack <NSObject>
- (void)wxm_propertyChangeWithKey:(NSString *)key newValue:(id)value;
@end


@interface WXMObserverObject : NSObject

@property (nonatomic, weak) id<WXMObserverObjectCallBack> observer;

/** 参数变化调用函数 */
- (void)wxm_parametersChange;

@end

NS_ASSUME_NONNULL_END
