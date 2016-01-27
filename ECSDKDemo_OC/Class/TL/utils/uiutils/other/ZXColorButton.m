//
//  ZXColorButton.m
//  alijk
//
//  Created by easy on 14/8/15.
//  Copyright (c) 2014年 zhongxin. All rights reserved.
//

#import "ZXColorButton.h"

@interface ZXColorButton ()

@property (nonatomic, strong) dispatch_source_t cdTimer;
@property (nonatomic, copy) NSString *oriTitle;
@property (nonatomic, strong) Void_Block block;

@end


@implementation ZXColorButton

+ (id)buttonWithType:(EZXColorButtonType)type frame:(CGRect)frame title:(NSString*)title font:(UIFont*)font block:(Void_Block)block
{
    ZXColorButton *button = [ZXColorButton buttonWithType:UIButtonTypeCustom];
    [button setupWithType:type frame:frame title:title font:font block:block];
    
    return button;
}


#pragma mark -
#pragma mark - init

- (void)setupWithType:(EZXColorButtonType)type frame:(CGRect)frame title:(NSString*)title font:(UIFont*)font block:(Void_Block)block
{
    self.frame = frame;
    self.titleLabel.font = font;
    [self addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self setTitle:title forState:UIControlStateNormal];
    self.titleEdgeInsets = UIEdgeInsetsMake(0.f, 8.f, 0.f, 8.f);
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.blockEnable = YES;
    self.block = block;
    self.type = type;
    [self setupButton];
}

- (void)setType:(EZXColorButtonType)type
{
    _type = type;
    
    NSArray *colorPattern = [self getColorPattern];
    NSDictionary *dict = [colorPattern objectAtIndex:self.type];
    CGFloat boardSize = [[dict objectForKey:@"boardSize"] floatValue];
    UIColor *boardColor = [dict objectForKey:@"boardColor"];
    UIColor *sufaceColor = [dict objectForKey:@"sufaceColor"];
    UIColor *textColor = [dict objectForKey:@"textColor"];
    
    EZXColorButtonType disType = (self.type > EZXBT_BOX_DISABLE ? EZXBT_SOLID_DISABLE :EZXBT_BOX_DISABLE);
    NSDictionary *dis_dict = [colorPattern objectAtIndex:disType];
    UIColor *dis_boardColor = [dis_dict objectForKey:@"boardColor"];
    UIColor *dis_sufaceColor = [dis_dict objectForKey:@"sufaceColor"];
    UIColor *dis_textColor = [dis_dict objectForKey:@"textColor"];
    
    // 文字颜色
    [self setTitleColor:textColor forState:UIControlStateNormal];
    if (self.type > EZXBT_BOX_DISABLE) {
        [self setTitleColor:[textColor colorWithAlphaComponent:0.7f] forState:UIControlStateSelected];
    }
    [self setTitleColor:dis_textColor forState:UIControlStateDisabled];
    
    // 边框颜色
    [self setBorderWidth:boardSize];
    if (boardSize > 0.f) {
        [self setBorderColor:boardColor];
        [self setBorderColor:dis_boardColor forState:UIControlStateDisabled];
    }
    
    // 阴影颜色
    if (self.type > EZXBT_BOX_DISABLE) {
        [self setSideColor:[[UIColor blackColor] colorWithAlphaComponent:0.7f]];
    }
    else {
        [self setSideColor:sufaceColor];
    }
    [self setSideColor:dis_sufaceColor forState:UIControlStateDisabled];
    
    // 内部颜色
    [self setSurfaceColor:sufaceColor forState:UIControlStateNormal];
    [self setSurfaceColor:[sufaceColor colorWithAlphaComponent:0.8f] forState:UIControlStateHighlighted];
    [self setSurfaceColor:dis_sufaceColor forState:UIControlStateDisabled];
    
    [self setNeedsDisplay];
}

- (void)setupButton
{
    [self setCornerRadius:4.f];
    [self setDepth:0.f];
    [self setHeight:0.f];
}

