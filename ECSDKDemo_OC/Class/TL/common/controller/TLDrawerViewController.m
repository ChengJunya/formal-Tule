//
//  TLDrawerViewController.m
//  TL
//
//  Created by Rainbow on 2/7/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "TLDrawerViewController.h"

@interface TLDrawerViewController ()

@end

@implementation TLDrawerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(execute:) name:TL_DRAWER_OPEN_LEFT object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)execute:(NSNotification *)notification {
    [self toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
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
