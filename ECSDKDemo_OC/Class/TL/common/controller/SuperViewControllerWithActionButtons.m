//
//  SuperViewControllerWithActionButtons.m
//  TL
//
//  Created by Rainbow on 2/10/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "SuperViewControllerWithActionButtons.h"

@interface SuperViewControllerWithActionButtons ()

@end

@implementation SuperViewControllerWithActionButtons



- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self createActionButtons];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)createActionButtons{
    NSArray *actionButtons = @[[self createComunicateBtn],[self createCollectButton],[self createDownloadButton],[self createShareButton]];
    self.navView.actionBtns = actionButtons;
}

- (UIButton*)createShareButton
{
    
    //    UIImage *backImage = [UIImage imageNamed:@"ico_backon"];
    UIButton *actionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    actionBtn.frame = CGRectMake(0.f, 0.f, 44.f, 44.f);
    [actionBtn setImage:[UIImage imageNamed:@"nav_share"] forState:UIControlStateNormal];
    //    [actionBtn setImage:[UIImage imageNamed:@"ico_backon" ] forState:UIControlStateHighlighted];
    [actionBtn addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    return actionBtn;
}
- (void)shareAction{
    
}
- (UIButton*)createCollectButton
{
    
    //    UIImage *backImage = [UIImage imageNamed:@"ico_backon"];
    UIButton *actionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    actionBtn.frame = CGRectMake(0.f, 0.f, 44.f, 44.f);
    [actionBtn setImage:[UIImage imageNamed:@"nav_collect"] forState:UIControlStateNormal];
    //    [actionBtn setImage:[UIImage imageNamed:@"ico_backon" ] forState:UIControlStateHighlighted];
    [actionBtn addTarget:self action:@selector(collectAction) forControlEvents:UIControlEventTouchUpInside];
    return actionBtn;
}
- (void)collectAction{
    
}
- (UIButton*)createDownloadButton
{
    
    //    UIImage *backImage = [UIImage imageNamed:@"ico_backon"];
    UIButton *actionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    actionBtn.frame = CGRectMake(0.f, 0.f, 44.f, 44.f);
    [actionBtn setImage:[UIImage imageNamed:@"nav_download"] forState:UIControlStateNormal];
    //    [actionBtn setImage:[UIImage imageNamed:@"ico_backon" ] forState:UIControlStateHighlighted];
    [actionBtn addTarget:self action:@selector(downloadAction) forControlEvents:UIControlEventTouchUpInside];
    return actionBtn;
}
- (void)downloadAction{
    
}
- (UIButton*)createComunicateBtn
{
    
    //    UIImage *backImage = [UIImage imageNamed:@"ico_backon"];
    UIButton *actionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    actionBtn.frame = CGRectMake(0.f, 0.f, 44.f, 44.f);
    [actionBtn setImage:[UIImage imageNamed:@"nav_comment"] forState:UIControlStateNormal];
    //    [actionBtn setImage:[UIImage imageNamed:@"ico_backon" ] forState:UIControlStateHighlighted];
    [actionBtn addTarget:self action:@selector(communicateAction) forControlEvents:UIControlEventTouchUpInside];
    return actionBtn;
}
- (void)communicateAction{
    
}
@end
