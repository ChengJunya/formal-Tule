//
//  TLGroupActivityListViewController.m
//  TL
//
//  Created by Rainbow on 2/16/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "TLGroupActivityListViewController.h"
#import "TLActivityListRequestDTO.h"
#import "TLModuleDataHelper.h"
#import "TLGroupActivityDetailViewController.h"
#import "RUtiles.h"
#import "TLNewGroupActivityViewController.h"
#import "TLDropViewMenu.h"
#import "TLCitySelectView.h"
#import "TLDropMenu.h"
@interface TLGroupActivityListViewController (){
    TLCitySelectView *citySelctView;
    
}
@property (nonatomic,strong) TLDropViewMenu *sortMenuView;
@end

@implementation TLGroupActivityListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)itemSelected:(NSDictionary *)itemData{
    
    [self pushViewControllerWithName:@"TLGroupActivityDetailViewController" itemData:itemData block:^(TLGroupActivityDetailViewController* obj) {
            obj.dataType = [self.itemData valueForKey:@"DATATYPE"];
    }];
    
    
}
-(void)addCreateActionBtnHandler{
    if(GUserDataHelper.tlUserInfo.isVip.integerValue!=1){
        [GHUDAlertUtils toggleMessage:@"只有会员才能发布活动!"];
        return;
    }

    [self pushViewControllerWithName:@"TLNewGroupActivityViewController" block:^(TLNewGroupActivityViewController* obj) {
        obj.operateType = @"1";
    }];
}

-(void)addSortView{
    ///////////////
    
    NSArray *sortMenuArray =  @[@{@"ID":@"1",@"NAME":@"地点"},
                                @{@"ID":@"2",@"NAME":@"排序"}];
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
    NSArray *sortMenuItemsArray =  @[@{@"ID":@"0",@"NAME":@"默认排序"},
                                     @{@"ID":@"1",@"NAME":@"发表时间"},
                                     @{@"ID":@"2",@"NAME":@"人均消费"},
                                     @{@"ID":@"3",@"NAME":@"活动天数"}];
    TLDropMenu *sortItemMenu = [[TLDropMenu alloc] initWithFrame:CGRectMake(0.f, 0.f, CGRectGetWidth(self.view.frame),80.0f) menuData:sortMenuItemsArray];
    
    
    
    _sortMenuView.viewArray = [NSMutableArray arrayWithObjects:citySelctView,sortItemMenu, nil];
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
    self.refrashTime = [RUtiles stringFromDateWithFormat:[NSDate new] format:@"yyyyMMddHHmmss"];
    self.currentPage = 1;
    TLActivityListRequestDTO *request = [[TLActivityListRequestDTO alloc] init];
    
    request.currentPage = [NSString stringWithFormat:@"%d",self.currentPage];
    request.pageSize = [NSString stringWithFormat:@"%d",TABLE_PAGE_SIZE];
    request.orderByTime = self.orderByTime;
    request.orderByViewCount = self.orderByViewCount;
    request.cityId = self.cityId;
    request.type = MODULE_GROUPACTIVITY_TYPE;
    request.dataType = [self.itemData valueForKey:@"DATATYPE"];
    request.currentTime = self.refrashTime;
        request.loginId = [self.itemData valueForKey:@"LOGINID"];
    request.orderBy = self.sortId;
    
    [GHUDAlertUtils toggleLoadingInView:self.view];
    [GTLModuleDataHelper getActivityList:request requestArray:self.requestArray block:^(id obj, BOOL ret, int pageNumber) {
        
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
    TLActivityListRequestDTO *request = [[TLActivityListRequestDTO alloc] init];
    request.currentPage = [NSString stringWithFormat:@"%d",(self.currentPage+1)];
    request.pageSize = [NSString stringWithFormat:@"%d",TABLE_PAGE_SIZE];
    request.orderByTime = self.orderByTime;
    request.orderByViewCount = self.orderByViewCount;
    request.cityId = self.cityId;
    request.type = MODULE_GROUPACTIVITY_TYPE;
    request.dataType = [self.itemData valueForKey:@"DATATYPE"];
    request.currentTime = self.refrashTime;
        request.loginId = [self.itemData valueForKey:@"LOGINID"];
        request.orderBy = self.sortId;
    
    [GHUDAlertUtils toggleLoadingInView:self.view];
    [GTLModuleDataHelper getActivityList:request requestArray:self.requestArray block:^(id obj, BOOL ret, int pageNumber) {
        
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
