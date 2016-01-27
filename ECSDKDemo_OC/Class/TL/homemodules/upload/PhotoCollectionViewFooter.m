//
//  PhotoCollectionViewFooter.m
//  alijk
//
//  Created by zhangyang on 14-9-16.
//  Copyright (c) 2014年 zhongxin. All rights reserved.
//

#import "PhotoCollectionViewFooter.h"

@interface PhotoCollectionViewFooter ()
{
    UILabel* _label;
}
@end

@implementation PhotoCollectionViewFooter

- (id)initWithFrame:(CGRect)frame maxImageCount:(NSInteger)maxImageCount
{
    self = [super initWithFrame:frame];
    if (self) {
        self.maxImageCount = maxImageCount;
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _label.font = FONT_12;
        _label.textColor = COLOR_ASSI_TEXT;
        _label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_label];
        
        _label.backgroundColor = [UIColor clearColor];
        _label.text  = [NSString stringWithFormat:@"已添加0张，还可以添加%ld张",self.maxImageCount];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.maxImageCount = 5;
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _label.font = FONT_12;
        _label.textColor = COLOR_ASSI_TEXT;
        _label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_label];
        
        _label.backgroundColor = [UIColor clearColor];
        _label.text  = [NSString stringWithFormat:@"已添加0张，还可以添加%ld张",self.maxImageCount];
    }
    return self;
}


-(void)setCurrentCount:(NSInteger)currentCount{
    
    _currentCount = currentCount;
    
    self.leftCount = self.maxImageCount-currentCount;
    _label.text = [NSString stringWithFormat:@"已添加%d张，还可以添加%d张",self.currentCount,self.leftCount];
    
}

@end
