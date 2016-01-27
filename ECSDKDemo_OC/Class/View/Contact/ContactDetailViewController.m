//
//  ContactDetailViewController.m
//  ECSDKDemo_OC
//
//  Created by jiazy on 14/12/6.
//  Copyright (c) 2014年 ronglian. All rights reserved.
//

#import "ContactDetailViewController.h"
#import "ChatViewController.h"
#import "CommonTools.h"

extern NSString * Notification_ChangeMainDisplay;


@interface ContactDetailViewController ()

@end

@implementation ContactDetailViewController
-(void)prepareUI
{
    self.title =@"联系人详情";
    
    UIImageView * bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, 320, 140)];
    bgImageView.image = [UIImage imageNamed:@"personal_center_bg"];
    [self.view addSubview:bgImageView];

    UIImageView * headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 40, 70, 70)];
    [headImageView sd_setImageWithURL:[NSURL URLWithString:_dict[imageKey]] placeholderImage:[UIImage imageNamed:@"ico_loading_logo"]];// setImage:[UIImage imageNamed:_dict[imageKey]]];
    [bgImageView addSubview:headImageView];
    UILabel * nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 46, 150, 30)];
    nameLabel.text = _dict[nameKey];
    nameLabel.font = [UIFont boldSystemFontOfSize:23];
    nameLabel.textColor = [UIColor whiteColor];
    [bgImageView addSubview:nameLabel];
    
    UILabel * numLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 75, 150, 30)];
    numLabel.text = _dict[voipKey];
    numLabel.textColor = [UIColor whiteColor];
    [bgImageView addSubview:numLabel];
    UIButton * contactBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    contactBtn.frame =CGRectMake(20, 220, 280, 45);
    [contactBtn setBackgroundImage:[CommonTools createImageWithColor:[UIColor colorWithRed:0.01f green:0.85f blue:0.58f alpha:1.00f]] forState:UIControlStateNormal];
    [contactBtn setTitle:@"与TA沟通(IM)" forState:UIControlStateNormal];
    [contactBtn addTarget:self action:@selector(contactBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:contactBtn];
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"title_bar_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(returnClicked)];
    self.navigationItem.leftBarButtonItem =leftItem;
    
}

-(void)returnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)contactBtnClicked
{
    ChatViewController * cvc = [[ChatViewController alloc]initWithSessionId:_dict[voipKey]];
    [self.navigationController setViewControllers:[NSArray arrayWithObjects:[self.navigationController.viewControllers objectAtIndex:0],cvc, nil] animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    [self prepareUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
