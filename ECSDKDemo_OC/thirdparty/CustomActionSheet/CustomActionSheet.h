//
//  CustomActionSheet.h
//  alijk
//
//  Created by zhangyang on 14-8-21.
//  Copyright (c) 2014年 zhongxin. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomActionSheet : UIView
{
    NSMutableArray* _buttonArr;
    UIView* _bottomView;
    CGFloat _bottomHeight;
}

typedef void (^CustomActionSheetBlock)(CustomActionSheet* actionSheet ,NSUInteger index);

@property(nonatomic,copy)CustomActionSheetBlock block;


-(id)initWithButtonTitles:(NSArray*)btnArr;
-(void)setButtonBackGroundImage:(UIImage*)image forState:(UIControlState)state;
-(void)showActionSheetInView:(UIView*)superView;
-(void)actionSheetSelectBlock:(CustomActionSheetBlock)block;

@end
