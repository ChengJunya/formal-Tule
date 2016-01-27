//
//  SegMMent.h
//  segment
//
//  Created by ZHY on 5/29/14.
//  Copyright (c) 2014 张 扬. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ZYSegMentDelegate;

@interface ZYSegMent : UIView

typedef void (^ZYSegmentSelectBlock)(NSUInteger buttonIndex, ZYSegMent* segment);

@property(nonatomic,assign) NSUInteger lastIndex;
@property(nonatomic,assign) NSUInteger currentIndex;
@property(nonatomic,strong)NSMutableArray* Items;
@property(nonatomic,strong)NSMutableArray* Buttons;

@property(nonatomic,assign)int selectedIndex;
@property(nonatomic,assign)id<ZYSegMentDelegate> delegate;
@property(nonatomic,strong)ZYSegmentSelectBlock block;


-(id)initWithFrame:(CGRect)frame Interval:(CGFloat)interval titleItems:(NSArray *)titles LeftBackImage:(UIImage *)lImg MiddleBackImage:(UIImage *)mIMg Right:(UIImage *)rImg HLeftBackImage:(UIImage *)hlImg HMiddleBackImage:(UIImage *)hmIMg HRight:(UIImage *)hrImg;

-(void)setBtnsTitleColor:(UIColor*)color ForState:(UIControlState)state;
-(void)setbtnsBackGroundColor:(UIColor*)color ForState:(UIControlState)state;

-(void)setBtnAtIndex:(NSUInteger)index TitleColor:(UIColor*)color;
-(void)setBtnSelectedAtIndex:(NSUInteger)index;
-(void)setZYSegmentSelectBlock:(ZYSegmentSelectBlock) block;
-(void)setBtnImageNames:(NSArray*)imgNameArr;

@end


@protocol ZYSegMentDelegate <NSObject>

-(void)zysegment:(ZYSegMent*)zySegment didSelectedAtIndex:(NSUInteger)index;

@end

/*demo
 ZYSegMent* segmented = [[ZYSegMent alloc]
 initWithFrame:self.mTitle.frame
 Interval: 0.0f
 titleItems:[NSArray arrayWithObjects:@"课程",@"学习计划",@"小组讨论",@"作家", nil]
 LeftBackImage:[UIImage imageNamed:@"leftDefaultBtnInDiscoveryMenu.png"]
 MiddleBackImage:[UIImage imageNamed:@"midDefaultBtnInDiscoveryMenu.png"]
 Right:[UIImage imageNamed:@"rightDefaultBtnInDiscoveryMenu.png"]
 HLeftBackImage:[UIImage imageNamed:@"leftHighlightedBtnInDiscoveryMenu.png"]
 HMiddleBackImage:[UIImage imageNamed:@"midHighlightedBtnInDiscoveryMenu.png"]
 HRight:[UIImage imageNamed:@"rightHighlightedBtnInDiscoveryMenu.png"]];
 [segmented setBtnsTitleColor:[UIColor whiteColor] ForState:(UIControlStateNormal)];
 [segmented setBtnsTitleColor:[UIColor whiteColor] ForState:(UIControlStateSelected)];
 segmented.delegate = self;
 [segmented setBtnSelectedAtIndex:0];
 [self.mTitleView addSubview:segmented];
 */