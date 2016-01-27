//
//  VerticalLayoutButton.h
//  alijk
//
//  Created by ZHY on 14-8-18.
//  Copyright (c) 2014年 zhongxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VerticalLayoutButton : UIControl
{
    UIImageView* _controlImage;
    UILabel* _controlTitle;
    NSMutableDictionary* _imageDic;
    NSMutableDictionary* _titleDic;
}

@property(nonatomic,assign)UIControlState theState;

-(id)initWithFrame:(CGRect)frame leftLine:(BOOL)haveLeft rightLine:(BOOL)haveRight;

-(void)setImage:(UIImage*)image forState:(UIControlState)state;//设置图片
-(void)setTitleFont:(UIFont*)font color:(UIColor*)color;//设置字体
-(void)setTitle:(NSString*)title forState:(UIControlState)state;//设置标题
@end
