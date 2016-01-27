//
//  TLSearchViewController.m
//  TL
//
//  Created by Rainbow on 2/8/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "TLSearchViewController.h"
#import "BoncDataGridDataSource.h"
#import "SBJsonParser.h"
#import "ZXTextField.h"
#import "CTabMenu.h"
#import "TLTripListRequestDTO.h"
#import "TLModuleDataHelper.h"
#import "RUtiles.h"
#import "TLStrategyDetailViewController.h"
#import "TLWayBookDetailViewController.h"
#import "TLTripNoteDetailViewController.h"
#import "TLDetailCarServiceViewController.h"
#import "TLDetailCarCommentViewController.h"
#import "TLDetailCarInfoViewController.h"
#import "TLDetailCarRentViewController.h"
#import "TLStoreDetailViewController.h"
#import "TLSecondDetailViewController.h"
#import "TLGroupActivityDetailViewController.h"
#import "MJRefresh.h"



#define CTABEMENU_HEIGHT 40.f

@interface TLSearchViewController (){
    CGFloat yOffSet;
    ZXTextField *searchField;
    NSString *gridType;
    NSString *currentTime;
    /**
     *  当前页码管理
     */
    NSString *currrentPage;
    
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) BoncDataGridDataSource *tableViewDataSource;
@property (nonatomic,strong) CTabMenu *tabMenu;
@property (nonatomic,strong) NSMutableArray *tableDataArray;

/**
 *  搜索类型 ，哪个模块
 */
@property (nonatomic,strong) NSString *searchType;
@end

@implementation TLSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"搜索";
    [self addAllUIResources];
    currrentPage = @"1";
    [self getUIData:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navBarHidden = NO;
    self.navBackItemHidden = NO;
    self.searchBtnHidden = NO;
    [self addSearchInput];
}

-(void)searchAction{
    [self.view endEditing:YES];
    NSString *keyWord = searchField.text;
    NSLog(@"搜索内容%@",keyWord);
    
    [self getUIData:YES];
}

-(void)addSearchInput{
    searchField = [[ZXTextField alloc] initWithFrame:CGRectMake(60.f, STATUSBAR_HEIGHT + 5.f, CGRectGetWidth(self.navView.frame)-120, 34.f)];
    searchField.placeholder = @"请输入搜索关键字";
    searchField.largeTextLength = 20;
    searchField.font = FONT_16;
    searchField.autoHideKeyboard = YES;
    [self.navView addSubview:searchField];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)addSelectView{
    
    NSArray * selectArray = @[
                              @{@"ID":@"1",@"NAME":@"游记",@"TYPE":@"3"},
                              @{@"ID":@"2",@"NAME":@"攻略",@"TYPE":@"1"},
                              @{@"ID":@"3",@"NAME":@"路书",@"TYPE":@"2"},
                              @{@"ID":@"4",@"NAME":@"跳蚤",@"TYPE":@"6"},
                              @{@"ID":@"5",@"NAME":@"活动",@"TYPE":@"4"},
                              @{@"ID":@"6",@"NAME":@"商家",@"TYPE":@"7"},
                              @{@"ID":@"7",@"NAME":@"车讯",@"TYPE":@"5"}
                              ];
    
    self.tabMenu = [[CTabMenu alloc] initWithFrame:CGRectMake(0.0f, yOffSet, CGRectGetWidth(self.view.frame), CTABEMENU_HEIGHT)];
    
    WEAK_SELF(self);
    self.tabMenu.MenuItemSelectedBlock = ^(id itemData){
        [weakSelf changeSelectType:itemData];
    };
    [self.view addSubview:self.tabMenu];
    [self.tabMenu setMenuData:selectArray];
    [self.tabMenu createMenu];
    [self.view addSubview:self.tabMenu];
    
    self.searchType = [selectArray[self.tabMenu.selectedIndex] valueForKey:@"TYPE"];
    
    yOffSet = yOffSet + CTABEMENU_HEIGHT;
}

-(void)changeSelectType:(id)itemData{
    self.searchType = [itemData valueForKey:@"TYPE"];
    [self getUIData:YES];
}

/**
 *  获取网络数据
 */
