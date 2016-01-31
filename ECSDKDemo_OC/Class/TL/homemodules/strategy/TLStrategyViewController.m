//
//  TLStrategyViewController.m
//  TL
//
//  Created by Rainbow on 2/7/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "TLStrategyViewController.h"

@interface TLStrategyViewController ()

@end

@implementation TLStrategyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"攻略";
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navBarHidden = NO;
    self.navBackItemHidden = NO;
}

@end
