//
//  TLOrgListViewController.m
//  TL
//
//  Created by Rainbow on 5/3/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "TLOrgListViewController.h"
#import "ZXTableViewDataSource.h"
#import "TLOrgListTableViewCell.h"
#import "TLOrgDataDTO.h"
#import "TLModuleDataHelper.h"
#import "TLListOrgRequestDTO.H"
#import "MJNIndexView.h"
#import "TLSearchSectionView.h"
#import "TLGroupListTableViewCell.h"
@interface TLOrgListViewController ()<MJNIndexViewDataSource>{
    CGFloat _yOffSet;
    CGFloat _tableViewHeight;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) ZXTableViewDataSource *dataSource;
@property (nonatomic,strong) NSMutableArray *tableArray;
@property (nonatomic,strong) NSMutableArray *indexViewArray;
@property (nonatomic, strong) MJNIndexView *indexView;
@property (nonatomic, assign) BOOL getSelectedItemsAfterPanGestureIsFinished;

@end

@implementation TLOrgListViewController

- (void)viewDidLoad {
    _yOffSet = NAVIGATIONBAR_HEIGHT + STATUSBAR_HEIGHT;
    _tableViewHeight = self.view.height - _yOffSet;
    [super viewDidLoad];
    self.type = [self.itemData valueForKey:@"TYPE"];
    if (self.type.integerValue==1) {
        self.title = @"组织";
    }else if (self.type.integerValue==2) {
        self.title = @"群组";
    }
    
    
    [self addAllUIResources];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navBarHidden = NO;
    self.navBackItemHidden = NO;
    if (self.type.integerValue==2) {
        self.navView.actionBtns = @[[self addPublishActionBtn]];
    }
    
    [self getUIData];
}


-(void)addAllUIResources{
    [self addSettingTableView];
    [self setupIndexView];
}

#pragma mark -
#pragma mark - 添加视图


- (UIButton*)addPublishActionBtn
{
    
    //    UIImage *backImage = [UIImage imageNamed:@"ico_backon"];
    UIButton *actionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    actionBtn.frame = CGRectMake(0.f, 0.f, 44.f, 44.f);
    [actionBtn setTitleColor:COLOR_NAV_TEXT forState:UIControlStateNormal];
    [actionBtn setTitleColor:COLOR_BTN_BOX_GRAY_TEXT forState:UIControlStateHighlighted];
    [actionBtn setTitle:@"+创建" forState:UIControlStateNormal];
    actionBtn.titleLabel.font = FONT_14B;
    //[actionBtn setImage:[UIImage imageNamed:@"more_xiaoxi"] forState:UIControlStateNormal];
    //    [actionBtn setImage:[UIImage imageNamed:@"ico_backon" ] forState:UIControlStateHighlighted];
    [actionBtn addTarget:self action:@selector(publishBtnHandler) forControlEvents:UIControlEventTouchUpInside];
    return actionBtn;
}

-(void)publishBtnHandler{
    
    
    NSLog(@"创建群组");
    [self pushViewControllerWithName:@"TLAddGroupViewController" block:^(id obj) {
        
    }];
//    CreateGroupViewController * cgvc = [[CreateGroupViewController alloc]init];
//    [self.navigationController pushViewController:cgvc animated:YES];
//    cgvc.dict = [DemoGlobalClass sharedInstance].loginInfoDic;
//    
    
    //    if (self.menuView == nil) {
    //
    //        self.menuView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self.menuView action:@selector(removeFromSuperview)];
    //        [self.menuView addGestureRecognizer:tap];
    //
    //        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(160, 64.0f, 150, 120)];
    //        view.tag =50;
    //        view.backgroundColor = [UIColor blackColor];
    //        [self.menuView addSubview:view];
    //        UIButton * converseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //        converseBtn.frame =CGRectMake(0, 0, 150, 40);
    //        [converseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //        [converseBtn setTitle:@"发起会话/群聊" forState:UIControlStateNormal];
    //        [converseBtn addTarget:self action:@selector(converseBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    //        [view addSubview:converseBtn];
    //        UIButton * createmoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //        createmoreBtn.frame =CGRectMake(0, 40, 150, 40);
    //        [createmoreBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //        [createmoreBtn setTitle:@"创建群组" forState:UIControlStateNormal];
    //        [createmoreBtn addTarget:self action:@selector(createmoreBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    //        [view addSubview:createmoreBtn];
    //        UIButton * setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //        setBtn.frame =CGRectMake(0, 80, 150, 40);
    //        [setBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //        [setBtn setTitle:@"设置" forState:UIControlStateNormal];
    //        [setBtn addTarget:self action:@selector(setBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    //        [view addSubview:setBtn];
    //    }
    //
    //    if (self.menuView.superview == nil) {
    //        [self.view.window addSubview:self.menuView];
    //    }
    
}

