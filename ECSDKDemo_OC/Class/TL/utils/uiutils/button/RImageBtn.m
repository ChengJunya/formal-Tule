//
//  RImageBtn.m
//  HiddenTalk
//
//  Created by Rainbow on 8/12/13.
//  Copyright (c) 2013 MST. All rights reserved.
//

#import "RImageBtn.h"

@implementation RImageBtn
@synthesize titleLabel=_titleLabel,itemData=_itemData;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(id)initWithFrameImage:(CGRect)frame btnImage:(UIImage *)image btnTitle:(NSString *)title{
    self = [super initWithFrame:frame];
    if(self){
        
        //设置按钮北京图片
        UIImage *backImage = image;
        [self setBackgroundImage:backImage forState:UIControlStateNormal];
        
        
        
        //定义按钮文字字体
        UIFont *font = [UIFont systemFontOfSize:13.0f];
        //文字的字体大小
        //CGSize size = [title sizeWithFont:font];
        //创建按钮文字层
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, (frame.size.height-16)/2, frame.size.width-4, 16)];
        //设置按钮名称
        self.titleLabel.text = title;
        //设置按钮文字字体
        self.titleLabel.font = font;
        //设置文字布局
        [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
        //设置文字背景
        self.titleLabel.backgroundColor = [UIColor clearColor];
        //设置文字颜色
        self.titleLabel.textColor = [UIColor whiteColor];
        //添加按钮名称到按钮上
        [self addSubview:self.titleLabel];
        
        
        /* self.layer.shadowOffset= CGSizeMake(1, 1);
         self.layer.shadowRadius= 3.0;
         self.layer.shadowColor= [UIColor whiteColor].CGColor;
         self.layer.shadowOpacity= .8f;
         self.layer.borderColor= [UIColor blackColor].CGColor;
         self.layer.borderWidth= 2.0;
         self.layer.cornerRadius= 10.0;*/
        
        
    }
    return self;
}
-(id)initWithFrameImageTitle:(CGRect)frame btnImage:(NSString *)imageName btnTitle:(NSString *)title{
    self = [super initWithFrame:frame];
    if(self){
       
        //设置按钮北京图片
        UIImage *backImage = [[UIImage imageNamed:imageName] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0];
        [self setBackgroundImage:backImage forState:UIControlStateNormal];
        
  
        
        //定义按钮文字字体
        UIFont *font = [UIFont systemFontOfSize:13.0f];
        //文字的字体大小
        //CGSize size = [title sizeWithFont:font];
                //创建按钮文字层
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, (frame.size.height-16)/2, frame.size.width-4, 16)];
        //设置按钮名称
        self.titleLabel.text = title;
        //设置按钮文字字体
        self.titleLabel.font = font;
        //设置文字布局
        [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
        //设置文字背景
        self.titleLabel.backgroundColor = [UIColor clearColor];
        //设置文字颜色
        self.titleLabel.textColor = [UIColor whiteColor];
        //添加按钮名称到按钮上
        [self addSubview:self.titleLabel];
        
        
       /* self.layer.shadowOffset= CGSizeMake(1, 1);
        self.layer.shadowRadius= 3.0;
        self.layer.shadowColor= [UIColor whiteColor].CGColor;
        self.layer.shadowOpacity= .8f;
        self.layer.borderColor= [UIColor blackColor].CGColor;
        self.layer.borderWidth= 2.0;
        self.layer.cornerRadius= 10.0;*/

        
    }
    return self;
}

-(id)initWithFrameImageStateTitle:(CGRect)frame btnImage:(NSString *)imageName selectedImage:(NSString *)selectedImageName highLightedImage:(NSString *)highLightedImageName btnTitle:(NSString *)title{
    self = [super initWithFrame:frame];
    if(self){
        
        //设置按钮北京图片
        UIImage *backImage = [[UIImage imageNamed:imageName] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0];
        
        UIImage *selectedImage = [[UIImage imageNamed:selectedImageName] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0];
        
        //如果高亮的没有图片则默认不设置，会变暗
        if ([highLightedImageName isEqualToString:@""]) {
            
        }else{
            UIImage *highLightedImage = [[UIImage imageNamed:highLightedImageName] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0];
            [self setBackgroundImage:highLightedImage forState:UIControlStateHighlighted];
        }
        
        [self setBackgroundImage:backImage forState:UIControlStateNormal];
        [self setBackgroundImage:selectedImage forState:UIControlStateSelected];
        
        
        
        //定义按钮文字字体
        UIFont *font = [UIFont systemFontOfSize:13.0f];
        //文字的字体大小
        //CGSize size = [title sizeWithFont:font];
        //创建按钮文字层
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, (frame.size.height-16)/2, frame.size.width-4, 16)];
        //设置按钮名称
        titleLabel.text = title;
        //设置按钮文字字体
        titleLabel.font = font;
        //设置文字布局
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        //设置文字背景
        titleLabel.backgroundColor = [UIColor clearColor];
        //设置文字颜色
        titleLabel.textColor = [UIColor whiteColor];
        //添加按钮名称到按钮上
        [self addSubview:titleLabel];
        
        
        /* self.layer.shadowOffset= CGSizeMake(1, 1);
         self.layer.shadowRadius= 3.0;
         self.layer.shadowColor= [UIColor whiteColor].CGColor;
         self.layer.shadowOpacity= .8f;
         self.layer.borderColor= [UIColor blackColor].CGColor;
         self.layer.borderWidth= 2.0;
         self.layer.cornerRadius= 10.0;*/
        
        
    }
    return self;
}



