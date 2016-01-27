//
//  InviteJoinViewController.h
//  ECSDKDemo_OC
//
//  Created by jiazy on 14/12/8.
//  Copyright (c) 2014年 ronglian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
@interface InviteJoinViewController : UIViewController
@property (nonatomic, assign) id<SlideSwitchSubviewDelegate> mainView;
@property (nonatomic,strong)NSString * groupId;
@property(nonatomic, strong) NSMutableArray * showTableView;
@end