-(void)setupIndexView{
    // initialise MJNIndexView
    if (self.indexView!=nil) {
        [self.indexView removeFromSuperview];
    }
    self.indexView = [[MJNIndexView alloc]initWithFrame:CGRectMake(0.f, _yOffSet, self.view.width, _tableViewHeight)];
    self.indexView.dataSource = self;
    self.indexView.selectedItemFontColor = COLOR_MAIN_TEXT;
    self.indexView.fontColor = COLOR_ASSI_TEXT;
    [self firstAttributesForMJNIndexView];
    
    [self.view addSubview:self.indexView];
}

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
        return [TLOrgListTableViewCell cellHeight];
    };
    
    
    
    //选择列表行
    self.dataSource.ItemSelectedBlock = ^(id itemData){
        [weakSelf rowSelected:itemData];
    };
    //创建sections
    self.dataSource.HeaderBlock = ^UIView*(NSDictionary *sectionData,UITableView *tableView){
        if ([sectionData[@"GROUP"] integerValue]==1) {
            return [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, tableView.width, 0.01f)];
        }else{
            return [weakSelf createHeaderView:tableView.width sectionData:sectionData];
        }
        
    };
    
    
}

#pragma mark -
#pragma mark - 视图辅助方法
/*
 * 创建有效药品Cell
 */
