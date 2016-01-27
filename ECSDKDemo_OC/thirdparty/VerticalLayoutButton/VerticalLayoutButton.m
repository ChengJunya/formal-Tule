//
//  VerticalLayoutButton.m
//  alijk
//
//  Created by ZHY on 14-8-18.
//  Copyright (c) 2014年 zhongxin. All rights reserved.
//

#import "VerticalLayoutButton.h"

@implementation VerticalLayoutButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame leftLine:(BOOL)haveLeft rightLine:(BOOL)haveRight{
    
    if (self = [super initWithFrame:frame]) {
        _imageDic = [[NSMutableDictionary alloc] init];
        _titleDic = [[NSMutableDictionary alloc] init];
        
        _controlImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height/2)];
        _controlImage.contentMode = UIViewContentModeCenter;
        [self addSubview:_controlImage];
        
        _controlTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height/2, frame.size.width, frame.size.height/2)];
        _controlTitle.backgroundColor = [UIColor clearColor];
        _controlTitle.numberOfLines = 0;
        _controlTitle.textAlignment = NSTextAlignmentCenter;
        
        
        if (haveLeft) {
            UIImageView* line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2, 1, frame.size.height-4)];
            line.image = [UIImage imageNamed:@"ico_paixu_line"];
            [self addSubview:line];
        }
        if (haveRight) {
            UIImageView* line = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width-1, 5, 1, frame.size.height-10)];
            line.image = [UIImage imageNamed:@"ico_paixu_line"];
            [self addSubview:line];
        }
        
        [self addSubview:_controlTitle];
    }
    
    return self;
}



-(void)setImage:(UIImage*)image forState:(UIControlState)state{
    
    _controlImage.image = image;
    [_imageDic setObject:image forKey:[NSString stringWithFormat:@"Image%d",state]];
}


-(void)setTitle:(NSString*)title forState:(UIControlState)state{
    _controlTitle.text = title;
    [_titleDic setObject:title forKey:[NSString stringWithFormat:@"Title%d",state]];
    
}
-(void)setTheState:(UIControlState)theState{
    
    _theState = theState;
    
    NSString* title = [_titleDic objectForKey:[NSString stringWithFormat:@"Title%d",_theState]];
    _controlTitle.text = title;
    
    UIImage* img = [_imageDic objectForKey:[NSString stringWithFormat:@"Image%d",_theState]];
    _controlImage.image = img;
}

-(void)setTitleFont:(UIFont*)font color:(UIColor*)color{
    _controlTitle.font = font;
    _controlTitle.textColor = color;
}


@end
