//
//  TLForgotPwdStepCControllerViewController.m
//  TL
//
//  Created by Rainbow on 3/8/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "TLForgotPwdStepCControllerViewController.h"
#import "RUILabel.h"
#import "ZXUIHelper.h"
#import "ZXColorButton.h"
#import "TLHelper.h"
@interface TLForgotPwdStepCControllerViewController ()

@end

@implementation TLForgotPwdStepCControllerViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"密码找回成功";
    
    [self addAllUIResources];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)addAllUIResources{
    //NSString *loginId = [self.itemData valueForKey:@"loginId"];
    
    CGFloat _yOffSet = NAVIGATIONBAR_HEIGHT+STATUSBAR_HEIGHT+100.f;
    CGFloat hGap = 10.f;
    CGFloat vGap = 10.f;
    
    RUILabel *infoLabel = [[RUILabel alloc] initWithFrame:CGRectZero str:@"密码已经成功发送到您的手机！" font:FONT_16 color:COLOR_MAIN_TEXT];
    [self.view addSubview:infoLabel];
    
    CGFloat infoPaddingLeft = (CGRectWidth(self.view) -( CGRectWidth(infoLabel.frame)+CGRectHeight(infoLabel.frame)+hGap))/2;
    CGFloat imageHeight = CGRectHeight(infoLabel.frame);
    [ZXUIHelper addUIImageViewWithImage:[UIImage imageNamed:@"tl_reg_correct"] frame:CGRectMake(infoPaddingLeft, _yOffSet, imageHeight, imageHeight) toTarget:self.view];
    infoLabel.frame = CGRectMake(infoPaddingLeft+hGap+imageHeight, _yOffSet, CGRectWidth(infoLabel.frame), imageHeight);
    
    _yOffSet = _yOffSet + vGap + imageHeight;
    
    
//    RUILabel *loginIdLabel = [[RUILabel alloc] initWithFrame:CGRectZero str:[self.itemData valueForKey:@"loginId"] font:FONT_16 color:COLOR_ORANGE_TEXT];
//    loginIdLabel.frame = CGRectMake((CGRectWidth(self.view.frame)-CGRectWidth(loginIdLabel.frame))/2, _yOffSet, CGRectWidth(loginIdLabel.frame), CGRectHeight(loginIdLabel.frame));
//    [self.view addSubview:loginIdLabel];
//    
//    _yOffSet = _yOffSet + vGap + CGRectHeight(loginIdLabel.frame);
    
    
    UIButton *loginBtn = [ZXColorButton buttonWithType:EZXBT_SOLID_GREEN frame:CGRectMake((CGRectWidth(self.view)-120.f)/2 , _yOffSet, 120.f, 40.f) title:@"确定" font:FONT_18 block:^{
        
        [self pushToLoginController];
        
    }];
    [self.view addSubview:loginBtn];
}

-(void)pushToLoginController{
    [RTLHelper gotoLoginViewController];
}


@end
