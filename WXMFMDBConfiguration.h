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

/******************************** 表名 ********************************/

static WXMFMDBTableType const CUSTOM_CLASS = @"CUSTOM_CLASS";            /* model */
static WXMFMDBTableType const USER_INFORMATION = @"USER_INFORMATION";    /* 用户列表 */
static WXMFMDBTableType const USER_LIMITS = @"USER_LIMITS";              /* 权限 */
static WXMFMDBTableType const USER_BILL = @"USER_BILL";                  /* 账本 */

/******************************** 表名 ********************************/

#endif /* WXMFMDBManagerConfiguration_h */
