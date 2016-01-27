//
//  TLHelper.h
//  TL
//
//  Created by Rainbow on 2/4/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SuperViewController.h"
#import "BaseTabbarViewController.h"
@interface TLHelper : NSObject

ZX_DECLARE_SINGLETON(TLHelper)

@property (nonatomic,assign) BOOL hasNewMessage;// YES NO  有新通知
@property (nonatomic,assign) BOOL hasNewSystemMessage;// YES NO  有新系统通知
@property (nonatomic,assign) BOOL hasNewVersion;// YES NO  有新版本更新
@property (nonatomic,strong) NSString *systemMessageCount;



@property (nonatomic,strong) BaseTabbarViewController *rootViewController;
-(void)gotoHomeViewController;
-(void)gotoLoginViewController;
-(void)gotoUserGuideController;

-(void)gotoRootViewController;
-(void)pushViewControllerWithName:(NSString*)vcname block:(Id_Block)block;
-(void)pushViewControllerWithName:(NSString*)vcname  itemData:(id)itemData block:(Id_Block)block;
-(void)poptoViewControllerWithName:(NSString*)vcname  itemData:(id)itemData block:(Id_Block)block;
-(void)presentViewControllerWithName:(NSString*)vcname  itemData:(id)itemData block:(Id_Block)block;

-(void)autoLogin;

-(void)handleNotice:(NSDictionary*)userInfo;

-(void)gotoUserInfoView:(NSString *)loginId;
-(void)gotoGroupInfoView:(NSString *)groupId;

-(void)checkHasNewMessage;
-(void)gotoWaitingViewController;

-(void)saveAndShowImage:(UIImage*)image imageName:(NSString*)imageName;


@end
