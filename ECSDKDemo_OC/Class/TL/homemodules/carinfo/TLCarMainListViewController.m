//
//  TLCarMainListViewController.m
//  TL
//
//  Created by Rainbow on 2/17/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "TLCarMainListViewController.h"
#import "ZXListViewAssist.h"
#import "MJRefresh.h"
#import "TLDropMenu.h"
#import "TLCitySelectView.h"
#import "TLDropViewMenu.h"
#import "SBJsonParser.h"
#import "CTabMenu.h"
#import "TLCarListView.h"
#import "RTextIconBtn.h"
#import "TLCarInfoListView.h"
#import "TLCarCommentListView.h"
#import "TLCarRectListView.h"
#import "TLCarServiceListView.h"

#import "TLDetailCarServiceViewController.h"
#import "TLDetailCarRentViewController.h"
#import "TLDetailCarCommentViewController.h"
#import "TLDetailCarInfoViewController.h"

#import "TLNewServiceViewController.h"
#import "TLNewCarRentViewController.h"


#define CTABEMENU_HEIGHT 44.f
#define SORT_MENU_HEIGHT 40.f
@interface TLCarMainListViewController ()<UIScrollViewDelegate>
//@property (nonatomic,strong) TLDropMenu *menu;
//@property (nonatomic,strong) RTextIconBtn *itemBtn;
@property (nonatomic,assign) CGFloat yOffSet;
//@property (nonatomic,strong) TLDropViewMenu *sortMenuView;
@property (nonatomic,strong) CTabMenu *tabMenu;
@property (nonatomic,strong) UIScrollView *carListViewScrollView;;
@property (nonatomic,strong) NSArray *carMenuArray;
@property (nonatomic,assign) NSUInteger viewType;//1- 2- 3- 4-


@end

@implementation TLCarMainListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _yOffSet = NAVIGATIONBAR_HEIGHT+STATUSBAR_HEIGHT+40.f;
    //    if (self.itemData) {
    //        self.title = [self.itemData valueForKey:@"NAME"];
    //    }
    
    /*
     1,选择分类按钮
     2,tableview
     3,不同的cell
     4,地市选择
     5,排序选择
     6,新增发布
     
     */
    //[self addAllUIResources];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.navBarHidden = NO;
//    self.navBackItemHidden = NO;
//    
//    
//    
//    [self addTitleSelectItem];
//    
    self.navView.actionBtns = @[];
    
}

//- (void)addTitleSelectItem{
//    CGRect itemFrame = CGRectMake((self.view.width-100)/2, (NAVIGATIONBAR_HEIGHT-30)/2+STATUSBAR_HEIGHT, 100.f, 30.f);
//    //
//    _itemBtn = [[RTextIconBtn alloc] initWithFrame:itemFrame];
//    [_itemBtn setImage:[UIImage imageNamed:@"down"] forState:UIControlStateNormal];
//    [_itemBtn setImage:[UIImage imageNamed:@"up_arraw"] forState:UIControlStateSelected];
//    [_itemBtn addTarget:self action:@selector(btnHandler:) forControlEvents:UIControlEventTouchUpInside];
//    [_itemBtn setTitle:[self.itemData valueForKey:@"NAME"] forState:UIControlStateNormal];
//    [_itemBtn setTitleColor:COLOR_ORANGE_TEXT forState:UIControlStateNormal];
//    [_itemBtn setTitleColor:COLOR_MAIN_TEXT forState:UIControlStateSelected];
//    [self.navView addSubview:_itemBtn];
//
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addAllUIResources{
    //TYPE 1-新车资讯 2-车评 3-车辆租赁 4-车辆服务
    
    if ([@"1" isEqualToString:[self.itemData valueForKey:@"MODULE_TYPE"]]) {
        self.carMenuArray = @[@{@"ID":@"53",@"NAME":@"车辆租赁",@"TYPE":@"53"},@{@"ID":@"54",@"NAME":@"车辆服务",@"TYPE":@"54"}];
    }else{
    
    
    self.carMenuArray = @[@{@"ID":@"51",@"NAME":@"新车资讯",@"TYPE":@"51"},@{@"ID":@"52",@"NAME":@"车评",@"TYPE":@"52"},@{@"ID":@"53",@"NAME":@"车辆租赁",@"TYPE":@"53"},@{@"ID":@"54",@"NAME":@"车辆服务",@"TYPE":@"54"}];
    }
    
    [self addCarMenu];
    [self addCarListViews];
    [self addModuleSelecter];
}