-(void)getUIData:(BOOL)isInit{
    
    if (isInit) {
        currrentPage = @"1";
        currentTime = [RUtiles stringFromDateWithFormat:[NSDate new] format:@"yyyyMMddHHmmss"];
    }else{
        int page = currrentPage.intValue;
        page = page+1;
        currrentPage = [NSString stringWithFormat:@"%d",page];
    }

    switch (self.searchType.integerValue) {
        case 1:
        {
            gridType = MODULE_STRATEGY;
            //title = @"攻略";
            [self getStrategy:MODULE_STRATEGY_TYPE page:currrentPage];
            break;
        }
        case 2:
        {
            gridType = MODULE_WAYBOOK;
            [self getStrategy:MODULE_WAYBOOK_TYPE page:currrentPage];
            //title = @"路书";
            break;
        }
        case 3:
        {
            gridType = MODULE_STRATEGY;
            [self getStrategy:MODULE_TRIPNOTE_TYPE page:currrentPage];
            //title = @"游记";
            break;
        }
        case 4:
        {
            gridType = MODULE_GROUPACTIVITY;
            [self activity:currrentPage];
            //title = @"召集活动";
            break;
        }
        case 5:
        {
            gridType = MODULE_CARINFO_INFO;
            //title = @"车讯";
            [self carInfo:currrentPage];
            break;
        }
        case 6:
        {
            gridType = MODULE_SECONDPATFORM;
            //title = @"二手平台";
            [self secondary:currrentPage];
            break;
        }
        case 7:
        {
            gridType = MODULE_STORE;
            //title = @"商家";
            [self store:currrentPage];
            break;
        }
        default:
            break;
    }
    
}

-(void)carInfo:(NSString *)currentPage{
    TLListCarRequestDTO *request = [[TLListCarRequestDTO alloc] init];
    
    request.currentPage = currentPage;
    request.pageSize = [NSString stringWithFormat:@"%d",TABLE_PAGE_SIZE];
    request.orderByTime = @"0";
    request.orderByViewCount = @"1";
    request.cityId = @"";
    request.type = MODULE_CARINFO_INFO_TYPE;
    request.dataType = @"1";
    request.currentTime = currentTime;
    request.searchText = searchField.text;
    request.loginId = [self.itemData valueForKey:@"LOGINID"];
    request.orderBy = @"0";
    
    WEAK_SELF(self);
    [GHUDAlertUtils toggleLoadingInView:self.view];
    
    [GTLModuleDataHelper getNewCarList:request requestArray:self.requestArray block:^(id obj, BOOL ret, int pageNumber) {
        
        [GHUDAlertUtils hideLoadingInView:self.view];
        if (ret) {
            if (currrentPage.intValue==1) {
                self.tableDataArray = [NSMutableArray arrayWithArray:obj];
                [weakSelf endHeaderRefrash];
            }else{
                [self.tableDataArray addObjectsFromArray:obj];
                [weakSelf endFooterRefrash];
            }
            
            [weakSelf refrashTableView];
        }else{
            
        }
    }];
}


-(void)store:(NSString *)currentPage{
    TLListMerchantRequestDTO *request = [[TLListMerchantRequestDTO alloc] init];
    
    request.currentPage = currentPage;
    request.pageSize = [NSString stringWithFormat:@"%d",TABLE_PAGE_SIZE];
    request.orderByTime = @"0";
    request.orderByViewCount = @"1";
    request.cityId = @"";
    request.type = MODULE_STORE_TYPE;
    request.dataType = @"1";
    request.currentTime = currentTime;
    request.searchText = searchField.text;
    request.loginId = [self.itemData valueForKey:@"LOGINID"];
       request.orderBy = @"0";
    
        WEAK_SELF(self);
    [GHUDAlertUtils toggleLoadingInView:self.view];
    [GTLModuleDataHelper getStoreList:request requestArray:self.requestArray block:^(id obj, BOOL ret, int pageNumber) {
        
        
        [GHUDAlertUtils hideLoadingInView:self.view];
        if (ret) {
            if (currrentPage.intValue==1) {
                self.tableDataArray = [NSMutableArray arrayWithArray:obj];
                [weakSelf endHeaderRefrash];
            }else{
                [self.tableDataArray addObjectsFromArray:obj];
                [weakSelf endFooterRefrash];
            }
            
            [weakSelf refrashTableView];
        }else{
            
            
        }
    }];
}

