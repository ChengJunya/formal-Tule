//
//  TLSetChatBackgroundViewController.m
//  TL
//
//  Created by YONGFU on 5/22/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "TLSetChatBackgroundViewController.h"

@interface TLSetChatBackgroundViewController ()

@end

@implementation TLSetChatBackgroundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"聊天背景设置";
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navBarHidden = NO;
    self.navBackItemHidden = NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
