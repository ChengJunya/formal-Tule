//
//  SegMMent.h
//  segment
//
//  Created by ZHY on 5/29/14.
//  Copyright (c) 2014 张 扬. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ZYRadioControl_VDelegate;

@interface ZYRadioControl_V : UIView

typedef void (^ZYRadioSelectBlock)(NSInteger buttonIndex, ZYRadioControl_V *radioControl);

@property(nonatomic,assign) NSUInteger lastIndex;
@property(nonatomic,assign) NSUInteger currentIndex;
@property(nonatomic,strong)NSMutableArray* Items;
@property(nonatomic,strong)NSMutableArray* Buttons;
@property(nonatomic,assign)NSUInteger disableIndex;//设置返回错误的button；


@property(nonatomic,assign)int selectedIndex;
@property(nonatomic,assign)id<ZYRadioControl_VDelegate> delegate;
@property (nonatomic, strong) ZYRadioSelectBlock block;



-(id)initWithFrame:(CGRect)frame Interval:(CGFloat)interval titleItems:(NSArray *)titles UnSelectedImage:(UIImage *)unSelectImg SelectedImage:(UIImage *)selectedImg DefaulSelIndex:(NSUInteger)defaulIndex;

-(void)setBtnsTitleColor:(UIColor*)color ForState:(UIControlState)state;
-(void)setbtnsBackGroundColor:(UIColor*)color ForState:(UIControlState)state;

-(void)setBtnAtIndex:(NSUInteger)index TitleColor:(UIColor*)color;
-(void)setBtnSelectedAtIndex:(NSUInteger)index;

-(void)setbtnsTitleFont:(UIFont*)theFont;

-(void)setSelectedBlock:(ZYRadioSelectBlock)block;

@end


@protocol ZYRadioControl_VDelegate <NSObject>

-(void)ZYRadioControl_V:(ZYRadioControl_V*)zyRadioControl_V didSelectedAtIndex:(NSUInteger)index;

@end

/*demo－－－－
 ZYRadioControl_V* radio = [[ZYRadioControl_V alloc] initWithFrame:ZYRadioControl_VFrame Interval:4 titleItems:@[@" 5公里",@" 10公里",@" 20公里",@"收藏药店"] UnSelectedImage:[UIImage imageNamed:@"ico_radio_notselect"] SelectedImage:[UIImage imageNamed:@"ico_radio_select"] DefaulSelIndex:0];
 [radio setBtnsTitleColor:[UIColor blackColor] ForState:(UIControlStateNormal)];
 [radio setBtnsTitleColor:[UIColor blackColor] ForState:(UIControlStateSelected)];
 [radio setSelectedBlock:^(NSInteger buttonIndex, ZYRadioControl_V *radioControl) {
 ZXLog(@"%d,%@",buttonIndex,radioControl.Buttons[0]);
 }];
 [view addSubview:radio];
 
 */





