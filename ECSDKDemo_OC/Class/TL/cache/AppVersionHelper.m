//
//  AppVersionHelper.m
//  alijk
//
//  Created by easy on 14-10-22.
//  Copyright (c) 2014年 zhongxin. All rights reserved.
//

#import "AppVersionHelper.h"
#import "UpdateInfoRequestDTO.h"
#import "UpdateInfoResponseDTO.h"

@interface AppVersionHelper ()

@property (nonatomic, assign) NSInteger updateFlag;
@property (nonatomic,strong) UpdateInfoResponseDTO *versionData;
@end


@implementation AppVersionHelper

ZX_IMPLEMENT_SINGLETON(AppVersionHelper)

/*
 * 打开appstore上的页面
 */
- (void)openAppStoreURL
{
    NSString *appURL = [self.versionData.result appURL];// [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",APPLEID];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appURL]];
}

/*
 * 获取当前版本号
 */
- (NSString*)appVersion
{
    return ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]);
}

- (NSString*)buildNumber
{
    return ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]);
}

/*
 * 检测是否需要升级app
 * requestArr：能保持请求tag的数组
 * blcok：updateFlag：升级标志（-1：不需要升级 0：可以升级 1：需要强制升级）latestVersion：最新的版本号
 */
- (void)checkVersionUpdate:(__weak NSMutableArray*)requestArr block:(void (^)(int updateFlag, NSString *latestVersion,UpdateInfoResponseDTO *versionData))block
{
    __block int flag = -1;
    NSString *appVersion = [self appVersion];
    //NSString *buildNumber = [self buildNumber];
    UpdateInfoRequestDTO *request = [[UpdateInfoRequestDTO alloc] init];
    request.platForm = @"ios";//ios android
    request.version = appVersion;
    NSNumber *requestTag = [GDataManager asyncRequestByType:NetAdapter_GetUpdateVersion andObject:request success:^(UpdateInfoResponseDTO * responseDTO) {
        if (NSOrderedAscending == [appVersion compare:responseDTO.result.updateVersion options:NSNumericSearch]) {
            flag = 0;
            if ([@"1" isEqualToString:(responseDTO.result.update)]) {
                flag = 1;
            }
        }
        if (block) {
            block(flag, responseDTO.result.updateVersion,responseDTO);
        }
        self.updateFlag = flag;
    }failure:^(id responseDTO) {
        if (block) {
            block(flag, @"",responseDTO);
        }
        self.updateFlag = flag;
    }];
    [requestArr addObject:requestTag];
}

/*
 * 有新的版本
 */
- (BOOL)hasNewVersion
{
    return (self.updateFlag >= 0);
}

@end
