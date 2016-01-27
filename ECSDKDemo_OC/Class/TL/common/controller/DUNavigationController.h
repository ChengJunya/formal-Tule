//
//  DUNavigationController.h
//  alijk
//
//  Created by easy on 14-7-30.
//  Copyright (c) 2014年 zhongxin. All rights reserved.
//

#import <UIKit/UIKit.h>

#define KEY_WINDOW  [[UIApplication sharedApplication]keyWindow]
#define kkBackViewHeight [UIScreen mainScreen].bounds.size.height
#define kkBackViewWidth [UIScreen mainScreen].bounds.size.width

#define iOS7  ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )

// 背景视图起始frame.x
#define startX (-200)

@interface DUNavigationController : UINavigationController{
       CGFloat startBackViewX;
}

- (void)showOrHideTallItem:(BOOL)hide;
- (void)setNavBackToVCName:(NSString*)vcname;
- (void)navBackAction;

// 默认为特效开启
@property (nonatomic, assign) BOOL canDragBack;
@property (nonatomic,assign) BOOL isResinKeyboard;

@end
