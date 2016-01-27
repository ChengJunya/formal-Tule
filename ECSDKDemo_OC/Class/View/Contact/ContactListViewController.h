//
//  ContactListViewController.h
//  ECSDKDemo_OC
//
//  Created by jiazy on 14/12/5.
//  Copyright (c) 2014年 ronglian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import "SuperViewController.h"
@interface ContactListViewController : SuperViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, assign) id<SlideSwitchSubviewDelegate> mainView;
-(void)prepareDisplay;
@end