-(void)secondary:(NSString *)currentPage{
    TLListSecondGoodsRequest *request = [[TLListSecondGoodsRequest alloc] init];
    
    request.currentPage = currentPage;
    request.pageSize = [NSString stringWithFormat:@"%d",TABLE_PAGE_SIZE];
    request.orderByTime = @"0";
    request.orderByViewCount = @"1";
    request.cityId = @"";
    request.type = MODULE_SECONDPATFORM_TYPE;
    request.dataType = @"1";
    request.currentTime = currentTime;
    request.searchText = searchField.text;
    request.loginId = [self.itemData valueForKey:@"LOGINID"];
        request.orderBy = @"0";
       WEAK_SELF(self);
    [GHUDAlertUtils toggleLoadingInView:self.view];
    [GTLModuleDataHelper getSecondGoodsList:request requestArray:self.requestArray block:^(id obj, BOOL ret, int pageNumber) {
        
        [GHUDAlertUtils hideLoadingInView:self.view];
        if (ret) {
            if (currrentPage.intValue==1) {
                self.tableDataArray = [NSMutableArray arrayWithArray:obj];
                [weakSelf endHeaderRefrash];
            }else{
                [self.tableDataArray addObjectsFromArray:obj];
                [weakSelf endFooterRefrash];
            }
            
            [weakSelf refrashTableView];
        }else{
            
            
        }
    }];
}


-(void)activity:(NSString *)currentPage{
    TLActivityListRequestDTO *request = [[TLActivityListRequestDTO alloc] init];
    request.currentPage = currentPage;
    request.pageSize = [NSString stringWithFormat:@"%d",TABLE_PAGE_SIZE];
    request.orderByTime = @"0";
    request.orderByViewCount = @"1";
    request.cityId = @"";
    request.type = MODULE_GROUPACTIVITY_TYPE;
    request.dataType = @"1";
    request.currentTime = currentTime;
    request.searchText = searchField.text;
    request.loginId = [self.itemData valueForKey:@"LOGINID"];
        request.orderBy = @"0";
        WEAK_SELF(self);
    [GHUDAlertUtils toggleLoadingInView:self.view];
    [GTLModuleDataHelper getActivityList:request requestArray:self.requestArray block:^(id obj, BOOL ret, int pageNumber) {
        
        [GHUDAlertUtils hideLoadingInView:self.view];
        if (ret) {
            if (currrentPage.intValue==1) {
                self.tableDataArray = [NSMutableArray arrayWithArray:obj];
                [weakSelf endHeaderRefrash];
            }else{
                [self.tableDataArray addObjectsFromArray:obj];
                [weakSelf endFooterRefrash];
            }
            
            [weakSelf refrashTableView];
        }else{
            
            
        }
    }];
}


/**
 *  路书攻略游记
 *
 *  @param moduleType
 */
-(void)getStrategy:(NSString *)moduleType page:(NSString *)currentPage{
    TLTripListRequestDTO *request = [[TLTripListRequestDTO alloc] init];
    request.currentPage = currentPage;
    request.pageSize = [NSString stringWithFormat:@"%d",TABLE_PAGE_SIZE];
    request.orderByTime = @"0";
    request.orderByViewCount = @"1";
    request.cityId = @"";
    request.type = moduleType;
    request.dataType = @"1";
    request.loginId = [self.itemData valueForKey:@"LOGINID"];
    request.currentTime = currentTime;
    request.searchText = searchField.text;
    request.orderBy = @"0";
    
    WEAK_SELF(self);
    [GHUDAlertUtils toggleLoadingInView:self.view];
    [GTLModuleDataHelper getTripList:request requestArr:self.requestArray block:^(id obj, BOOL ret, int pageNumber) {
        [GHUDAlertUtils hideLoadingInView:self.view];

        if (ret) {
            if (currrentPage.intValue==1) {
                self.tableDataArray = [NSMutableArray arrayWithArray:obj];
                [weakSelf endHeaderRefrash];
            }else{
                [self.tableDataArray addObjectsFromArray:obj];
                [weakSelf endFooterRefrash];
            }
            
            [weakSelf refrashTableView];
            
        }else{
            
        }
    }];
}


-(void)refrashTableView{
    NSMutableArray *sectionDataArray = [[NSMutableArray alloc] init];
    NSMutableArray *gridDataArray = [[NSMutableArray alloc] init];
    
    NSDictionary *section = @{@"SECTION_TYPE":@"1",@"CELL_TYPE": gridType,@"TITLE":@""};
    [sectionDataArray addObject:section];
    [gridDataArray addObject:self.tableDataArray];
    [self.tableViewDataSource setSections:sectionDataArray];
    [self.tableViewDataSource setGridData:gridDataArray];
    [self.tableView reloadData];
}