-(UITableViewCell *)createCell:(id)cellData sectinData:(id)sectionData tableView:(UITableView *)tableView{
    
    if (self.type.integerValue==1) {
        TLOrgDataDTO *dto = cellData;
        static NSString *identifier = @"ORG_CELL";
        TLOrgListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[TLOrgListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        [cell setCellDto:dto];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        return cell;
    }else if (self.type.integerValue==2) {

        TLGroupDataDTO *dto = cellData;
        static NSString *identifier = @"GROUP_CELL";
        TLGroupListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[TLGroupListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        [cell setCellDto:dto];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        return cell;
    }else{
        
        TLOrgDataDTO *dto = cellData;
        static NSString *identifier = @"ORG_CELL";
        TLOrgListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[TLOrgListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        [cell setCellDto:dto];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        return cell;
    }
   
}

/*
 * 创建失效药品列表Section表头
 */
-(UIView*)createHeaderView:(CGFloat)width sectionData:(id)sectionData{
    TLSearchSectionView *headerView = [[TLSearchSectionView alloc] initWithFrame:CGRectMake(0.f, 0.f, CGRectGetWidth(self.tableView.frame), 30.f) sectionData:sectionData];
    
    return headerView;
}

/*
 * 刷新数据
 */
-(void)refrashUI{
    
    NSMutableArray *sectionDataArray = [[NSMutableArray alloc] init];
    NSMutableArray *gridDataArray = [[NSMutableArray alloc] init];
    self.indexViewArray = [[NSMutableArray alloc] init];
    
    NSArray *azSectionArray = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"];
    
    [azSectionArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *section = @{@"SECTION_TYPE":@"1",@"CELL_TYPE": TL_CONTACT_CELL,@"TITLE":obj};
        
        
        NSMutableArray *gridArray = [[NSMutableArray alloc] init];
        for (int i=0; i<self.tableArray.count; i++) {
            TLOrgDataDTO *dto = self.tableArray[i];
            NSString *shortIndex = dto.shortIndex;
            if ([obj isEqualToString:shortIndex]) {
                [gridArray addObject:dto];
            }
        }
        if (gridArray.count>0) {
            [gridDataArray addObject:gridArray];
            [sectionDataArray addObject:section];
            [self.indexViewArray addObject:obj];
        }
        
    }];
    
    

    
    
    self.dataSource.sections = sectionDataArray;
    NSMutableArray *dataArray = gridDataArray;
    
    self.dataSource.gridData = dataArray;
    [self.tableView reloadData];
    
    [self setupIndexView];
}



- (void)firstAttributesForMJNIndexView
{
    self.indexView.getSelectedItemsAfterPanGestureIsFinished = YES;
    self.indexView.font = [UIFont fontWithName:@"HelveticaNeue" size:13.0];
    self.indexView.selectedItemFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:40.0];
    self.indexView.backgroundColor = [UIColor clearColor];
    self.indexView.curtainColor = nil;
    self.indexView.curtainFade = 0.0;
    self.indexView.curtainStays = NO;
    self.indexView.curtainMoves = YES;
    self.indexView.curtainMargins = NO;
    self.indexView.ergonomicHeight = NO;
    self.indexView.upperMargin = 22.0;
    self.indexView.lowerMargin = 22.0;
    self.indexView.rightMargin = 10.0;
    self.indexView.itemsAligment = NSTextAlignmentCenter;
    self.indexView.maxItemDeflection = 100.0;
    self.indexView.rangeOfDeflection = 5;
    self.indexView.darkening = NO;
    self.indexView.fading = YES;
}


#pragma mark MJMIndexForTableView datasource methods
- (NSArray *)sectionIndexTitlesForMJNIndexView:(MJNIndexView *)indexView
{
    return self.indexViewArray;
}

- (void)sectionForSectionMJNIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:index] atScrollPosition: UITableViewScrollPositionTop animated:self.getSelectedItemsAfterPanGestureIsFinished];
}

#pragma mark -
#pragma mark - 事件
-(void)rowSelected:(id)itemData{
    if (self.type.integerValue==1) {
        [self pushViewControllerWithName:@"TLOrgInfoViewController" itemData:itemData block:^(id obj) {
            
        }];
    }else if(self.type.integerValue==2){
        [self pushViewControllerWithName:@"TLGroupDetailViewController" itemData:itemData block:^(id obj) {
            
        }];
        
    }

}

#pragma mark -
#pragma mark - 获取数据
-(void)getUIData{
    WEAK_SELF(self);
    switch (self.type.integerValue) {
        case 1:
        {
            
            TLListOrgRequestDTO *request = [[TLListOrgRequestDTO alloc] init];
            request.type = @"1";
            //request.pageSize = @"500";
            //request.currentPage = @"1";
            
            
            
            [GTLModuleDataHelper listOrganization:request requestArr:self.requestArray block:^(id obj, BOOL ret) {
                if (ret) {
                    weakSelf.tableArray = obj;
                    [weakSelf refrashUI];
                }else{
                    ResponseDTO *response = obj;
                    [GHUDAlertUtils toggleMessage:response.resultDesc];
                }
            }];
            break;
        }
        case 2:
        {
            
            TLListGroupRequestDTO *request = [[TLListGroupRequestDTO alloc] init];
            request.type = @"1";//我加入的群
            //request.pageSize = @"500";
            //request.currentPage = @"1";
            
            
            
            [GTLModuleDataHelper listGroup:request requestArr:self.requestArray block:^(id obj, BOOL ret) {
                
                if (ret) {
                    weakSelf.tableArray = obj;
                    [weakSelf refrashUI];
                }else{
                    ResponseDTO *response = obj;
                    [GHUDAlertUtils toggleMessage:response.resultDesc];
                }
            }];
            break;
        }
        default:
            break;
    }
    
    
}






@end
