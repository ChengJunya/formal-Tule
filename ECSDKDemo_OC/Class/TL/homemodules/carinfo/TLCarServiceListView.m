//
//  TLCarServiceListView.m
//  TL
//
//  Created by Rainbow on 3/30/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "TLCarServiceListView.h"
#import "TLModuleDataHelper.h"
#import "RUtiles.h"
#import "TLListCarServiceRequest.h"

#import "TLDropViewMenu.h"
#import "TLCitySelectView.h"
#import "TLDropMenu.h"

@interface TLCarServiceListView (){
    TLCitySelectView *citySelctView;
    NSString *serviceType;
}
@property (nonatomic,strong) TLDropViewMenu *sortMenuView;
@end
@implementation TLCarServiceListView




-(void)addSortView{
    ///////////////
    
    NSArray *sortMenuArray =  @[@{@"ID":@"1",@"NAME":@"服务类型"},
                                @{@"ID":@"2",@"NAME":@"排序"}];
    _sortMenuView = [[TLDropViewMenu alloc] initWithFrame:CGRectMake(0.f, 0.f, CGRectGetWidth(self.frame), 40.f) menuData:sortMenuArray];
    _sortMenuView.frameHeight = self.height;
    _sortMenuView.isMenuHidden = YES;
    [self addSubview:_sortMenuView];
    
    
    
    
    
    WEAK_SELF(self);
    
    citySelctView = [[TLCitySelectView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.width, self.height/2)];
    citySelctView.SelectedCityBlock = ^(TLCityDTO *city){
        [weakSelf cityChange:city];
    };
    
    
    //排序—默认，时间，人均消费，活动天数
    NSArray *sortMenuItemsArray =  @[@{@"ID":@"1",@"NAME":@"默认排序"},
                                     @{@"ID":@"2",@"NAME":@"离我最近"}];
    TLDropMenu *sortItemMenu = [[TLDropMenu alloc] initWithFrame:CGRectMake(0.f, 0.f, CGRectGetWidth(self.frame),80.0f) menuData:sortMenuItemsArray];
    
    
    //增加服务种类（汽车美容、汽车维修、汽车用品店，4s店，可多选）；排序 离我最近
    NSArray *serviceTypeMenuItemsArray = [[GUserDataHelper keyValueDic] objectForKey:@"serviceType"];
//    @[@{@"ID":@"1",@"NAME":@"车辆维修"},
//                                        @{@"ID":@"2",@"NAME":@"洗车服务"},
//                                        @{@"ID":@"3",@"NAME":@"洗车用品"},
//                                        @{@"ID":@"4",@"NAME":@"车辆保险"}];
    TLDropMenu *serviceTypeItemMenu = [[TLDropMenu alloc] initWithFrame:CGRectMake(0.f, 0.f, CGRectGetWidth(self.frame),80.0f) menuData:serviceTypeMenuItemsArray];
    serviceTypeItemMenu.ItemSelectedBlock = ^(id itemData){
        [weakSelf serviceTypeSortChange:itemData];
    };
    
    

    
    _sortMenuView.viewArray = [NSMutableArray arrayWithObjects:serviceTypeItemMenu,sortItemMenu, nil];
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
-(void)serviceTypeSortChange:(NSDictionary*)itemData{
    self.sortMenuView.isMenuHidden = YES;
    serviceType = [itemData valueForKey:@"ID"];
    if (_sortMenuView.btnArray.count>1) {
        UIButton *btn = _sortMenuView.btnArray[0];
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
        UIButton *btn = _sortMenuView.btnArray[1];
        [btn setTitle:[itemData valueForKey:@"NAME"] forState:UIControlStateNormal];
    }
    [self initData];
}



-(void)initData{
    
    self.currentPage = 1;
    self.refrashTime = [RUtiles stringFromDateWithFormat:[NSDate new] format:@"yyyyMMddHHmmss"];
    
    TLListCarServiceRequest *request = [[TLListCarServiceRequest alloc] init];
    
    request.currentPage = [NSString stringWithFormat:@"%d",self.currentPage];
    request.pageSize = [NSString stringWithFormat:@"%d",TABLE_PAGE_SIZE];
    request.orderByTime = self.orderByTime;
    request.orderByViewCount = self.orderByViewCount;
    request.currentTime = self.refrashTime;
    request.cityId = self.cityId;
    request.type = MODULE_CARINFO_COMMENT_TYPE;
    request.dataType = [self.itemData valueForKey:@"DATATYPE"];
        request.loginId = [self.itemData valueForKey:@"LOGINID"];
    request.orderBy = self.sortId;
    request.serviceType = serviceType;
    
//    [GHUDAlertUtils toggleLoadingInView:self];
    
    [GTLModuleDataHelper getCarServiceList:request requestArray:self.requestArray block:^(id obj, BOOL ret, int pageNumber) {
        
        
//        [GHUDAlertUtils hideLoadingInView:self];
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
    TLListCarServiceRequest *request = [[TLListCarServiceRequest alloc] init];
    
    request.currentPage = [NSString stringWithFormat:@"%d",(self.currentPage+1)];
    request.pageSize = [NSString stringWithFormat:@"%d",TABLE_PAGE_SIZE];
    request.orderByTime = self.orderByTime;
    request.orderByViewCount = self.orderByViewCount;
    request.currentTime = self.refrashTime;
    request.cityId = self.cityId;
    request.type = MODULE_CARINFO_COMMENT_TYPE;
    request.dataType = [self.itemData valueForKey:@"DATATYPE"];
        request.loginId = [self.itemData valueForKey:@"LOGINID"];
    request.orderBy = self.sortId;
    request.serviceType = serviceType;
//    [GHUDAlertUtils toggleLoadingInView:self];
    
    [GTLModuleDataHelper getCarServiceList:request requestArray:self.requestArray block:^(id obj, BOOL ret, int pageNumber) {
//        [GHUDAlertUtils hideLoadingInView:self];
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
