//
//  BoncDataGridHeaderView.h
//  TableViewGridTest
//
//  Created by Rainbow on 12/2/14.
//  Copyright (c) 2014 Rainbow. All rights reserved.
//
/**
 1,表格头部内容显示部分
 1，表头高度，列宽，分隔，边框，背景
 2，表格头部内容数据部分
 1，编码 ，名称，列宽
 
 */

#import <UIKit/UIKit.h>

#import "BoncDefine.h"
#import "RImageBtn.h"


@protocol BoncDataGridHeaderViewDelegate <NSObject>

-(void)isShowSelectColumnBtnSelected:(BOOL)isSelected;

@end

@interface BoncDataGridHeaderView : UIView
@property (nonatomic,weak)id<BoncDataGridHeaderViewDelegate> delegate;
///headerData:{header:[{CODE:'ID',NAME:'序列',WIDHT:'80'},{CODE:'KPINAME',NAME:'KPI名称',WIDHT:'80'},{CODE:'DESC',NAME:'KPI描述',WIDHT:'80'}],headerHeight:'40',headerSpliteColor:'#FF00FF',headerBorderColor:'#FFF000',headerBackgroundColor:'#FFFF00'}
@property (nonatomic,strong) NSDictionary *headerData;
@property (nonatomic,strong) RImageBtn *showBtn;
@end
