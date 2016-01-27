//
//  SelectViewController.h
//  ECSDKDemo_OC
//
//  Created by lrn on 14/12/15.
//  Copyright (c) 2014年 ronglian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
@interface SelectViewController : UIViewController
@property (nonatomic, assign) id<SlideSwitchSubviewDelegate> mainView;
@property (nonatomic,strong)NSString * groupId;
@property(nonatomic,strong)NSDictionary * dict;
@end
