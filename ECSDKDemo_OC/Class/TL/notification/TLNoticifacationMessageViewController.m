//
//  TLNoticifacationMessageViewController.m
//  TL
//
//  Created by Rainbow on 2/7/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "TLNoticifacationMessageViewController.h"
#import "BoncDataGridDataSource.h"
#import "MJRefresh.h"
#import "ZXListViewAssist.h"
#import "RUtiles.h"
#import "TLModuleDataHelper.h"

@interface TLNoticifacationMessageViewController ()
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong) BoncDataGridDataSource *tableViewDataSource;
@property (nonatomic,strong) ZXListViewAssist *listAssistView;
@property (nonatomic,assign) CGFloat yOffSet;
@property (nonatomic,assign) NSUInteger pageNumber;//当前页数
@property (nonatomic,strong) NSMutableArray *tableDataArray;

@property (nonatomic,assign) int currentPage;
@property (nonatomic,strong) NSString *refrashTime;
@end

@implementation TLNoticifacationMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _yOffSet = NAVIGATIONBAR_HEIGHT+STATUSBAR_HEIGHT;
    self.title = @"系统消息";
    [self addAllUIResources];
}

-(void)addAllUIResources{
    [self addMessageList];

}




-(void)addMessageList{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, _yOffSet, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-NAVIGATIONBAR_HEIGHT-STATUSBAR_HEIGHT)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    NSDictionary *itemData = @{
                               @"type": @"REPORT",
                               @"gridType": @"MESSAGE_LIST_GRID",
                               @"gridId": @"MESSAGE_LIST_GRID",
                               @"GRID_DATA": @[],
                               @"SECTION_DATA":@[],
                               @"isShowHeader": @"0",
                               @"headerData": @{}
                               };
    self.tableViewDataSource = [[BoncDataGridDataSource alloc] initWithTableView:self.tableView itemData:itemData];
    
    __weak TLNoticifacationMessageViewController *weakController = self;
    self.tableViewDataSource.ItemSelectedBlock = ^(id itemData){
        [weakController itemSelected:itemData];
    };
    
    [self.tableView addHeaderWithTarget:self action:@selector(initData)];
    [self.tableView addFooterWithTarget:self action:@selector(refreshData)];
    
    _yOffSet = _yOffSet+CGRectGetHeight(self.tableView.frame);
    [self.view addSubview:self.tableView];
    
    self.listAssistView = [[ZXListViewAssist alloc] initWithAttachView:_tableView];
    [_tableView addSubview:self.listAssistView];
    [self.listAssistView setShowType:ELAST_HIDE showLabel:nil];
}



-(void)initData{
    
    self.currentPage = 1;
    self.refrashTime = [RUtiles stringFromDateWithFormat:[NSDate new] format:@"yyyyMMddHHmmss"];
    
    TLSysMessageListRequestDTO *request = [[TLSysMessageListRequestDTO alloc] init];
    
    request.currentPage = [NSString stringWithFormat:@"%d",self.currentPage];
    request.pageSize = [NSString stringWithFormat:@"%d",TABLE_PAGE_SIZE];
    request.currentTime = self.refrashTime;
    request.type = @"1";//all
        [GHUDAlertUtils toggleLoadingInView:self.view];
    WEAK_SELF(self);
    [GTLModuleDataHelper sysMessageList:request requestArr:self.requestArray block:^(id obj, BOOL ret) {
        
        
                [GHUDAlertUtils hideLoadingInView:self.view];


        [self.tableView headerEndRefreshing];
        if (ret) {
            self.tableDataArray = [NSMutableArray arrayWithArray:obj];
            [self.listAssistView setShowType:ELAST_HIDE showLabel:nil];
                [weakSelf refrashUI];
            
        }else{
            [self.listAssistView setShowType:ELAST_RETRY showLabel:MultiLanguage(mctvcMsgTips)];
            [self.listAssistView setRetryWithTarget:self action:@selector(initData)];
        }

    }];
    
    
}

-(void)refreshData{
    TLSysMessageListRequestDTO *request = [[TLSysMessageListRequestDTO alloc] init];
    
    request.currentPage = [NSString stringWithFormat:@"%d",self.currentPage+1];
    request.pageSize = [NSString stringWithFormat:@"%d",TABLE_PAGE_SIZE];
    request.currentTime = self.refrashTime;
    request.type = @"1";//all
    WEAK_SELF(self);
    [GHUDAlertUtils toggleLoadingInView:self.view];
    
        [GTLModuleDataHelper sysMessageList:request requestArr:self.requestArray block:^(id obj, BOOL ret) {
        
        [GHUDAlertUtils hideLoadingInView:self.view];
        [self.tableView footerEndRefreshing];
        
        if (ret) {
            [self.tableDataArray addObjectsFromArray:obj];
            [self.listAssistView setShowType:ELAST_HIDE showLabel:nil];
            [weakSelf refrashUI];

        }else{
            [self.listAssistView setShowType:ELAST_RETRY showLabel:MultiLanguage(mctvcMsgTips)];
            [self.listAssistView setRetryWithTarget:self action:@selector(initData)];
        }

    }];
}




-(void)refrashUI{
    NSArray *array = @[@{@"SECTION_TYPE":@"1",@"CELL_TYPE": @"MESSAGE_LIST_GRID"}];
    
    
    

    NSMutableArray *gridData = [NSMutableArray array];
    [gridData addObject:self.tableDataArray];
    self.tableViewDataSource.sections = array;
    self.tableViewDataSource.gridData = gridData;
    [self.tableView reloadData];
    
}





-(void)itemSelected:(NSDictionary *)itemData{
//    NSLog(@"%@",[itemData valueForKey:@"NAME"]);
//    
//    switch ([[itemData valueForKey:@"TYPE"] intValue]) {
//        case 1:
//        {
//            
//            break;
//        }
//        case 2:{
////            [GHUDAlertUtils showZXColorAlert:[itemData valueForKey:@"TITLE"] subTitle:[itemData valueForKey:@"MESSAGE"] cancleButton:MultiLanguage(comCancel) sureButtonTitle:MultiLanguage(setvcAlertBtnSure) COLORButtonType:0 buttonHeight:40 clickedBlock:^(ZXColorAlert *alert, NSUInteger index) {
////                if (index == 1) {
////                    //[GAppversionHelper openAppStoreURL];
////                }
////            }];
//            
//            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CHECK_VERSION object:@{@"isShowNotice":@"1"}];
//            break;
//        }
//        case 3:{
//            break;
//        }
//            
//        default:
//            break;
//    }

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navBarHidden = NO;
    self.navBackItemHidden = NO;
    [self initData];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
