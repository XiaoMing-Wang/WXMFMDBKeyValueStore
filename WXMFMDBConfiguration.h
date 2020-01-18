//
//  WXMFMDBManagerConfiguration.h
//  ModuleDebugging
//
//  Created by edz on 2019/9/4.
//  Copyright © 2019 wq. All rights reserved.
//

#import <Foundation/Foundation.h>
#ifndef WXMFMDBManagerConfiguration_h
#define WXMFMDBManagerConfiguration_h

typedef NSString *WXMFMDBTableType NS_STRING_ENUM;

/******************************** json表名 ********************************/

/* 用户列表 */
static WXMFMDBTableType const USER_INFORMATION = @"USER_INFORMATION";

/* 权限 */
static WXMFMDBTableType const USER_LIMITS = @"USER_LIMITS";

/* 账本 */
static WXMFMDBTableType const USER_BILL = @"USER_BILL";

/******************************** json表名 ********************************/

#endif /* WXMFMDBManagerConfiguration_h */
