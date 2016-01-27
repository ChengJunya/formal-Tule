//
//  SegMMent.m
//  segment
//
//  Created by ZHY on 5/29/14.
//  Copyright (c) 2014 张 扬. All rights reserved.
//

#import "ZYSegMent.h"



@implementation ZYSegMent

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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
/*
 
 interval : button之间的间距
 
 */
-(id)initWithFrame:(CGRect)frame Interval:(CGFloat)interval titleItems:(NSArray *)titles LeftBackImage:(UIImage *)lImg MiddleBackImage:(UIImage *)mIMg Right:(UIImage *)rImg HLeftBackImage:(UIImage *)hlImg HMiddleBackImage:(UIImage *)hmIMg HRight:(UIImage *)hrImg{
    self.Buttons = [NSMutableArray array];
    self.lastIndex = 0;
    self.currentIndex = 0;
    if (self = [super initWithFrame:frame]) {
        
        CGFloat width = frame.size.width/titles.count - interval;
        
        
        for (int i=0; i<titles.count; i++) {
            UIButton* button = [UIButton buttonWithType:(UIButtonTypeCustom)];
            button.frame = CGRectMake(interval +(width+interval)*i, 0, width, frame.size.height);
            [self.Buttons addObject:button];
            [button addTarget:self action:@selector(btnAction:) forControlEvents:(UIControlEventTouchUpInside)];
   
            //取消title方法
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            [button setTitle:[titles objectAtIndex:i] forState:(UIControlStateNormal)];
            [button setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
 
            if (i == 0) {
                [button setBackgroundImage:lImg forState:(UIControlStateNormal)];
                [button setBackgroundImage:hlImg forState:(UIControlStateSelected)];
            }else if(i == titles.count-1){
                [button setBackgroundImage:rImg forState:(UIControlStateNormal)];
                [button setBackgroundImage:hrImg forState:(UIControlStateSelected)];
            }else{
                [button setBackgroundImage:mIMg forState:(UIControlStateNormal)];
                [button setBackgroundImage:hmIMg forState:(UIControlStateSelected)];
            }
            
            [self addSubview:button];
            
        }
    }
    
    return self;
}


-(void)setZYSegmentSelectBlock:(ZYSegmentSelectBlock) block
{
    self.block = block;
}

-(void)btnAction:(UIButton*)sender
{
    NSUInteger i = [self.Buttons indexOfObject:sender];
    
    _lastIndex = _currentIndex;
    _currentIndex = i;
    self.selectedIndex = _currentIndex;
    UIButton* lastBtn = [self.Buttons objectAtIndex:_lastIndex];
    [lastBtn setSelected:NO];
    [sender setSelected:YES];

    
    if (self.delegate && [self.delegate respondsToSelector:@selector(zysegment:didSelectedAtIndex:)]) {
        [self.delegate zysegment:self didSelectedAtIndex:i];
    }
    if (self.block) {
        self.block(_currentIndex,self);
    }
}

-(void)setbtnsBackGroundColor:(UIColor*)color ForState:(UIControlState)state
{
    for (UIButton* btn in self.Buttons) {
        [btn setBackgroundColor:color];
    }
}

-(void)setBtnsTitleColor:(UIColor*)color ForState:(UIControlState)state
{
    for (UIButton* btn in self.Buttons) {
        [btn setTitleColor:color forState:state];
    }
}
-(void)setBtnAtIndex:(NSUInteger)index TitleColor:(UIColor*)color
{
    if (index < self.Buttons.count) {
        UIButton* btn = [self.Buttons objectAtIndex:index];
        [btn setTitleColor:color forState:(UIControlStateNormal)];
    }
}

-(void)setBtnSelectedAtIndex:(NSUInteger)index
{
    if (index < self.Buttons.count) {
        self.selectedIndex = index;
        UIButton* currentBtn = [self.Buttons objectAtIndex:index];
        [self btnAction:currentBtn];
    }
}

-(void)setBtnImageNames:(NSArray*)imgNameArr{
    
    if (imgNameArr.count != self.Buttons.count) {
        ZXLog(@"Segment 图片数量不正确！");
        return;
    }
    for (int i = 0; i< self.Buttons.count;i++) {
        UIButton* btn = self.Buttons[i];
        [btn setImage:[UIImage imageNamed:imgNameArr[i]] forState:(UIControlStateNormal)];
    }
}






@end
