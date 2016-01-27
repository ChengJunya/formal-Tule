//
//  TLModuleListViewController.m
//  TL
//
//  Created by Rainbow on 2/8/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "TLModuleListViewController.h"
#import "BoncDataGridDataSource.h"
#import "ZXListViewAssist.h"
#import "MJRefresh.h"
#import "TLDropMenu.h"
#import "TLCitySelectView.h"
#import "TLDropViewMenu.h"
#import "SBJsonParser.h"
#import "RTextIconBtn.h"
#import "TLCityDTO.h"
#import "TLHelper.h"
#define TLMODULE_LIST_SORT_MENU_HEIGHT 40.f

@interface TLModuleListViewController (){
    TLCitySelectView *citySelctView;

}
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong) BoncDataGridDataSource *tableViewDataSource;

@property (nonatomic,strong) TLDropMenu *menu;
@property (nonatomic,strong) UIButton *itemBtn;
@property (nonatomic,assign) CGFloat yOffSet;
@property (nonatomic,strong) TLDropViewMenu *sortMenuView;
@end

@implementation TLModuleListViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    
    _yOffSet = NAVIGATIONBAR_HEIGHT+STATUSBAR_HEIGHT+40.f;
    self.currentPage = 1;
    self.cityId = @"";
    self.orderByTime = @"0";
    self.orderByViewCount = @"0";
    self.sortId = @"0";

    self.isHiddenModelSelecter = [self.itemData valueForKey:@"IS_SHOW_MENU"];
    self.isHiddenAddBtn =[self.itemData valueForKey:@"IS_SHOW_ADD"];

    if (self.isHiddenModelSelecter.integerValue==1) {
        self.title = [self.itemData valueForKey:@"NAME"];
    }
    /*
     1,选择分类按钮
     2,tableview
     3,不同的cell
     4,地市选择
     5,排序选择
     6,新增发布
     
     */
    [self addAllUIResources];
    [self initData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navBarHidden = NO;
    self.navBackItemHidden = NO;
    
    
    if (self.isHiddenAddBtn.integerValue == 1) {
    }else{
        self.navView.actionBtns = @[[self addCreateActionBtn]];
    }
    if (self.isHiddenModelSelecter.integerValue==1) {
        
    }else{
        [self addTitleSelectItem];
    }
    
//    [self initData];
    
}

