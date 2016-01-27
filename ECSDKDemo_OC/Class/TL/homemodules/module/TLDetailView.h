//
//  TLDetailView.h
//  TL
//
//  Created by Rainbow on 2/10/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWPhotoBrowser.h"
#define TLDETAILVIEW_IMAGE_BANNER_HEIGHT 200.f
#define TLDETAILVIEW_INFO_HEIGHT 200.f
#define TLDETAILVIEW_H_GAP 10.f
#define TLDETAILVIEW_V_GAP 10.f
#define TLDETAILVIEW_USER_IMAGE_HEIGHT 60.f

@interface TLDetailView : UIView
@property (nonatomic,strong) id viewData;
@property (nonatomic,copy) void (^MoreImageBlock)();
@property (nonatomic,copy) void (^CommentItemBlock)();
@property (nonatomic,copy) void (^DeleteBlock)();
@property (nonatomic,strong) UIScrollView *viewContentScroll;
/*
 1:攻略
 2:路书
 3:游记
 4:活动
 5:二手
 7:车辆租赁
 8:车辆服务
 9:商城
 */
@property (nonatomic,strong) NSString *type;//

@property (nonatomic,assign) CGFloat yOffSet;
- (instancetype)initWithFrame:(CGRect)frame viewData:(id)viewData type:(NSString*)type;

-(void)setUpViews;
-(void)validateYOffSet;

-(void)addImageView;
-(void)addUserIcon;
-(void)addTitle;
-(void)addOperButtons;
-(void)addPublishDate;
-(void)addCity;
-(void)addInfoView;
-(void)addTextContent;

-(void)toTop;
-(void)toUpdate;
-(void)toDelete;
@end
