//
//  ZXColorButton.h
//  alijk
//
//  Created by easy on 14/8/15.
//  Copyright (c) 2014年 zhongxin. All rights reserved.
//

#import "QBFlatButton.h"

typedef enum
{
    EZXBT_BOX_GREEN = 0,    // 焦点线框按钮-绿色
    EZXBT_BOX_GREEN_CLEAR,  // 焦点线框按钮-绿色
    EZXBT_BOX_GRAY,         // 次要线框按钮-灰色
    EZXBT_BOX_DISABLE,      // 无效线框按钮
    
    EZXBT_SOLID_TOP_GREEN,  // 焦点色块按钮-浅绿色
    EZXBT_SOLID_GREEN,      // 焦点色块按钮-绿色
    EZXBT_SOLID_GRAY,       // 次要色块按钮-灰色
    EZXBT_SOLID_ORANGE,     // 警告色块按钮-橙色
    EZXBT_SOLID_DISABLE,    // 无效色块按钮
}EZXColorButtonType;

@interface ZXColorButton : QBFlatButton

@property (nonatomic, assign) EZXColorButtonType type;
@property (nonatomic, assign) BOOL blockEnable;

+ (id)buttonWithType:(EZXColorButtonType)type frame:(CGRect)frame title:(NSString*)title font:(UIFont*)font block:(Void_Block)block;

/*
 * timeout: 倒计时间
 */
- (void)countdownWithTime:(NSInteger)timeout;

/*
 * 停止倒计时
 */
- (void)stopCountdown;

@end
