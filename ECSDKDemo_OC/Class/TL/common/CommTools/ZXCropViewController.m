//
//  ZXCropViewController.m
//  alijk
//
//  Created by easy on 14/11/10.
//  Copyright (c) 2014年 zhongxin. All rights reserved.
//

#import "ZXCropViewController.h"

@interface PECropViewController (SuperPrivate)

- (void)cancel:(id)sender;
- (void)done:(id)sender;

@end


@interface ZXCropViewController ()

@end

@implementation ZXCropViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *toolbarButton1 = [[UIBarButtonItem alloc] initWithTitle:MultiLanguage(cropvcCancel)
                                                                       style:UIBarButtonItemStyleBordered
                                                                      target:self
                                                                      action:@selector(cancel:)];
    UIBarButtonItem *toolbarButton2 = [[UIBarButtonItem alloc] initWithTitle:MultiLanguage(cropvcDone)
                                                                       style:UIBarButtonItemStyleBordered
                                                                      target:self
                                                                      action:@selector(done:)];
    self.toolbarItems = @[toolbarButton1,flexibleSpace,toolbarButton2];
    
    self.navigationController.toolbarHidden = NO;
    self.navigationController.toolbar.translucent = NO;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.toolbarHidden = YES;
}

#pragma mark -
#pragma mark - action

- (void)cancel:(id)sender
{
    [super cancel:sender];
}

- (void)done:(id)sender
{
    [super done:sender];
}

@end
