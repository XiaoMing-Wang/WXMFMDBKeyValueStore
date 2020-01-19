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

/** 文件管理类 */
#define kFileManager [NSFileManager defaultManager]

/** Library目录 */
#define kLibraryboxPath \
NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject

/** file缓存文件夹 */
#define kFilePath \
[kLibraryboxPath stringByAppendingPathComponent:@"FILE_CACHE"]

/** file->视频文件夹 */
#define kTargetPath \
[kFilePath stringByAppendingPathComponent:@"WXMDataBase"]

#ifdef DEBUG
#define debugLog(...)    NSLog(__VA_ARGS__)
#define debugMethod()    NSLog(@"%s", __func__)
#define debugError()     NSLog(@"Error at %s Line:%d", __func__, __LINE__)
#else
#define debugLog(...)
#define debugMethod()
#define debugError()
#endif

#endif /* WXMFMDBManagerConfiguration_h */