-(void)addAllUIResources{
    
    
    yOffSet = NAVIGATIONBAR_HEIGHT+STATUSBAR_HEIGHT;
    [self addSelectView];
    

    /**
     添加分类菜单
     */
    
    
    
    
    
    
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, yOffSet, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-yOffSet)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.tableView];
    
    
    [self.tableView addHeaderWithTarget:self action:@selector(initTableData)];
    [self.tableView addFooterWithTarget:self action:@selector(refrashTableData)];
    
    NSMutableArray *sectionDataArray = [[NSMutableArray alloc] init];
    NSMutableArray *gridDataArray = [[NSMutableArray alloc] init];
    
    
//    NSString *filePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"userlist.json"];
//    NSString *jsonStr = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
//    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
//    NSArray *userList = [jsonParser objectWithString:jsonStr];
//    [gridDataArray addObject:userList];
//    
//    NSDictionary *userSection = @{@"SECTION_TYPE":@"1",@"CELL_TYPE": TL_USER_CELL,@"TITLE":@"用户"};
//    [sectionDataArray addObject:userSection];

    
    
//    for (int i=1;i<=8; i++) {
//        if (i==5||i==7) {
//            continue;
//        }
//        NSString *typeId = [NSString stringWithFormat:@"%d",i];
//        
//        NSString *filePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"list_%@.json",typeId]];
//        NSString *jsonStr = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
//        SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
//        NSArray *dataList = [jsonParser objectWithString:jsonStr];
//        
//        
//        
//        if (dataList==nil) {
//            dataList = @[];
//        }
//        
//        [gridDataArray addObject:dataList];
//        
//        NSString *title = @"";
//        NSString *gridType = @"";
//        switch (i) {
//            case 1:
//            {
//                gridType = MODULE_STRATEGY;
//                title = @"攻略";
//                break;
//            }
//            case 2:
//            {
//                gridType = MODULE_WAYBOOK;
//                title = @"路书";
//                break;
//            }
//            case 3:
//            {
//                gridType = MODULE_STRATEGY;
//                title = @"游记";
//                break;
//            }
//            case 4:
//            {
//                gridType = MODULE_GROUPACTIVITY;
//                title = @"召集活动";
//                break;
//            }
//            case 5:
//            {
//                gridType = MODULE_CARINFO;
//                title = @"车讯";
//                break;
//            }
//            case 6:
//            {
//                gridType = MODULE_SECONDPATFORM;
//                title = @"二手平台";
//                break;
//            }
//            case 7:
//            {
//                gridType = MODULE_EMERGENCY;
//                title = @"应急救援";
//                break;
//            }
//                
//            case 8:
//            {
//                gridType = MODULE_STORE;
//                title = @"商家";
//                break;
//            }
//            default:
//                break;
//        }
//        
//        NSDictionary *section = @{@"SECTION_TYPE":@"1",@"CELL_TYPE": gridType,@"TITLE":title};
//        [sectionDataArray addObject:section];
//
//    }
//    
    
    
//    for (int i=1;i<=4; i++) {
//
//        NSString *typeId = [NSString stringWithFormat:@"%d",i];
//        
//        NSString *filePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"carlist_%@.json",typeId]];
//        NSString *jsonStr = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
//        SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
//        NSArray *dataList = [jsonParser objectWithString:jsonStr];
//        
//        
//        
//        if (dataList==nil) {
//            dataList = @[];
//        }
//        
//        [gridDataArray addObject:dataList];
//        
//        NSString *title = @"";
//        NSString *gridType = @"";
//        switch (i) {
//            case 1:
//            {
//                gridType = MODULE_CARINFO_INFO;
//                title = @"新车资讯";
//                break;
//            }
//            case 2:
//            {
//                gridType = MODULE_CARINFO_COMMENT;
//                title = @"车评";
//                break;
//            }
//            case 3:
//            {
//                gridType = MODULE_CARINFO_HIRE;
//                title = @"车辆租赁";
//                break;
//            }
//            case 4:
//            {
//                gridType = MODULE_CARINFO_SERVICE;
//                title = @"车辆服务";
//                break;
//            }
//            default:
//                break;
//        }
//        
//        NSDictionary *section = @{@"SECTION_TYPE":@"1",@"CELL_TYPE": gridType,@"TITLE":title};
//        [sectionDataArray addObject:section];
//        
//    }
//    
    
    
    NSDictionary *itemData = @{
                               @"type": @"REPORT",
                               @"gridType": @"SEARCH_GRID",
                               @"gridId": @"SEARCH_GRID",
                               @"GRID_DATA": gridDataArray,
                               @"SECTION_DATA":sectionDataArray,
                               @"isShowHeader": @"0",
                               @"headerData": @{}
                               };
    self.tableViewDataSource = [[BoncDataGridDataSource alloc] initWithTableView:self.tableView itemData:itemData];
    
    __weak TLSearchViewController *weakController = self;
    self.tableViewDataSource.ItemSelectedBlock = ^(id itemData){
        [weakController itemSelected:itemData];
    };

}


