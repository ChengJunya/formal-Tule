//
//  TLStoreListViewController.m
//  TL
//
//  Created by Rainbow on 2/20/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "TLStoreListViewController.h"
#import "TLModuleDataHelper.h"
#import "TLListMerchantRequestDTO.h"
#import "RUtiles.h"
#import "TLStoreDetailViewController.h"
#import "TLDropViewMenu.h"
#import "TLCitySelectView.h"
#import "TLDropMenu.h"
@interface TLStoreListViewController (){
    TLCitySelectView *citySelctView;
    NSString *storeTypeId;
    
}
@property (nonatomic,strong) TLDropViewMenu *sortMenuView;
@end

@implementation TLStoreListViewController

-(void)itemSelected:(NSDictionary *)itemData{

    [self pushViewControllerWithName:@"TLStoreDetailViewController" itemData:itemData block:^(TLStoreDetailViewController* obj) {
        obj.dataType = [self.itemData valueForKey:@"DATATYPE"];
    }];
    
    
}
-(void)addCreateActionBtnHandler{
    [self pushViewControllerWithName:@"TLAddStoreViewController" block:^(id obj) {
        
    }];
}

-(void)addSortView{
    
    NSArray *sortMenuArray =  @[@{@"ID":@"1",@"NAME":@"地点"},
                                @{@"ID":@"2",@"NAME":@"种类"},
                                @{@"ID":@"3",@"NAME":@"排序"}];
    _sortMenuView = [[TLDropViewMenu alloc] initWithFrame:CGRectMake(0.f, NAVIGATIONBAR_HEIGHT+STATUSBAR_HEIGHT, CGRectGetWidth(self.view.frame), 40.f) menuData:sortMenuArray];
    _sortMenuView.frameHeight = self.view.height-NAVIGATIONBAR_HEIGHT+STATUSBAR_HEIGHT;
    _sortMenuView.isMenuHidden = YES;
    [self.view addSubview:_sortMenuView];
    

    WEAK_SELF(self);
    
    citySelctView = [[TLCitySelectView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.width, self.view.height/2)];
    citySelctView.SelectedCityBlock = ^(TLCityDTO *city){
        [weakSelf cityChange:city];
    };
    
    
    //排序—默认，时间，人均消费，活动天数
    NSArray *sortMenuItemsArray =  @[@{@"ID":@"1",@"NAME":@"默认排序"},
                                     @{@"ID":@"2",@"NAME":@"离我最近"}];
    TLDropMenu *sortItemMenu = [[TLDropMenu alloc] initWithFrame:CGRectMake(0.f, 0.f, CGRectGetWidth(self.view.frame),80.0f) menuData:sortMenuItemsArray];
    
    
    //种类---餐饮、住宿、娱乐；排序：离我最近
    NSArray *carTypeMenuItemsArray = [[GUserDataHelper keyValueDic] objectForKey:@"merchantType"];
    TLDropMenu *carTypeItemMenu = [[TLDropMenu alloc] initWithFrame:CGRectMake(0.f, 0.f, CGRectGetWidth(self.view.frame),80.0f) menuData:carTypeMenuItemsArray];
    carTypeItemMenu.ItemSelectedBlock = ^(id itemData){
        [weakSelf carTypeSortChange:itemData];
    };
    
    
    _sortMenuView.viewArray = [NSMutableArray arrayWithObjects:citySelctView,carTypeItemMenu,sortItemMenu, nil];
    sortItemMenu.ItemSelectedBlock = ^(id itemData){
        [weakSelf sortChange:itemData];
    };
    
    self.sortId = [sortMenuArray[0] valueForKey:@"ID"];
    //////////////////////
}



//地市选择变化 获取城市
-(void)cityChange:(TLCityDTO*)city{
    self.sortMenuView.isMenuHidden = YES;
    NSString *cityId = city.cityId;
    self.cityId = cityId;
    if (_sortMenuView.btnArray.count>0) {
        UIButton *btn = _sortMenuView.btnArray[0];
        [btn setTitle:city.cityName forState:UIControlStateNormal];
    }
    [self initData];
}


