//
//  TLCarRectListView.m
//  TL
//
//  Created by Rainbow on 3/30/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "TLCarRectListView.h"
#import "TLModuleDataHelper.h"
#import "RUtiles.h"
#import "TLListCarRectRequestDTO.h"
#import "TLDropViewMenu.h"
#import "TLCitySelectView.h"
#import "TLDropMenu.h"

@interface TLCarRectListView (){
    TLCitySelectView *citySelctView;
    NSString *cartTypeSoftId;
    NSString *priceRange;
}
@property (nonatomic,strong) TLDropViewMenu *sortMenuView;
@end
@implementation TLCarRectListView




-(void)addSortView{
    ///////////////
    
    NSArray *sortMenuArray =  @[@{@"ID":@"1",@"NAME":@"地点"},
                                @{@"ID":@"2",@"NAME":@"车型"},
                                @{@"ID":@"3",@"NAME":@"价格"}];
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
    //NSArray *sortMenuItemsArray =  @[@{@"ID":@"1",@"NAME":@"默认排序"},
//                                     @{@"ID":@"2",@"NAME":@"价格"},
//                                     @{@"ID":@"3",@"NAME":@"区域"}];
//    TLDropMenu *sortItemMenu = [[TLDropMenu alloc] initWithFrame:CGRectMake(0.f, 0.f, CGRectGetWidth(self.frame),80.0f) menuData:sortMenuItemsArray];
//    
    //suv   商务车  房车、 轿车、跑车
    NSArray *carTypeMenuItemsArray = [[GUserDataHelper keyValueDic] objectForKey:@"carType"];
//    @[@{@"ID":@"1",@"NAME":@"全部"},
//                                        @{@"ID":@"2",@"NAME":@"SUV"},
//                                        @{@"ID":@"3",@"NAME":@"商务车"},
//                                        @{@"ID":@"4",@"NAME":@"房车"},
//                                        @{@"ID":@"5",@"NAME":@"轿车"},
//                                        @{@"ID":@"6",@"NAME":@"跑车"}];
    TLDropMenu *carTypeItemMenu = [[TLDropMenu alloc] initWithFrame:CGRectMake(0.f, 0.f, CGRectGetWidth(self.frame),80.0f) menuData:carTypeMenuItemsArray];
    carTypeItemMenu.ItemSelectedBlock = ^(id itemData){
        [weakSelf carTypeSortChange:itemData];
    };
    

    
    //增加服务种类（汽车美容、汽车维修、汽车用品店，4s店，可多选）；排序 离我最近
    NSArray *serviceTypeMenuItemsArray =  @[@{@"ID":@"1",@"NAME":@"100以下"},
                                            @{@"ID":@"2",@"NAME":@"100-300"},
                                            @{@"ID":@"3",@"NAME":@"300-500"},
                                            @{@"ID":@"4",@"NAME":@"500-800"},
                                            @{@"ID":@"4",@"NAME":@"800以上"}];
    TLDropMenu *serviceTypeItemMenu = [[TLDropMenu alloc] initWithFrame:CGRectMake(0.f, 0.f, CGRectGetWidth(self.frame),80.0f) menuData:serviceTypeMenuItemsArray];
    serviceTypeItemMenu.ItemSelectedBlock = ^(id itemData){
        [weakSelf serviceTypeSortChange:itemData];
    };
    
    

    
    _sortMenuView.viewArray = [NSMutableArray arrayWithObjects:citySelctView,carTypeItemMenu,serviceTypeItemMenu, nil];
    
    
    self.sortId = [sortMenuArray[0] valueForKey:@"ID"];
    //////////////////////
}

/*设置排序 时间还是人气 还是默认*/
-(void)serviceTypeSortChange:(NSDictionary*)itemData{
    self.sortMenuView.isMenuHidden = YES;
    priceRange = [itemData valueForKey:@"ID"];
    if (_sortMenuView.btnArray.count>2) {
        UIButton *btn = _sortMenuView.btnArray[2];
        [btn setTitle:[itemData valueForKey:@"NAME"] forState:UIControlStateNormal];
    }
    [self initData];
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
    cartTypeSoftId = [itemData valueForKey:@"ID"];
    if (_sortMenuView.btnArray.count>1) {
        UIButton *btn = _sortMenuView.btnArray[1];
        [btn setTitle:[itemData valueForKey:@"NAME"] forState:UIControlStateNormal];
    }
    [self initData];
}




-(void)initData{
    
    self.currentPage = 1;
    self.refrashTime = [RUtiles stringFromDateWithFormat:[NSDate new] format:@"yyyyMMddHHmmss"];
    
    TLListCarRectRequestDTO *request = [[TLListCarRectRequestDTO alloc] init];
    
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
    request.carType = cartTypeSoftId==nil?@"":cartTypeSoftId;
    request.priceRange = priceRange==nil?@"":priceRange;
    request.searchText = @"";
//    [GHUDAlertUtils toggleLoadingInView:self];
    
    [GTLModuleDataHelper getCarRectList:request requestArray:self.requestArray block:^(id obj, BOOL ret, int pageNumber) {
        
        
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
    TLListCarRectRequestDTO *request = [[TLListCarRectRequestDTO alloc] init];
    
    request.currentPage = [NSString stringWithFormat:@"%d",(self.currentPage+1)];
    request.pageSize = [NSString stringWithFormat:@"%d",TABLE_PAGE_SIZE];
    request.orderByTime = self.orderByTime;
    request.orderByViewCount = self.orderByViewCount;
    request.currentTime = self.refrashTime;
    request.cityId = self.cityId;
    request.type = MODULE_CARINFO_HIRE_TYPE;
    request.dataType = [self.itemData valueForKey:@"DATATYPE"];
        request.loginId = [self.itemData valueForKey:@"LOGINID"];
    request.orderBy = self.sortId;
    request.carType = cartTypeSoftId;
    request.priceRange = priceRange;
    
//    [GHUDAlertUtils toggleLoadingInView:self];
    
    [GTLModuleDataHelper getCarRectList:request requestArray:self.requestArray block:^(id obj, BOOL ret, int pageNumber) {
        
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
