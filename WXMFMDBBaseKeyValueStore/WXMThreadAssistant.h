//
//  WXMThreadAssistant.h
//  Multi-project-coordination
//
//  Created by wq on 2020/4/19.
//  Copyright © 2020 wxm. All rights reserved.
//
#define SEMAPHORECOUNT 1
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^kDispatchBlock)(void);
@interface WXMThreadAssistant : NSObject

/** gcd调度组 */
- (void)enter_dispatch_group;
- (void)leave_dispatch_group;
- (void)notify_dispatch_groupCallBack:(void (^)(void))callback;

/** 信号量 */
+ (void)semaphore_dispatchCallBack:(void (^)(kDispatchBlock results))callback;

@end

NS_ASSUME_NONNULL_END