-(void)initTableData{
    [self getUIData:YES];
}
-(void)refrashTableData{
    [self getUIData:NO];
}

-(void)itemSelected:(id)itemData{

    NSString *cellType = gridType;
    
    if ([MODULE_STRATEGY isEqualToString:cellType]) {
        [self pushViewControllerWithName:@"TLStrategyDetailViewController" itemData:itemData block:^(TLStrategyDetailViewController  *obj) {
            obj.dataType = @"1";
        }];
    }else if ([MODULE_WAYBOOK isEqualToString:cellType]){
        [self pushViewControllerWithName:@"TLWayBookDetailViewController" itemData:itemData block:^(TLWayBookDetailViewController* obj) {
            obj.dataType = @"1";
        }];
    }else if ([MODULE_TRIPNOTE isEqualToString:cellType]){
        [self pushViewControllerWithName:@"TLTripNoteDetailViewController" itemData:itemData block:^(TLTripNoteDetailViewController* obj) {
            obj.dataType = @"1";
        }];
    }else if ([MODULE_GROUPACTIVITY isEqualToString:cellType]){
        [self pushViewControllerWithName:@"TLGroupActivityDetailViewController" itemData:itemData block:^(TLGroupActivityDetailViewController* obj) {
            obj.dataType = @"1";
        }];
    }else if ([MODULE_CARINFO isEqualToString:cellType]){
        [self pushViewControllerWithName:@"" itemData:itemData block:^(id obj) {
            
        }];
    }else if ([MODULE_SECONDPATFORM isEqualToString:cellType]){
        [self pushViewControllerWithName:@"TLSecondDetailViewController" itemData:itemData block:^(TLSecondDetailViewController* obj) {
                        obj.dataType = @"1";
        }];
    }else if ([MODULE_EMERGENCY isEqualToString:cellType]){
        [self pushViewControllerWithName:@"" itemData:itemData block:^(id obj) {
            
        }];
    }else if ([MODULE_STORE isEqualToString:cellType]){
        [self pushViewControllerWithName:@"TLStoreDetailViewController" itemData:itemData block:^(TLStoreDetailViewController* obj) {
            obj.dataType = @"1";
        }];
    }else if ([MODULE_CARINFO_INFO isEqualToString:cellType]){
        [self pushViewControllerWithName:@"TLDetailCarInfoViewController" itemData:itemData block:^(TLDetailCarInfoViewController* obj) {
            obj.dataType = @"1";
        }];
    }else if ([MODULE_CARINFO_COMMENT isEqualToString:cellType]){
        [self pushViewControllerWithName:@"TLDetailCarCommentViewController" itemData:itemData block:^(TLDetailCarCommentViewController* obj) {
            obj.dataType = @"1";
        }];
    }else if ([MODULE_CARINFO_HIRE isEqualToString:cellType]){
        [self pushViewControllerWithName:@"TLDetailCarRentViewController" itemData:itemData block:^(TLDetailCarRentViewController* obj) {
            obj.dataType = @"1";
        }];
    }else if ([MODULE_CARINFO_SERVICE isEqualToString:cellType]){
        [self pushViewControllerWithName:@"TLDetailCarServiceViewController" itemData:itemData block:^(TLDetailCarServiceViewController* obj) {
            obj.dataType = @"1";
        }];
    }else if ([TL_USER_CELL isEqualToString:cellType]){
       
    }
    
    
}

-(void)endFooterRefrash{
    [_tableView footerEndRefreshing];
}
-(void)endHeaderRefrash{
    [_tableView headerEndRefreshing];
}
@end
