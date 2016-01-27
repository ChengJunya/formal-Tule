//
//  SegMMent.h
//  segment
//
//  Created by ZHY on 5/29/14.
//  Copyright (c) 2014 张 扬. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ZYRadioControlDelegate;

@interface ZYRadioControl : UIView

typedef void (^ZYRadioSelectBlock)(NSInteger buttonIndex, ZYRadioControl *radioControl);

@property(nonatomic,assign) NSUInteger lastIndex;
@property(nonatomic,assign) NSUInteger currentIndex;
@property(nonatomic,strong)NSMutableArray* Items;
@property(nonatomic,strong)NSMutableArray* Buttons;

@property(nonatomic,assign)NSUInteger disableIndex;//设置返回错误的button；

@property(nonatomic,assign)NSUInteger selectedIndex;
@property(nonatomic,assign)id<ZYRadioControlDelegate> delegate;
@property (nonatomic, strong) ZYRadioSelectBlock block;



-(id)initWithFrame:(CGRect)frame Interval:(CGFloat)interval titleItems:(NSArray *)titles UnSelectedImage:(UIImage *)unSelectImg SelectedImage:(UIImage *)selectedImg DefaulSelIndex:(NSUInteger)defaulIndex;

-(void)setBtnsTitleColor:(UIColor*)color ForState:(UIControlState)state;
-(void)setbtnsBackGroundColor:(UIColor*)color ForState:(UIControlState)state;

-(void)setBtnAtIndex:(NSUInteger)index TitleColor:(UIColor*)color;
-(void)setBtnSelectedAtIndex:(NSUInteger)index;

-(void)setbtnsTitleFont:(UIFont*)theFont;

-(void)setSelectedBlock:(ZYRadioSelectBlock)block;
-(void)setButtonTitle:(NSString*)text AtIndex:(NSInteger)index;

-(void)setButtonEnable:(BOOL)able AtIndex:(NSInteger)index;

@end


@protocol ZYRadioControlDelegate <NSObject>

-(void)ZYRadioControl:(ZYRadioControl*)ZYRadioControl didSelectedAtIndex:(NSUInteger)index;

@end

/*demo－－－－
 ZYRadioControl* radio = [[ZYRadioControl alloc] initWithFrame:ZYRadioControlFrame Interval:4 titleItems:@[@" 5公里",@" 10公里",@" 20公里",@"收藏药店"] UnSelectedImage:[UIImage imageNamed:@"ico_radio_notselect"] SelectedImage:[UIImage imageNamed:@"ico_radio_select"] DefaulSelIndex:0];
 [radio setBtnsTitleColor:[UIColor blackColor] ForState:(UIControlStateNormal)];
 [radio setBtnsTitleColor:[UIColor blackColor] ForState:(UIControlStateSelected)];
 [radio setSelectedBlock:^(NSInteger buttonIndex, ZYRadioControl *radioControl) {
 ZXLog(@"%d,%@",buttonIndex,radioControl.Buttons[0]);
 }];
 [view addSubview:radio];
 
 */





