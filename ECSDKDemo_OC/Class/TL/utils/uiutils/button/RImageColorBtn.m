//
//  RImageColorBtn.m
//  HiddenTalk
//
//  Created by Rainbow on 8/12/13.
//  Copyright (c) 2013 MST. All rights reserved.
//

#import "RImageColorBtn.h"

@implementation RImageColorBtn

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(id)initWithFrameImageColorTitle:(CGRect)frame btnImage:(NSString *)imageName btnColor:(UIColor *)btnColor titleColor:(UIColor *)titleColor btnTitle:(NSString *)title{
    self = [super initWithFrame:frame];
    if (self) {
        //buttonimage
        //buttontitle
        //buttoncolor
        
        //设置按钮北京图片
        UIImage *btnImage = [UIImage imageNamed:imageName];
        //图片大小 16*16 上边框距离2像素  高度：按钮高度必须2+16+2+2+16+2  宽度：x+16+x图片   2+x+2 文字
        UIImageView *btnImageView = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width-16)/2, (frame.size.height/2-16)/2+2, 16, 16)];
        btnImageView.image = btnImage;
        [self addSubview:btnImageView];
        

        
        
        
       
        
        //定义按钮文字字体
        UIFont *font = [UIFont systemFontOfSize:14.0f];
        //文字的字体大小
        //CGSize size = [title sizeWithFont:font];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, frame.size.height/2+2,frame.size.width-4,16)];
        //设置按钮名称
        titleLabel.text = title;
        //设置按钮文字字体
        titleLabel.font = font;
        //设置文字布局
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        //设置文字背景
        titleLabel.backgroundColor = [UIColor clearColor];
        //设置文字颜色
        titleLabel.textColor = titleColor;
        //添加按钮名称到按钮上
        [self addSubview:titleLabel];
        
        [self setBackgroundColor:btnColor];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
