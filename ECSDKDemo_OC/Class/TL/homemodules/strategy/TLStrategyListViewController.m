//
//  TLStrategyListViewController.m
//  TL
//
//  Created by Rainbow on 2/15/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "TLStrategyListViewController.h"
#import "TLModuleDataHelper.h"
#import "TLTripListRequestDTO.h"
#import "TLStrategyDetailViewController.h"
#import "RUtiles.h"
#import "TLNewStrategyViewController.h"
@interface TLStrategyListViewController ()

@end

@implementation TLStrategyListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)itemSelected:(id)itemData{

    [self pushViewControllerWithName:@"TLStrategyDetailViewController" itemData:itemData block:^(TLStrategyDetailViewController *obj) {
        obj.dataType = [self.itemData valueForKey:@"DATATYPE"];
    }];
    
    
}

-(void)addCreateActionBtnHandler{
    [self pushViewControllerWithName:@"TLNewStrategyViewController" block:^(TLNewStrategyViewController *obj) {
        obj.operateType = @"1";//新增
    }];
}




-(void)initData{
    self.refrashTime = [RUtiles stringFromDateWithFormat:[NSDate new] format:@"yyyyMMddHHmmss"];
    self.currentPage = 1;
    TLTripListRequestDTO *request = [[TLTripListRequestDTO alloc] init];

    request.currentPage = [NSString stringWithFormat:@"%d",self.currentPage];
    request.pageSize = [NSString stringWithFormat:@"%d",TABLE_PAGE_SIZE];
    request.orderByTime = self.orderByTime;
    request.orderByViewCount = self.orderByViewCount;
    request.cityId = self.cityId;
    request.type = MODULE_STRATEGY_TYPE;
    request.dataType = [self.itemData valueForKey:@"DATATYPE"];
    request.currentTime = self.refrashTime;
        request.loginId = [self.itemData valueForKey:@"LOGINID"];
    request.orderBy = self.sortId;
    [GHUDAlertUtils toggleLoadingInView:self.view];
    [GTLModuleDataHelper getTripList:request requestArr:self.requestArray block:^(id obj, BOOL ret, int pageNumber) {
        [GHUDAlertUtils hideLoadingInView:self.view];
        [self endHeaderRefrash];
        if (ret) {
            self.arrayData = obj;
            [self refrashTableView];
            [self.listAssistView setShowType:ELAST_HIDE showLabel:nil];
            self.currentPage = pageNumber;
        }else{
            [self.listAssistView setShowType:ELAST_RETRY showLabel:MultiLanguage(mctvcMsgTips)];
            [self.listAssistView setRetryWithTarget:self action:@selector(initData)];
        }
    }];
    
   
}

-(void)refreshData{
    TLTripListRequestDTO *request = [[TLTripListRequestDTO alloc] init];
    request.currentPage = [NSString stringWithFormat:@"%d",(self.currentPage+1)];
    request.pageSize = [NSString stringWithFormat:@"%d",TABLE_PAGE_SIZE];
    request.orderByTime = self.orderByTime;
    request.orderByViewCount = self.orderByViewCount;
    request.cityId = self.cityId;
    request.type = MODULE_STRATEGY_TYPE;
    request.dataType = [self.itemData valueForKey:@"DATATYPE"];
        request.loginId = [self.itemData valueForKey:@"LOGINID"];
    request.currentTime = self.refrashTime;
    request.orderBy = self.sortId;
    [GHUDAlertUtils toggleLoadingInView:self.view];
    [GTLModuleDataHelper getTripList:request requestArr:self.requestArray block:^(id obj, BOOL ret, int pageNumber) {
        [GHUDAlertUtils hideLoadingInView:self.view];
        [self endFooterRefrash];
        if (ret) {
            self.arrayData = [self.arrayData arrayByAddingObjectsFromArray:obj];
            [self refrashTableView];
            [self.listAssistView setShowType:ELAST_HIDE showLabel:nil];
            self.currentPage = pageNumber;
        }else{
            [self.listAssistView setShowType:ELAST_RETRY showLabel:MultiLanguage(mctvcMsgTips)];
            [self.listAssistView setRetryWithTarget:self action:@selector(initData)];
        }
    }];
}

@end