/*设置排序 时间还是人气 还是默认*/
-(void)carTypeSortChange:(NSDictionary*)itemData{
    self.sortMenuView.isMenuHidden = YES;
    storeTypeId = [itemData valueForKey:@"ID"];
    if (_sortMenuView.btnArray.count>1) {
        UIButton *btn = _sortMenuView.btnArray[1];
        [btn setTitle:[itemData valueForKey:@"NAME"] forState:UIControlStateNormal];
    }
    [self initData];
}


/*设置排序 时间还是人气 还是默认*/
-(void)sortChange:(NSDictionary*)itemData{
    self.sortMenuView.isMenuHidden = YES;
    self.sortId = [itemData valueForKey:@"ID"];
    //    switch ([sortId integerValue]) {
    //        case 1:
    //        {
    //            self.orderByTime = @"0";
    //            self.orderByViewCount = @"0";
    //            break;
    //        }
    //        case 2:
    //        {
    //            self.orderByTime = @"1";
    //            self.orderByViewCount = @"0";
    //            break;
    //        }
    //        case 3:
    //        {
    //            self.orderByTime = @"0";
    //            self.orderByViewCount = @"1";
    //            break;
    //        }
    //        case 4:
    //        {
    //            self.orderByTime = @"0";
    //            self.orderByViewCount = @"1";
    //            break;
    //        }
    //        default:
    //            break;
    //    }
    if (_sortMenuView.btnArray.count>1) {
        UIButton *btn = _sortMenuView.btnArray[2];
        [btn setTitle:[itemData valueForKey:@"NAME"] forState:UIControlStateNormal];
    }
    [self initData];
}


-(void)initData{
    self.refrashTime = [RUtiles stringFromDateWithFormat:[NSDate new] format:@"yyyyMMddHHmmss"];
    self.currentPage = 1;
    TLListMerchantRequestDTO *request = [[TLListMerchantRequestDTO alloc] init];
    
    request.currentPage = [NSString stringWithFormat:@"%d",self.currentPage];
    request.pageSize = [NSString stringWithFormat:@"%d",TABLE_PAGE_SIZE];
    request.orderByTime = self.orderByTime;
    request.orderByViewCount = self.orderByViewCount;
    request.cityId = self.cityId;
    request.type = MODULE_STORE_TYPE;
    request.currentTime = self.refrashTime;
    request.dataType = [self.itemData valueForKey:@"DATATYPE"];
    request.loginId = [self.itemData valueForKey:@"LOGINID"];
    request.orderBy = self.sortId;
    request.merchantType = storeTypeId;

    
    [GHUDAlertUtils toggleLoadingInView:self.view];
    [GTLModuleDataHelper getStoreList:request requestArray:self.requestArray block:^(id obj, BOOL ret, int pageNumber) {
        
        
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
    TLListMerchantRequestDTO *request = [[TLListMerchantRequestDTO alloc] init];
    
    request.currentPage = [NSString stringWithFormat:@"%d",(self.currentPage+1)];
    request.pageSize = [NSString stringWithFormat:@"%d",TABLE_PAGE_SIZE];
    request.orderByTime = self.orderByTime;
    request.orderByViewCount = self.orderByViewCount;
    request.cityId = self.cityId;
    request.type = MODULE_STORE_TYPE;
    request.currentTime = self.refrashTime;
    request.dataType = [self.itemData valueForKey:@"DATATYPE"];
    request.loginId = [self.itemData valueForKey:@"LOGINID"];
    
    request.orderBy = self.sortId;
    request.merchantType = storeTypeId;

    [GHUDAlertUtils toggleLoadingInView:self.view];
    [GTLModuleDataHelper getStoreList:request requestArray:self.requestArray block:^(id obj, BOOL ret, int pageNumber) {
        
        
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