- (NSArray*)getColorPattern
{
    return(@[
             @{
                 @"boardSize" : @"1",
                 @"boardColor" : COLOR_BTN_BOX_GREEN_TEXT,
                 @"sufaceColor" : COLOR_BTN_BOX_GREEN_SUFACE,
                 @"textColor" : COLOR_BTN_BOX_GREEN_TEXT
                 },
             @{
                 @"boardSize" : @"1",
                 @"boardColor" : COLOR_BTN_BOX_GREEN_TEXT,
                 @"sufaceColor" : COLOR_DEF_BG,
                 @"textColor" : COLOR_BTN_BOX_GREEN_TEXT
                 },
             @{
                 @"boardSize" : @"1",
                 @"boardColor" : COLOR_BTN_BOX_GRAY_BOARD,
                 @"sufaceColor" : COLOR_BTN_BOX_GRAY_SUFACE,
                 @"textColor" : COLOR_BTN_BOX_GRAY_TEXT
                 },
             @{
                 @"boardSize" : @"1",
                 @"boardColor" : COLOR_BTN_BOX_DISABLE_BOARD,
                 @"sufaceColor" : COLOR_BTN_BOX_DISABLE_SUFACE,
                 @"textColor" : COLOR_BTN_BOX_DISABLE_TEXT
                 },
             @{
                 @"boardSize" : @"0",
                 @"boardColor" : [UIColor clearColor],
                 @"sufaceColor" : COLOR_BTN_SOLID_TOP_GREEN_SUFACE,
                 @"textColor" : COLOR_BTN_SOLID_COMMON_TEXT
                 },
             @{
                 @"boardSize" : @"0",
                 @"boardColor" : [UIColor clearColor],
                 @"sufaceColor" : COLOR_BTN_SOLID_GREEN_SUFACE,
                 @"textColor" : COLOR_BTN_SOLID_COMMON_TEXT
                 },
             @{
                 @"boardSize" : @"0",
                 @"boardColor" : [UIColor clearColor],
                 @"sufaceColor" : COLOR_BTN_SOLID_GRAY_SUFACE,
                 @"textColor" : COLOR_BTN_SOLID_COMMON_TEXT
                 },
             @{
                 @"boardSize" : @"0",
                 @"boardColor" : [UIColor clearColor],
                 @"sufaceColor" : COLOR_BTN_SOLID_ORANGE_SUFACE,
                 @"textColor" : COLOR_BTN_SOLID_COMMON_TEXT
                 },
             @{
                 @"boardSize" : @"0",
                 @"boardColor" : [UIColor clearColor],
                 @"sufaceColor" : COLOR_BTN_SOLID_DISABLE_SUFACE,
                 @"textColor" : COLOR_BTN_SOLID_DISABLE_TEXT
                 },
             ]);
    
}


#pragma mark -
#pragma mark - action

- (void)clickAction:(id)sender
{
    if (_blockEnable && self.block) {
        self.block();
    }
}


#pragma mark -
#pragma mark - count down

/*
 * timeout: 倒计时间
 */
- (void)countdownWithTime:(NSInteger)timeout
{
    __block NSInteger timeout_ = timeout;
    self.oriTitle = self.titleLabel.text;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(timer, ^{
        if(timeout_ <= 0){
            //倒计时结束，关闭
            [self stopCountdown];
        }else{
            NSString *strTime = [NSString stringWithFormat:@"%.2d", timeout_];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self setTitle:[NSString stringWithFormat:@"%@秒",strTime] forState:UIControlStateNormal];
                self.userInteractionEnabled = NO;
                
            });
            timeout_--;
        }
    });
    dispatch_resume(timer);
    self.cdTimer = timer;
}

/*
 * 停止倒计时
 */
- (void)stopCountdown
{
    // 关闭倒计时
    if (self.cdTimer) {
        dispatch_source_cancel(self.cdTimer);
        self.cdTimer = nil;
    }
    
    if (self.oriTitle) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // 恢复之前显示的title
            [self setTitle:self.oriTitle forState:UIControlStateNormal];
            self.userInteractionEnabled = YES;
        });
    }
}

- (void)dealloc {
    self.oriTitle = nil;
    [self stopCountdown];
}

@end
