//
//  WXMFMDBObserverObject.h
//  ModuleDebugging
//
//  Created by edz on 2019/6/28.
//  Copyright © 2019 wq. All rights reserved.
//

/** 监听属性变化的object 适用与自定义model 更新属性时需要同步缓存 */
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WXMObserverObject : NSObject

/** 参数变化调用函数 */
- (void)wf_parametersChange;

@end

NS_ASSUME_NONNULL_END
