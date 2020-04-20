//
//  WXMThreadAssistant.m
//  Multi-project-coordination
//
//  Created by wq on 2020/4/19.
//  Copyright © 2020 wxm. All rights reserved.
//

#import "WXMThreadAssistant.h"

@interface WXMThreadAssistant ()
@property (nonatomic, strong) dispatch_group_t group_t;
@end

@implementation WXMThreadAssistant

/** gcd调度组 */
- (void)enter_dispatch_group {
    if (self.group_t) dispatch_group_enter(self.group_t);
}

- (void)leave_dispatch_group {
    if (self.group_t) dispatch_group_leave(self.group_t);
}

- (void)notify_dispatch_groupCallBack:(void (^)(void))callback {
    if (!self.group_t || !callback) return;
    dispatch_group_notify(self.group_t, dispatch_get_main_queue(), callback);
}

/** 信号量限制数量 */
+ (void)semaphore_dispatchCallBack:(void (^)(kDispatchBlock results))callback {
    static dispatch_once_t onceToken;
    static dispatch_semaphore_t _semaphore;
    dispatch_queue_t queque = dispatch_queue_create("GoyakodCreated", DISPATCH_QUEUE_CONCURRENT);
    dispatch_once(&onceToken, ^{
        _semaphore = dispatch_semaphore_create(SEMAPHORECOUNT);
    });
    
    kDispatchBlock results = ^{
        dispatch_semaphore_signal(_semaphore);
    };
    
    dispatch_async(queque, ^{
        dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (callback) callback(results);
        });
    });
}


@end