//选择分类按钮 添加在导航栏上
- (void)addTitleSelectItem{
    CGRect itemFrame = CGRectMake((self.view.width-100)/2, (NAVIGATIONBAR_HEIGHT-30)/2+STATUSBAR_HEIGHT, 100.f, 30.f);
    //
    _itemBtn = [[RTextIconBtn alloc] initWithFrame:itemFrame];
    [_itemBtn setImage:[UIImage imageNamed:@"down"] forState:UIControlStateNormal];
    [_itemBtn setImage:[UIImage imageNamed:@"up_arraw"] forState:UIControlStateSelected];
    [_itemBtn addTarget:self action:@selector(btnHandler:) forControlEvents:UIControlEventTouchUpInside];
    [_itemBtn setTitle:[self.itemData valueForKey:@"NAME"] forState:UIControlStateNormal];
    [_itemBtn setTitleColor:COLOR_ORANGE_TEXT forState:UIControlStateNormal];
    [_itemBtn setTitleColor:COLOR_MAIN_TEXT forState:UIControlStateSelected];
    [self.navView addSubview:_itemBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

-(void)addAllUIResources{
    [self addTableView];
    [self addSortView];
    if (self.isHiddenModelSelecter.integerValue==1) {

    }else{
        [self addModuleSelecter];
    }

    //[self initData];
}

//module选择
-(void)addModuleSelecter{
    self.dataType = [self.itemData valueForKey:@"DATATYPE"];
    NSString *dataTypeStr = self.dataType.length>0?self.dataType:@"1";//默认全部
    NSArray *menuData =  @[@{@"ID":@"1",@"NAME":@"攻略",@"IMG":@"menu1_homepage",@"VCNAME":@"TLStrategyListViewController",@"TYPE":@"1",@"DATATYPE":dataTypeStr},
                           @{@"ID":@"2",@"NAME":@"路书",@"IMG":@"menu2_homepage",@"VCNAME":@"TLWayBookListViewController",@"TYPE":@"2",@"DATATYPE":dataTypeStr},
                           @{@"ID":@"3",@"NAME":@"游记",@"IMG":@"menu3_homepage",@"VCNAME":@"TLTripNoteListViewController",@"TYPE":@"3",@"DATATYPE":dataTypeStr},
                           @{@"ID":@"4",@"NAME":@"活动",@"IMG":@"menu4_homepage",@"VCNAME":@"TLGroupActivityListViewController",@"TYPE":@"4",@"DATATYPE":dataTypeStr},
                           @{@"ID":@"5",@"NAME":@"车讯",@"IMG":@"menu5_homepage",@"VCNAME":@"TLCarMainListViewController",@"TYPE":@"5",@"DATATYPE":dataTypeStr},
                           @{@"ID":@"6",@"NAME":@"跳蚤",@"IMG":@"menu6_homepage",@"VCNAME":@"TLSecondPlatformViewController",@"TYPE":@"6",@"DATATYPE":dataTypeStr},
                           @{@"ID":@"7",@"NAME":@"应急救援",@"IMG":@"menu7_homepage",@"VCNAME":@"TLEmergencyViewController",@"TYPE":@"7",@"DATATYPE":dataTypeStr},
                           @{@"ID":@"8",@"NAME":@"商家",@"IMG":@"menu8_homepage",@"VCNAME":@"TLStoreListViewController",@"TYPE":@"8",@"DATATYPE":dataTypeStr}];
    
    
    
    /////////////////
    
//    NSArray *sortMenuArray =  @[@{@"ID":@"1",@"NAME":@"地点"},
//                                @{@"ID":@"2",@"NAME":@"排序"}];
//    _sortMenuView = [[TLDropViewMenu alloc] initWithFrame:CGRectMake(0.f, NAVIGATIONBAR_HEIGHT+STATUSBAR_HEIGHT, CGRectGetWidth(self.view.frame), 40.f) menuData:sortMenuArray];
//    _sortMenuView.frameHeight = self.view.height-NAVIGATIONBAR_HEIGHT+STATUSBAR_HEIGHT;
//    _sortMenuView.isMenuHidden = YES;
//    [self.view addSubview:_sortMenuView];
//    
//    
//    
//
//
//        WEAK_SELF(self);
//    
//    citySelctView = [[TLCitySelectView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.width, self.view.height/2)];
//    citySelctView.SelectedCityBlock = ^(TLCityDTO *city){
//        [weakSelf cityChange:city];
//    };
//    
//    
//    NSArray *sortMenuItemsArray =  @[@{@"ID":@"1",@"NAME":@"默认排序"},
//                                     @{@"ID":@"2",@"NAME":@"发表时间"},
//                                     @{@"ID":@"3",@"NAME":@"人气最高"}];
//    TLDropMenu *sortItemMenu = [[TLDropMenu alloc] initWithFrame:CGRectMake(0.f, 0.f, CGRectGetWidth(self.view.frame),40.0f) menuData:sortMenuItemsArray];
//    
//    
//    
//    _sortMenuView.viewArray = [NSMutableArray arrayWithObjects:citySelctView,sortItemMenu, nil];
//    sortItemMenu.ItemSelectedBlock = ^(id itemData){
//        [weakSelf sortChange:itemData];
//    };
    
    ////////////////////////
    
    _menu = [[TLDropMenu alloc] initWithFrame:CGRectMake(0.f, NAVIGATIONBAR_HEIGHT+STATUSBAR_HEIGHT, CGRectGetWidth(self.view.frame),self.view.height-NAVIGATIONBAR_HEIGHT+STATUSBAR_HEIGHT) menuData:menuData];
    [self.view addSubview:_menu];
    [_menu setFrame:CGRectMake(0.f, NAVIGATIONBAR_HEIGHT+STATUSBAR_HEIGHT, _menu.width, _menu.height)];
    __weak TLModuleListViewController *weakController = self;
    _menu.ItemSelectedBlock=^(id itemData){
        [weakController setItemBtnTitle:itemData];
    };
    _menu.isMenuHidden = YES;
    _menu.selectedItem = self.itemData;
    

    
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
    
    
        NSArray *sortMenuItemsArray =  @[@{@"ID":@"1",@"NAME":@"默认排序"},
                                         @{@"ID":@"2",@"NAME":@"发表时间"},
                                         @{@"ID":@"3",@"NAME":@"人气最高"}];
        TLDropMenu *sortItemMenu = [[TLDropMenu alloc] initWithFrame:CGRectMake(0.f, 0.f, CGRectGetWidth(self.view.frame),40.0f) menuData:sortMenuItemsArray];
    
    
    
        _sortMenuView.viewArray = [NSMutableArray arrayWithObjects:citySelctView,sortItemMenu, nil];
        sortItemMenu.ItemSelectedBlock = ^(id itemData){
            [weakSelf sortChange:itemData];
        };
    
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
    NSString *sortId = [itemData valueForKey:@"ID"];
    switch ([sortId integerValue]) {
        case 1:
        {
            self.orderByTime = @"0";
            self.orderByViewCount = @"0";
            self.sortId = @"0";
            break;
        }
        case 2:
        {
            self.orderByTime = @"1";
            self.orderByViewCount = @"0";
            self.sortId = @"1";
            break;
        }
        case 3:
        {
            self.orderByTime = @"0";
            self.orderByViewCount = @"1";
            self.sortId = @"2";
            break;
        }
        default:
            break;
    }
    if (_sortMenuView.btnArray.count>1) {
        UIButton *btn = _sortMenuView.btnArray[1];
        [btn setTitle:[itemData valueForKey:@"NAME"] forState:UIControlStateNormal];
    }
    [self initData];
}


//////////////////////////////sortviewend/////////////////////////////



-(void)setItemBtnTitle:(id)itemData{
    _menu.isMenuHidden = YES;
    [_itemBtn setTitle:[itemData valueForKey:@"NAME"] forState:UIControlStateNormal];
    [_itemBtn setTitle:[itemData valueForKey:@"NAME"] forState:UIControlStateSelected];
    _itemBtn.selected = NO;
    [_itemBtn setNeedsDisplay];
  
    
    [RTLHelper poptoViewControllerWithName:[itemData valueForKey:@"VCNAME"] itemData:itemData block:^(id obj) {
        
    }];
}





- (UIButton*)addCreateActionBtn
{
    
    //    UIImage *backImage = [UIImage imageNamed:@"ico_backon"];
    UIButton *actionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    actionBtn.frame = CGRectMake(0.f, 0.f, 44.f, 44.f);
    [actionBtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    //    [actionBtn setImage:[UIImage imageNamed:@"ico_backon" ] forState:UIControlStateHighlighted];
    [actionBtn addTarget:self action:@selector(addCreateActionBtnHandler) forControlEvents:UIControlEventTouchUpInside];
    return actionBtn;
}

-(void)addCreateActionBtnHandler{
    [self pushViewControllerWithName:@"TLNewStrategyViewController" block:^(id obj) {
        
    }];
}
-(void)btnHandler:(UIButton*)btn{
    if (btn.selected) {
        _menu.isMenuHidden = YES;
        btn.selected = NO;
    }else{
        _menu.isMenuHidden = NO;
        btn.selected = YES;
    }
}

-(void)addTableView{
    //NSString *cellHeight = [NSString stringWithFormat:@"%f",80.f];
    
    /*
     攻略数据格式 
     1-攻略 2-路书 3-游记 4-召集活动 5-车讯 6-二手平台 7-应急救援 8-商家
     */
    
    //信息 1-到期提醒 2-系统升级 3－推广
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, _yOffSet, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-NAVIGATIONBAR_HEIGHT-STATUSBAR_HEIGHT-40.f)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    
    
    /**************test*/

//    NSString *typeId = [self.itemData valueForKey:@"TYPE"];
//    
//    NSString *filePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"list_%@.json",typeId]];
//    NSString *jsonStr = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
//    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
//    NSArray *dataList = [jsonParser objectWithString:jsonStr];
    

    
//    if (dataList==nil) {
//        dataList = @[];
//    }
//    
//    
//    
//    
    NSString *gridType = @"";
    switch ([[self.itemData valueForKey:@"TYPE"] intValue]) {
        case 1:
        {
            gridType = MODULE_STRATEGY;
            break;
        }
        case 2:
        {
            gridType = MODULE_WAYBOOK;
            break;
        }
        case 3:
        {
            gridType = MODULE_WAYBOOK;
            break;
        }
        case 4:
        {
            gridType = MODULE_GROUPACTIVITY;
            break;
        }
        case 5:
        {
            gridType = MODULE_CARINFO;
            break;
        }
        case 6:
        {
            gridType = MODULE_SECONDPATFORM;
            break;
        }
        case 7:
        {
            gridType = MODULE_EMERGENCY;
            break;
        }
            
        case 8:
        {
            gridType = MODULE_STORE;
            break;
        }
        default:
            break;
    }
    
    NSArray *dataList = @[];
    NSDictionary *itemData = @{
                               @"type": @"REPORT",
                               @"GRID_DATA": @[dataList],
                               @"SECTION_DATA":@[@{@"SECTION_TYPE":@"1",@"CELL_TYPE": gridType}],
                               @"isShowHeader": @"0",
                               @"headerData": @{}
                               };
    
    self.tableViewDataSource = [[BoncDataGridDataSource alloc] initWithTableView:self.tableView itemData:itemData];
    
    __weak TLModuleListViewController *weakController = self;
    self.tableViewDataSource.ItemSelectedBlock = ^(id itemData){
        [weakController itemSelected:itemData];
    };
    [self.tableView addHeaderWithTarget:self action:@selector(initData)];
    [self.tableView addFooterWithTarget:self action:@selector(refreshData)];
    
    
    _yOffSet = _yOffSet+CGRectGetHeight(self.tableView.frame);
    [self.view addSubview:self.tableView];
    
    self.listAssistView = [[ZXListViewAssist alloc] initWithAttachView:_tableView];
    [_tableView addSubview:self.listAssistView];
    [self.listAssistView setShowType:ELAST_EMPTY showLabel:@"当前没有数据"];

}
-(void)loadNewPagedata{
    
}


-(void)endFooterRefrash{
    [_tableView footerEndRefreshing];
}
-(void)endHeaderRefrash{
    [_tableView headerEndRefreshing];
}


//获得消息后，刷新数据
-(void)refreshData{
    //[GHUDAlertUtils toggleLoadingInView:self.view];
    
    
    [_tableView reloadData];
    //[GHUDAlertUtils hideLoadingInView:self.view];
    
    
    //[self.listAssistView setShowType:ELAST_HIDE showLabel:nil];
    
    // 没有数据了
    //[self.listAssistView setShowType:ELAST_EMPTY showLabel:MultiLanguage(mctvcMsgTips)];
    
    //[self.listAssistView setShowType:ELAST_RETRY showLabel:nil];
    //[self.listAssistView setRetryWithTarget:self action:@selector(initData)];
    
}

-(void)initData{
    
}


//tableview刷新 每一个模块获取数据后调用此方法来刷新tableview
-(void)refrashTableView{
    if (self.arrayData.count==0) {
        return;
    }
    self.tableViewDataSource.gridData = [NSMutableArray arrayWithArray:@[self.arrayData]];
}

-(void)itemSelected:(id)itemData{
    NSLog(@"%@",[itemData valueForKey:@"NAME"]);

    switch ([[self.itemData valueForKey:@"TYPE"] intValue]) {
        case 1:
        {
            [self pushViewControllerWithName:@"TLStrategyDetailViewController" itemData:itemData block:^(id obj) {
                
            }];
            break;
        }
        case 2:
        {
            [self pushViewControllerWithName:@"TLWayBookDetailViewController" itemData:itemData block:^(id obj) {
                
            }];
            break;
        }
        case 3:
        {

            break;
        }
        case 4:
        {
            break;
        }
        case 5:
        {
         
            break;
        }
        case 6:
        {
           
            break;
        }
        case 7:
        {
           
            break;
        }
            
        case 8:
        {
           
            break;
        }
        default:
            break;
    }
    
    
}

@end