-(id)initWithFrameImageStateTitle:(CGRect)frame btnImage:(NSString *)imageName selectedImage:(NSString *)selectedImageName highLightedImage:(NSString *)highLightedImageName btnTitle:(NSString *)title titleColor:(UIColor *)titleColor titleTextAlignment:(NSInteger)textAlign{
    self = [super initWithFrame:frame];
    if(self){
        
        //设置按钮北京图片
        UIImage *backImage = [[UIImage imageNamed:imageName] stretchableImageWithLeftCapWidth:10.0 topCapHeight:10.0];
        
        UIImage *selectedImage = [[UIImage imageNamed:selectedImageName] stretchableImageWithLeftCapWidth:10.0 topCapHeight:10.0];
        
        //如果高亮的没有图片则默认不设置，会变暗
        if ([highLightedImageName isEqualToString:@""]) {
            
        }else{
            UIImage *highLightedImage = [[UIImage imageNamed:highLightedImageName] stretchableImageWithLeftCapWidth:10.0 topCapHeight:10.0];
            [self setBackgroundImage:highLightedImage forState:UIControlStateHighlighted];
        }
        
        [self setBackgroundImage:backImage forState:UIControlStateNormal];
        [self setBackgroundImage:selectedImage forState:UIControlStateSelected];
        
        
        
        //定义按钮文字字体
        UIFont *font = [UIFont systemFontOfSize:13.0f];
        //文字的字体大小
        //CGSize size = [title sizeWithFont:font];
        //创建按钮文字层
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, (frame.size.height-16)/2, frame.size.width-4, 16)];
        //设置按钮名称
        titleLabel.text = title;
        //设置按钮文字字体
        titleLabel.font = font;
        //设置文字布局
        [titleLabel setTextAlignment:textAlign];
        //设置文字背景
        titleLabel.backgroundColor = [UIColor clearColor];
        //设置文字颜色
        titleLabel.textColor = titleColor;
        //添加按钮名称到按钮上
        [self addSubview:titleLabel];
        
        
        /* self.layer.shadowOffset= CGSizeMake(1, 1);
         self.layer.shadowRadius= 3.0;
         self.layer.shadowColor= [UIColor whiteColor].CGColor;
         self.layer.shadowOpacity= .8f;
         self.layer.borderColor= [UIColor blackColor].CGColor;
         self.layer.borderWidth= 2.0;
         self.layer.cornerRadius= 10.0;*/
        
        
    }
    return self;
}

-(void)changeTitleImage:(NSString*)title image:(NSString*)imageName{
    //设置按钮北京图片
    UIImage *backImage = [[UIImage imageNamed:imageName] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0];
    
        
    [self setBackgroundImage:backImage forState:UIControlStateNormal];
    [self setBackgroundImage:backImage forState:UIControlStateSelected];
    
    [self setTitle:title forState:UIControlStateNormal];

}


-(id)initWithFrameImageATitle:(CGRect)frame btnImage:(NSString *)imageName btnTitle:(NSMutableAttributedString *)title{
    self = [super initWithFrame:frame];
    if(self){
        
        //设置按钮北京图片
        UIImage *backImage = [[UIImage imageNamed:imageName] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0];
        [self setBackgroundImage:backImage forState:UIControlStateNormal];
        
        
        
        //定义按钮文字字体
        UIFont *font = [UIFont systemFontOfSize:14.0f];
        //文字的字体大小
        //CGSize size = [title sizeWithFont:font];
        //创建按钮文字层
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, (frame.size.height-16)/2, frame.size.width-4, 16)];
        //设置按钮名称
        self.titleLabel.attributedText = title;
        //设置按钮文字字体
        self.titleLabel.font = font;
        //设置文字布局
        [self.titleLabel setTextAlignment:NSTextAlignmentLeft];
        //设置文字背景
        self.titleLabel.backgroundColor = [UIColor clearColor];
        //设置文字颜色
//        self.titleLabel.textColor = [UIColor whiteColor];
        //添加按钮名称到按钮上
        [self addSubview:self.titleLabel];
        
        
        /* self.layer.shadowOffset= CGSizeMake(1, 1);
         self.layer.shadowRadius= 3.0;
         self.layer.shadowColor= [UIColor whiteColor].CGColor;
         self.layer.shadowOpacity= .8f;
         self.layer.borderColor= [UIColor blackColor].CGColor;
         self.layer.borderWidth= 2.0;
         self.layer.cornerRadius= 10.0;*/
        
        
    }
    return self;
}


@end
