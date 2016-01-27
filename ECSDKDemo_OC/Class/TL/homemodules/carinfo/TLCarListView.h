//
//  TLCarListView.h
//  TL
//
//  Created by Rainbow on 2/18/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXListViewAssist.h"
@interface TLCarListView : UIView
@property (nonatomic,strong ) id itemData;
@property (nonatomic,strong ) id menuItemData;
@property (nonatomic,assign) NSUInteger type;//1-carinfo 2-comment 3-rent 4-service
@property (nonatomic,copy) void (^ListItemSelected)(id itemData);
- (instancetype)initWithFrame:(CGRect)frame itemData:(id)itemData menuItemData:(id)menuItemData;

@property (nonatomic,strong) NSArray *arrayData;//存放数据
@property (nonatomic,strong) ZXListViewAssist *listAssistView;
@property (nonatomic,assign) int currentPage;

@property (nonatomic,strong) NSString *cityId;
@property (nonatomic,strong) NSString *orderByTime;
@property (nonatomic,strong) NSString *orderByViewCount;

@property (nonatomic,strong) NSMutableArray *requestArray;
@property (nonatomic,strong) NSString *refrashTime;

@property (nonatomic,strong) NSString *sortId;//排序字段

-(void)itemSelected:(id)itemData;
-(void)refrashTableView;
-(void)initData;
-(void)refreshData;
-(void)endFooterRefrash;
-(void)endHeaderRefrash;

-(void)addSortView;
@end
