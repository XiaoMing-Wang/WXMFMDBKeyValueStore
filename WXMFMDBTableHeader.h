//
//  WXMFMDBTableHeader.h
//  WXMComponentization
//
//  Created by wxm on 2020/1/19.
//  Copyright © 2020 wxm. All rights reserved.
//

#ifndef WXMFMDBTableHeader_h
#define WXMFMDBTableHeader_h
#import <Foundation/Foundation.h>

typedef NSString *WXMFMDBTableType NS_STRING_ENUM;

/******************************** json表名 ********************************/

/* 用户列表 */
static WXMFMDBTableType const USER_INFORMATION = @"USER_INFORMATION";

/* 权限 */
static WXMFMDBTableType const USER_LIMITS = @"USER_LIMITS";

/* 账本 */
static WXMFMDBTableType const USER_BILL = @"USER_BILL";

/******************************** json表名 ********************************/

#endif /* WXMFMDBTableHeader_h */
