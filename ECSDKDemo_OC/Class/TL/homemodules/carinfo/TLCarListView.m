//
//  TLCarListView.m
//  TL
//
//  Created by Rainbow on 2/18/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "TLCarListView.h"
#import "BoncDataGridDataSource.h"
#import "SBJsonParser.h"
#import "ZXListViewAssist.h"
#import "MJRefresh.h"
#define SORT_MENU_HEIGHT 40.f
@interface TLCarListView()
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong) BoncDataGridDataSource *tableViewDataSource;
@end
@implementation TLCarListView


- (instancetype)initWithFrame:(CGRect)frame itemData:(id)itemData menuItemData:(id)menuItemData
{
    self = [super initWithFrame:frame];
    if (self) {
        _itemData = itemData;
        _menuItemData = menuItemData;
        self.requestArray = [NSMutableArray array];
        [self addMessageList];
        [self addSortView];
    }
    return self;
}

-(void)addSortView{
    
}

-(void)setItemData:(id)itemData{
    _itemData = itemData;
    [self initData];
}

-(void)addMessageList{
    //NSString *cellHeight = [NSString stringWithFormat:@"%f",80.f];
    
    /*
     攻略数据格式
     1-攻略 2-路书 3-游记 4-召集活动 5-车讯 6-二手平台 7-应急救援 8-商家
     */
    
    //信息 1-到期提醒 2-系统升级 3－推广
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, SORT_MENU_HEIGHT, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-SORT_MENU_HEIGHT)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    
    
    /**************test*/
    //TYPE 1-新车资讯 2-车评 3-车辆租赁 4-车辆服务
    //NSString *typeId = [self.itemData valueForKey:@"TYPE"];
    
//    NSString *filePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"carlist_%@.json",typeId]];
//    NSString *jsonStr = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
//    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    NSArray *dataList = @[];
    

    
    
    
    NSString *gridType = @"";
    switch ([[self.menuItemData valueForKey:@"TYPE"] intValue]) {
        case 51:
        {
            gridType = MODULE_CARINFO_INFO;
            break;
        }
        case 52:
        {
            gridType = MODULE_CARINFO_COMMENT;
            break;
        }
        case 53:
        {
            gridType = MODULE_CARINFO_HIRE;
            break;
        }
        case 54:
        {
            gridType = MODULE_CARINFO_SERVICE;
            break;
        }
        
        default:
            break;
    }
    
    
    NSDictionary *itemData = @{
                               @"type": @"REPORT",
                               @"gridType": gridType,
                               @"gridId": gridType,
                               @"GRID_DATA": @[dataList],
                               @"SECTION_DATA":@[@{@"SECTION_TYPE":@"1",@"CELL_TYPE": gridType}],
                               @"isShowHeader": @"0",
                               @"headerData": @{}
                               };
    
    self.tableViewDataSource = [[BoncDataGridDataSource alloc] initWithTableView:self.tableView itemData:itemData];
    
    __weak TLCarListView *weakController = self;
    self.tableViewDataSource.ItemSelectedBlock = ^(id itemData){
        [weakController itemSelected:itemData];
    };
    [self.tableView addHeaderWithTarget:self action:@selector(initData)];
    [self.tableView addFooterWithTarget:self action:@selector(refreshData)];
    
    [self addSubview:self.tableView];
    
    self.listAssistView = [[ZXListViewAssist alloc] initWithAttachView:_tableView];
    [_tableView addSubview:self.listAssistView];
    [self.listAssistView setShowType:ELAST_HIDE showLabel:nil];
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


-(void)itemSelected:(NSDictionary *)itemData{
    if (self.ListItemSelected) {
        self.ListItemSelected(itemData);
    }
    
}




@end
