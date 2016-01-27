//
//  TLWayBookListViewController.m
//  TL
//
//  Created by Rainbow on 2/15/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "TLWayBookListViewController.h"
#import "TLSelectWaybookViewController.h"
#import "TLModuleDataHelper.h"
#import "TLTripListRequestDTO.h"
#import "TLTripDataDTO.h"
#import "TLWayBookDetailViewController.h"
#import "RUtiles.h"
#import "TLNewWayBookViewController.h"
#import "TLNewWaybookNodeViewController.h"
@interface TLWayBookListViewController ()

@end

@implementation TLWayBookListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.useBlurForPopup = YES;

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)itemSelected:(NSDictionary *)itemData{
    
    [self pushViewControllerWithName:@"TLWayBookDetailViewController" itemData:itemData block:^(TLWayBookDetailViewController* obj) {
        obj.dataType = [self.itemData valueForKey:@"DATATYPE"];
        obj.type = @"2";
    }];
    
    
}

-(void)addCreateActionBtnHandler{
    WEAK_SELF(self);
//    [self pushViewControllerWithName:@"TLNewWayBookViewController" block:^(id obj) {
//        
//    }];
    
    TLSelectWaybookViewController *selectWaybookVC = [[TLSelectWaybookViewController alloc] initWIthType:@"2"];

    selectWaybookVC.NewItemSelectedBlock = ^(id itemData){
        [self dismissPopup];
        
        NSUInteger type = [[itemData valueForKey:@"TYPE"] intValue];
        switch (type) {
            case 1:
            {
                break;
            }
            case 2:
            {
                [weakSelf pushViewControllerWithName:@"TLNewWayBookViewController" itemData:[[TLTripDataDTO alloc] init] block:^(TLNewWayBookViewController* obj) {
                    obj.operateType = @"1";
                    obj.type = @"2";
                  }];
                break;
            }
            case 3:
            {
                break;
            }
            default:
                break;
        }
        
    };
    
    
    selectWaybookVC.ItemSelectedBlock = ^(id itemData){
        [self dismissPopup];
        [weakSelf pushViewControllerWithName:@"TLNewWaybookNodeViewController" itemData:itemData block:^(TLNewWaybookNodeViewController* obj) {
            obj.operateType = @"1";
            obj.type = @"2";
        }];
    };
    
    
    [self presentPopupViewController:selectWaybookVC animated:YES completion:^{
        
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
    request.type = MODULE_WAYBOOK_TYPE;
    request.dataType = [self.itemData valueForKey:@"DATATYPE"];
        request.loginId = [self.itemData valueForKey:@"LOGINID"];
    request.currentTime = self.refrashTime;
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
    request.type = MODULE_WAYBOOK_TYPE;
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





- (void)dismissPopup {
    if (self.popupViewController != nil) {
        [self dismissPopupViewControllerAnimated:YES completion:^{
            NSLog(@"popup view dismissed");
        }];
    }
}


@end
