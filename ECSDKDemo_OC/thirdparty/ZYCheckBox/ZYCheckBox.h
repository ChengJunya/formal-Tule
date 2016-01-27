//
//  SegMMent.h
//  segment
//
//  Created by ZHY on 5/29/14.
//  Copyright (c) 2014 张 扬. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ZYCheckBoxDelegate;

@interface ZYCheckBox : UIView

typedef void (^ZYCheckBoxSelectBlock)(NSArray* selectedIndexs, ZYCheckBox *radioControl);

@property(nonatomic,assign) NSUInteger lastIndex;
@property(nonatomic,assign) NSUInteger currentIndex;
@property(nonatomic,strong)NSMutableArray* Items;
@property(nonatomic,strong)NSMutableArray* Buttons;

@property(nonatomic,assign)int selectedIndex;
@property(nonatomic,assign)id<ZYCheckBoxDelegate> delegate;
@property (nonatomic, strong) ZYCheckBoxSelectBlock block;
//@property(nonatomic,assign)BOOL isMultipleChoice;

@property(nonatomic,assign)BOOL isSpecial;//是不是特殊形式的checkbox，通常设为NO



-(id)initWithFrame:(CGRect)frame Interval:(CGFloat)interval titleItems:(NSArray *)titles UnSelectedImage:(UIImage *)unSelectImg SelectedImage:(UIImage *)selectedImg DefaulSelIndex:(int)defaulIndex;

-(void)setBtnsTitleColor:(UIColor*)color ForState:(UIControlState)state;
-(void)setbtnsBackGroundColor:(UIColor*)color ForState:(UIControlState)state;

-(void)setBtnAtIndex:(NSUInteger)index TitleColor:(UIColor*)color;
-(void)setBtnSelectedAtIndex:(NSUInteger)index;

-(void)setbtnsTitleFont:(UIFont*)theFont;

-(void)setSelectedBlock:(ZYCheckBoxSelectBlock)block;

@end


@protocol ZYCheckBoxDelegate <NSObject>

-(void)ZYCheckBox:(ZYCheckBox*)ZYCheckBox didSelectedAtIndex:(NSArray*)indexArr;

@end

/*demo－－－－
 ZYCheckBox* radio = [[ZYCheckBox alloc] initWithFrame:ZYCheckBoxFrame Interval:4 titleItems:@[@" 5公里",@" 10公里",@" 20公里",@"收藏药店"] UnSelectedImage:[UIImage imageNamed:@"ico_radio_notselect"] SelectedImage:[UIImage imageNamed:@"ico_radio_select"] DefaulSelIndex:0];
 [radio setBtnsTitleColor:[UIColor blackColor] ForState:(UIControlStateNormal)];
 [radio setBtnsTitleColor:[UIColor blackColor] ForState:(UIControlStateSelected)];
 [radio setSelectedBlock:^(NSInteger buttonIndex, ZYCheckBox *radioControl) {
 ZXLog(@"%d,%@",buttonIndex,radioControl.Buttons[0]);
 }];
 [view addSubview:radio];
 
 */





