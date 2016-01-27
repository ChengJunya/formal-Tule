//
//  TLModuleListViewController.h
//  TL
//
//  Created by Rainbow on 2/8/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "SuperViewController.h"
#import "ZXListViewAssist.h"


@interface TLModuleListViewController : SuperViewController

@property (nonatomic,assign) int currentPage;//当前页码
@property (nonatomic,strong) NSString *cityId;
@property (nonatomic,strong) NSString *orderByTime;
@property (nonatomic,strong) NSString *orderByViewCount;
@property (nonatomic,strong) NSString *type;

@property (nonatomic,strong) NSString *dataType;//1-全部 2-我的收藏 3-我的发布 4-他人发布 5-本地保存（后台无需处理）
@property (nonatomic,strong) NSString *loginId;

@property (nonatomic,strong) NSString *refrashTime;

@property (nonatomic,strong) NSString *sortId;//排序编码

@property (nonatomic,strong) NSArray *arrayData;//存放数据
@property (nonatomic,strong) NSString *isHiddenModelSelecter;//IS_SHOW_MENU   是否显示切换模块的菜单按钮 1-不显示
@property (nonatomic,strong) NSString *isHiddenAddBtn;//IS_SHOW_ADD  是否显示添加按钮

@property (nonatomic,strong) ZXListViewAssist *listAssistView;

-(void)itemSelected:(id)itemData;
-(void)addCreateActionBtnHandler;
-(void)addModuleSelecter;
-(void)refrashTableView;
-(void)initData;
-(void)refreshData;
-(void)endFooterRefrash;
-(void)endHeaderRefrash;

-(void)addSortView;//添加自己的排序
@end