-(void)addSortView{
    
}



//1-车讯 2-车评 3-车辆租赁 4-车辆服务
-(void)addSortViewWithIndex:(int)index{
    
}


- (UIButton*)addCreateActionBtn
{

    UIButton *actionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    actionBtn.frame = CGRectMake(0.f, 0.f, 44.f, 44.f);
    [actionBtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    [actionBtn addTarget:self action:@selector(addCreateActionBtnHandler) forControlEvents:UIControlEventTouchUpInside];
    return actionBtn;
}

-(void)addCreateActionBtnHandler{
    
    switch (self.viewType) {
        case 51:
        {
           
            break;
        }
        case 52:
        {
           
            break;
        }
        case 53:
        {
            //TLNewCarRentViewController
            [self pushViewControllerWithName:@"TLNewCarRentViewController" block:^(TLNewCarRentViewController* obj) {
                obj.operateType = @"1";
            }];
            break;
        }
        case 54:
        {
            //TLNewCarRentViewController
            [self pushViewControllerWithName:@"TLNewServiceViewController" block:^(TLNewServiceViewController* obj) {
                obj.operateType = @"1";
            }];
            break;
        }
        default:
            break;
    }
    
    
    
}
//-(void)btnHandler:(UIButton*)btn{
//    if (btn.selected) {
//        _menu.isMenuHidden = YES;
//        btn.selected = NO;
//    }else{
//        _menu.isMenuHidden = NO;
//        btn.selected = YES;
//    }
//}



//-----tabmenu---
-(void)addCarMenu{

    self.tabMenu = [[CTabMenu alloc] initWithFrame:CGRectMake(0.0f, CGRectGetHeight(self.view.frame)-CTABEMENU_HEIGHT, CGRectGetWidth(self.view.frame), CTABEMENU_HEIGHT)];
    
    __weak TLCarMainListViewController *weakController = self;
    self.tabMenu.MenuItemSelectedBlock = ^(id itemData){
        [weakController tabMenuItemSelected:itemData];
    };
    [self.view addSubview:self.tabMenu];
    [self.tabMenu setMenuData:self.carMenuArray];
    [self.tabMenu createMenu];
    self.viewType = 1;
}

-(void)tabMenuItemSelected:(id)itemData{
    NSLog(@"%@",[itemData valueForKey:@"NAME"]);
    NSUInteger tabIndex = self.tabMenu.selectedIndex;
    
    NSUInteger type = [[itemData valueForKey:@"TYPE"] integerValue];
    self.viewType = type;
    
    [self.carListViewScrollView setContentOffset:CGPointMake(tabIndex*CGRectGetWidth(self.carListViewScrollView.frame), 0) animated:YES];
    [self setupNewActionBtn];
    
    
    
}

-(void)setupNewActionBtn{
    if (self.isHiddenAddBtn.integerValue == 1) {
        return;
    }
    switch (self.viewType) {
        case 51:
        {
            self.navView.actionBtns = @[];
            break;
        }
        case 52:
        {
            self.navView.actionBtns = @[];
            break;
        }
        case 53:
        {
            self.navView.actionBtns = @[[self addCreateActionBtn]];
            break;
        }
        case 54:
        {
            self.navView.actionBtns = @[[self addCreateActionBtn]];
            break;
        }
        default:
            break;
    }

}

//----------------

//-------car list view -----
-(void)addCarListViews{
    self.carListViewScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.f, NAVIGATIONBAR_HEIGHT+STATUSBAR_HEIGHT, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-NAVIGATIONBAR_HEIGHT-STATUSBAR_HEIGHT-CTABEMENU_HEIGHT)];
    self.carListViewScrollView.pagingEnabled = YES;
    [self.view addSubview:self.carListViewScrollView];
    self.carListViewScrollView.delegate = self;
    
    [self.carMenuArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CGFloat x = CGRectGetWidth(self.carListViewScrollView.frame)*idx;
        CGFloat y = 0.f;
        CGFloat height = CGRectGetHeight(self.carListViewScrollView.frame);
        CGFloat width = CGRectGetWidth(self.carListViewScrollView.frame);
        CGRect tlCarListViewFrame = CGRectMake(x, y, width, height);
        
        
        NSUInteger type = [[obj valueForKey:@"TYPE"] integerValue];


        
        
        TLCarListView *listView;// = [[TLCarListView alloc] initWithFrame:tlCarListViewFrame itemData:self.itemData menuItemData:obj];
        switch (type) {
            case 51:
            {
                
                listView = [[TLCarInfoListView alloc] initWithFrame:tlCarListViewFrame itemData:self.itemData menuItemData:obj];
                
                break;
            }
            case 52:
            {
                listView = [[TLCarCommentListView alloc] initWithFrame:tlCarListViewFrame itemData:self.itemData menuItemData:obj];
                
                break;
            }
            case 53:
            {
                listView = [[TLCarRectListView alloc] initWithFrame:tlCarListViewFrame itemData:self.itemData menuItemData:obj];
                self.navView.actionBtns = @[[self addCreateActionBtn]];
                break;
            }
            case 54:
            {
                listView = [[TLCarServiceListView alloc] initWithFrame:tlCarListViewFrame itemData:self.itemData menuItemData:obj];
                self.navView.actionBtns = @[[self addCreateActionBtn]];
                break;
            }
            default:
                listView = [[TLCarInfoListView alloc] initWithFrame:tlCarListViewFrame itemData:self.itemData menuItemData:obj];
                break;
        }
        
        
        
        listView.type = type;
        listView.cityId = self.cityId;
        listView.orderByViewCount = self.orderByViewCount;
        listView.orderByTime = self.orderByTime;
        listView.itemData = self.itemData;
        listView.menuItemData = obj;

        __weak TLCarMainListViewController *weakController = self;
        listView.ListItemSelected = ^(id itemData){
            [weakController listItemSelected:itemData type:type];
        };
        [self.carListViewScrollView addSubview:listView];
        self.carListViewScrollView.contentSize = CGSizeMake(width*self.carMenuArray.count, height);
    }];
}



