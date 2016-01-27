//
//  TLCarCommentListView.m
//  TL
//
//  Created by Rainbow on 3/30/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "TLCarCommentListView.h"
#import "TLModuleDataHelper.h"
#import "RUtiles.h"
#import "TLListCarEvalutionRequestDTO.h"

#import "TLDropViewMenu.h"
#import "TLCitySelectView.h"
#import "TLDropMenu.h"

@interface TLCarCommentListView (){
    TLCitySelectView *citySelctView;
    NSString *cartTypeSoftId;
}
@property (nonatomic,strong) TLDropViewMenu *sortMenuView;
@end
@implementation TLCarCommentListView


-(void)addSortView{
    ///////////////
    
    NSArray *sortMenuArray =  @[@{@"ID":@"1",@"NAME":@"车型"},
                                @{@"ID":@"2",@"NAME":@"排序"}];
    _sortMenuView = [[TLDropViewMenu alloc] initWithFrame:CGRectMake(0.f, 0.f, CGRectGetWidth(self.frame), 40.f) menuData:sortMenuArray];
    _sortMenuView.frameHeight = self.height;
    _sortMenuView.isMenuHidden = YES;
    [self addSubview:_sortMenuView];
    
    
    
    
    
    WEAK_SELF(self);
    
    //    citySelctView = [[TLCitySelectView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.width, self.height/2)];
    //    citySelctView.SelectedCityBlock = ^(TLCityDTO *city){
    //        [weakSelf cityChange:city];
    //    };
    
    
    //排序—默认，时间，人均消费，活动天数
    NSArray *sortMenuItemsArray =  @[@{@"ID":@"0",@"NAME":@"默认排序"},
                                     @{@"ID":@"1",@"NAME":@"价格"},
                                     @{@"ID":@"2",@"NAME":@"上市时间"}];
    TLDropMenu *sortItemMenu = [[TLDropMenu alloc] initWithFrame:CGRectMake(0.f, 0.f, CGRectGetWidth(self.frame),80.0f) menuData:sortMenuItemsArray];
    sortItemMenu.ItemSelectedBlock = ^(id itemData){
        [weakSelf sortChange:itemData];
    };
    
    
    //suv   商务车  房车、 轿车、跑车
    NSArray *carTypeMenuItemsArray = [[GUserDataHelper keyValueDic] objectForKey:@"carType"];
    //    @[@{@"ID":@"1",@"NAME":@"全部"},
    //                                     @{@"ID":@"2",@"NAME":@"SUV"},
    //                                     @{@"ID":@"3",@"NAME":@"商务车"},
    //                                        @{@"ID":@"4",@"NAME":@"房车"},
    //                                        @{@"ID":@"5",@"NAME":@"轿车"},
    //                                        @{@"ID":@"6",@"NAME":@"跑车"}];
    TLDropMenu *carTypeItemMenu = [[TLDropMenu alloc] initWithFrame:CGRectMake(0.f, 0.f, CGRectGetWidth(self.frame),80.0f) menuData:carTypeMenuItemsArray];
    carTypeItemMenu.ItemSelectedBlock = ^(id itemData){
        [weakSelf carTypeSortChange:itemData];
    };
    
    
    
    
    _sortMenuView.viewArray = [NSMutableArray arrayWithObjects:carTypeItemMenu,sortItemMenu, nil];
    
    
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
    cartTypeSoftId = [itemData valueForKey:@"ID"];
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
    
    TLListCarEvalutionRequestDTO *request = [[TLListCarEvalutionRequestDTO alloc] init];
    
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
        request.carType = cartTypeSoftId;
    
//    [GHUDAlertUtils toggleLoadingInView:self];
    
    [GTLModuleDataHelper getCarEvalutionList:request requestArray:self.requestArray block:^(id obj, BOOL ret, int pageNumber) {
        
        
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
    TLListCarEvalutionRequestDTO *request = [[TLListCarEvalutionRequestDTO alloc] init];
    
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
    request.carType = cartTypeSoftId;
//    [GHUDAlertUtils toggleLoadingInView:self];
    
   [GTLModuleDataHelper getCarEvalutionList:request requestArray:self.requestArray block:^(id obj, BOOL ret, int pageNumber) {
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
