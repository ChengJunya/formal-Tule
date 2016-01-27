//
//  TLMyDownloadViewController.m
//  TL
//
//  Created by Rainbow on 4/15/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "TLMyDownloadViewController.h"
#import "RUILabel.h"
#import "TLMineListItem.h"
#import "TLHelper.h"

@interface TLMyDownloadViewController (){
    CGFloat yOffSet;
}
@property (nonatomic,strong) UIScrollView *contentScrollView;

@end

@implementation TLMyDownloadViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的下载";
    yOffSet = 0.f;
    self.contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.f, NAVIGATIONBAR_HEIGHT+STATUSBAR_HEIGHT, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-NAVIGATIONBAR_HEIGHT-STATUSBAR_HEIGHT-TABBAR_HEIGHT)];
    [self.view addSubview:self.contentScrollView];
    [self addMyCollection];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navBarHidden = NO;
    self.navBackItemHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addMyCollection{
    //    CGFloat hGap = 3.f;
    //    CGFloat vGap = 3.f;
    //    NSString *label = @"我的发布：";
    //    RUILabel *labelLabel = [[RUILabel alloc] initWithFrame:CGRectZero str:label font:FONT_14 color:COLOR_MAIN_TEXT];
    //    labelLabel.frame = CGRectMake(hGap,yOffSet + vGap, CGRectGetWidth(labelLabel.frame), CGRectGetHeight(labelLabel.frame));
    //    [self.contentScrollView addSubview:labelLabel];
    //
    //    yOffSet = yOffSet + CGRectGetHeight(labelLabel.frame)+vGap*2;
    NSString *loginId = @"";//[self.userInfoDic valueForKey:@"userId"];
    
    NSArray *itemsData = @[
  @{@"ID":@"1",@"NAME":@"攻略",@"IMG":@"menu1_homepage",@"VCNAME":@"TLStrategyListViewController",@"TYPE":@"1",@"IS_SHOW_MENU":@"1",@"IS_SHOW_ADD":@"1",@"DATATYPE":@"5",@"LOGINID":loginId},
@{@"ID":@"2",@"NAME":@"路书",@"IMG":@"menu2_homepage",@"VCNAME":@"TLWayBookListViewController",@"TYPE":@"2",@"IS_SHOW_MENU":@"1",@"IS_SHOW_ADD":@"1",@"DATATYPE":@"5",@"LOGINID":loginId},
@{@"ID":@"3",@"NAME":@"游记",@"IMG":@"menu3_homepage",@"VCNAME":@"TLTripNoteListViewController",@"TYPE":@"3",@"IS_SHOW_MENU":@"1",@"IS_SHOW_ADD":@"1",@"DATATYPE":@"5",@"LOGINID":loginId},
@{@"ID":@"4",@"NAME":@"活动",@"IMG":@"menu4_homepage",@"VCNAME":@"TLGroupActivityListViewController",@"TYPE":@"4",@"IS_SHOW_MENU":@"1",@"IS_SHOW_ADD":@"1",@"DATATYPE":@"5",@"LOGINID":loginId}];
    
/*
 ,
 @{@"ID":@"5",@"NAME":@"车讯",@"IMG":@"menu5_homepage",@"VCNAME":@"TLCarMainListViewController",@"TYPE":@"5",@"IS_SHOW_MENU":@"1",@"IS_SHOW_ADD":@"1",@"DATATYPE":@"5",@"LOGINID":loginId},
 @{@"ID":@"6",@"NAME":@"跳蚤",@"IMG":@"menu6_homepage",@"VCNAME":@"TLSecondPlatformViewController",@"TYPE":@"6",@"IS_SHOW_MENU":@"1",@"IS_SHOW_ADD":@"1",@"DATATYPE":@"5",@"LOGINID":loginId},
 @{@"ID":@"8",@"NAME":@"商家",@"IMG":@"menu8_homepage",@"VCNAME":@"TLStoreListViewController",@"TYPE":@"8",@"IS_SHOW_MENU":@"1",@"IS_SHOW_ADD":@"1",@"DATATYPE":@"5",@"LOGINID":loginId}
 
 */
    
    [itemsData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *itemData = @{@"NAME":[obj valueForKey:@"NAME"],@"IMAGE":[obj valueForKey:@"IMG"],@"ITEM_DATA":obj};
        TLMineListItem *storeItem = [[TLMineListItem alloc] initWithFrame:CGRectMake(0.f, yOffSet, CGRectGetWidth(self.contentScrollView.frame), 50.f) itemData:itemData];
        [self.contentScrollView addSubview:storeItem];
        [storeItem addTarget:self action:@selector(minePublishHandler:) forControlEvents:UIControlEventTouchUpInside];
        
        yOffSet = yOffSet + CGRectGetHeight(storeItem.frame);
        
    }];
    
}

-(void)minePublishHandler:(TLMineListItem*)btn{
    NSDictionary *itemData = [btn.itemData valueForKey:@"ITEM_DATA"];
    [RTLHelper pushViewControllerWithName:[itemData valueForKey:@"VCNAME"] itemData:itemData block:^(id obj) {
        
    }];
}


@end
