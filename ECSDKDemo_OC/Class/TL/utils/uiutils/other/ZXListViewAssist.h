//
//  ZXListViewAssist.h
//  alijk
//
//  Created by easy on 14/11/14.
//  Copyright (c) 2014年 zhongxin. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {
    ELAST_LOADING = 0,  // 显示loading view
    ELAST_EMPTY,        // 无数据时显示
    ELAST_RETRY,        // 需要重试时显示
    ELAST_HIDE          // 不需要显示
}EListAssistShowType;

@interface ZXListViewAssist : UIView

- (id)initWithAttachView:(UIView*)attachView;
- (void)setShowType:(EListAssistShowType)showType showLabel:(NSString*)showLabel;
- (void)setRetryWithTarget:(id)target action:(SEL)action;

@end
