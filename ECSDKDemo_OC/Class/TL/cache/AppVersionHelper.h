//
//  AppVersionHelper.h
//  alijk
//
//  Created by easy on 14-10-22.
//  Copyright (c) 2014年 zhongxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UpdateInfoResponseDTO.h"
@interface AppVersionHelper : NSObject

ZX_DECLARE_SINGLETON(AppVersionHelper)

/*
 * 打开appstore上的页面
 */
- (void)openAppStoreURL;

/*
 * 获取当前版本号
 */
- (NSString*)appVersion;

/*
 * 有新的版本
 */
- (BOOL)hasNewVersion;

/*
 * 检测是否需要升级app
 * requestArr：能保持请求tag的数组
 * blcok：updateFlag：升级标志（-1：不需要升级 0：可以升级 1：需要强制升级）latestVersion：最新的版本号
 */
- (void)checkVersionUpdate:(__weak NSMutableArray*)requestArr block:(void (^)(int updateFlag, NSString *latestVersion,UpdateInfoResponseDTO *versionData))block;

@end