#pragma mark - UIScrollView delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
   int tabIndex = scrollView.contentOffset.x/CGRectGetWidth(self.carListViewScrollView.frame);
    [self.tabMenu selectButtonByIndex:tabIndex];
    
}

-(void)listItemSelected:(id)itemData type:(NSUInteger)type{
    switch (type) {
        case 51:
        {
            [self pushViewControllerWithName:@"TLDetailCarInfoViewController" itemData:itemData block:^(TLDetailCarInfoViewController* obj) {
                obj.dataType = [self.itemData valueForKey:@"DATATYPE"];
                
            }];
            break;
        }
        case 52:
        {
            [self pushViewControllerWithName:@"TLDetailCarCommentViewController" itemData:itemData block:^(TLDetailCarCommentViewController* obj) {
                obj.dataType = [self.itemData valueForKey:@"DATATYPE"];
            }];
            break;
        }
        case 53:
        {
            [self pushViewControllerWithName:@"TLDetailCarRentViewController" itemData:itemData block:^(TLDetailCarRentViewController* obj) {
                obj.dataType = [self.itemData valueForKey:@"DATATYPE"];
            }];
            break;
        }
        case 54:
        {
            [self pushViewControllerWithName:@"TLDetailCarServiceViewController" itemData:itemData block:^(TLDetailCarServiceViewController* obj) {
                obj.dataType = [self.itemData valueForKey:@"DATATYPE"];
            }];
            break;
        }
        default:
            break;
    }
}

@end
