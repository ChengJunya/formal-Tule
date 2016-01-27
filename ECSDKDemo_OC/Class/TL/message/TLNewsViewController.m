//
//  TLNewsViewController.m
//  TL
//
//  Created by Rainbow on 5/11/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "TLNewsViewController.h"

#import "ZXTableViewDataSource.h"
#import "TLModuleDataHelper.h"
#import "TLNewsDataDTO.h"
#import "TLNewsCell.h"
#import "ZXListViewAssist.h"
#import "MJRefresh.h"
#import "RUtiles.h"
#import "TLHelper.h"
#import "TLNewsDetailViewController.h"
#import "TLHomeImageDTO.h"
@interface TLNewsViewController (){
    CGFloat _yOffSet;
    CGFloat _tableViewHeight;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) ZXTableViewDataSource *dataSource;
@property (nonatomic,strong) NSMutableArray *tableArray;
@property(nonatomic,assign) int currentPage;
@property(nonatomic,strong) NSString *refrashTime;
@property (nonatomic,strong) TLHomeImageDTO *dto;


@end

@implementation TLNewsViewController

- (void)viewDidLoad {
    _yOffSet = NAVIGATIONBAR_HEIGHT + STATUSBAR_HEIGHT;
    _tableViewHeight = self.view.height - _yOffSet;
    [super viewDidLoad];
    self.dto = self.itemData;
    self.title = @"资讯";
    
    
    [self addAllUIResources];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navBarHidden = NO;
    self.navBackItemHidden = NO;

    [self initData];
}


-(void)addAllUIResources{
    [self addSettingTableView];
}

#pragma mark -
#pragma mark - 添加视图



/*
 *添加tableview
 */
-(void)addSettingTableView{
    
    WEAK_SELF(self);
    NSMutableArray *dataList = [[NSMutableArray alloc] init];
    NSArray *sectionList = @[];
    NSDictionary *itemData = @{
                               @"GRID_DATA": @[dataList],
                               @"SECTION_DATA":sectionList
                               };
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.f, _yOffSet, CGRectWidth(self.view.frame),_tableViewHeight)];
    
    self.tableView.backgroundColor = COLOR_DEF_BG;
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    self.dataSource = [[ZXTableViewDataSource alloc] initWithTableView:self.tableView itemData:itemData];
    self.dataSource.canEditRow = NO;
    self.dataSource.CellBlock = ^UITableViewCell *(id cellData,id sectionData,UITableView *tableView){
        
        return [weakSelf createCell:cellData sectinData:sectionData tableView:tableView];
        
    };
    
    self.dataSource.CellHeightBlock = ^CGFloat(){
        return [TLNewsCell cellHeight];
    };
    
    
    
    //选择列表行
    self.dataSource.ItemSelectedBlock = ^(id itemData){
        [weakSelf rowSelected:itemData];
    };
    //创建sections
    self.dataSource.HeaderBlock = ^UIView*(NSDictionary *sectionData,UITableView *tableView){
        return [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, tableView.width, 0.01f)];
    };
    
    
    [self.tableView addHeaderWithTarget:self action:@selector(initData)];
    [self.tableView addFooterWithTarget:self action:@selector(refreshData)];
    
}

#pragma mark -
#pragma mark - 视图辅助方法
/*
 * 创建有效药品Cell
 */
-(UITableViewCell *)createCell:(id)cellData sectinData:(id)sectionData tableView:(UITableView *)tableView{
    
    TLNewsDataDTO *dto = cellData;
    static NSString *identifier = @"NEWS_CELL";
    TLNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[TLNewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setCellDto:dto];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

/*
 * 创建失效药品列表Section表头
 */
-(UIView*)createHeaderView:(CGFloat)width sectionData:(id)sectionData{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectZero];
    return headerView;
}

/*
 * 刷新数据
 */
-(void)refrashUI{
    
    NSMutableArray *sectionDataArray = [[NSMutableArray alloc] init];
    NSMutableArray *gridDataArray = [[NSMutableArray alloc] init];
    [sectionDataArray addObject:@{@"CELL_TYPE":@"NEWS_CELL",@"SECTION_TYPE":@"1"}];
    [gridDataArray addObject:self.tableArray];
    
    self.dataSource.sections = sectionDataArray;
    
    self.dataSource.gridData = gridDataArray;
    [self.tableView reloadData];
    
}




#pragma mark -
#pragma mark - 事件
-(void)rowSelected:(id)itemData{
    TLNewsDataDTO *newsData = itemData;
    [RTLHelper pushViewControllerWithName:@"TLNewsDetailViewController" itemData:newsData block:^(TLNewsDetailViewController* obj) {
        obj.newsUrl = newsData.url;
    }];
}

#pragma mark -
#pragma mark - 获取数据
-(void)initData{
    WEAK_SELF(self);
    
    self.refrashTime = [RUtiles stringFromDateWithFormat:[NSDate new] format:@"yyyyMMddHHmmss"];
    self.currentPage = 1;


    TLNewsListRequestDTO *request = [[TLNewsListRequestDTO alloc] init];
    request.pageSize = [NSString stringWithFormat:@"%d",TABLE_PAGE_SIZE];
    request.currentPage = [NSString stringWithFormat:@"%d",self.currentPage];
    request.currentTime = self.refrashTime;
    request.searchText = @"";
    request.type = self.dto.type;
    
    [GHUDAlertUtils toggleLoadingInView:self.view];
    [GTLModuleDataHelper listNews:request requestArr:self.requestArray block:^(id obj, BOOL ret) {
        [GHUDAlertUtils hideLoadingInView:self.view];
        [self.tableView headerEndRefreshing];
        if (ret) {
            weakSelf.tableArray = [NSMutableArray arrayWithArray: obj];
            [weakSelf refrashUI];
        }else{
            ResponseDTO *response = obj;
            [GHUDAlertUtils toggleMessage:response.resultDesc];
        }
    }];
    
}

-(void)refreshData{
    WEAK_SELF(self);
    self.currentPage = self.currentPage + 1;
    TLNewsListRequestDTO *request = [[TLNewsListRequestDTO alloc] init];
    request.pageSize = [NSString stringWithFormat:@"%d",TABLE_PAGE_SIZE];
    request.currentPage = [NSString stringWithFormat:@"%d",self.currentPage];
    request.currentTime = self.refrashTime;
    request.searchText = @"";
    
    [GHUDAlertUtils toggleLoadingInView:self.view];
    [GTLModuleDataHelper listNews:request requestArr:self.requestArray block:^(id obj, BOOL ret) {
        [GHUDAlertUtils hideLoadingInView:self.view];
        [self.tableView footerEndRefreshing];
        if (ret) {
            NSArray *array = obj;
            if (array.count>0) {
                [weakSelf.tableArray addObjectsFromArray:obj];
                [weakSelf refrashUI];
            }

        }else{
            ResponseDTO *response = obj;
            [GHUDAlertUtils toggleMessage:response.resultDesc];
        }
    }];
    
}






@end
