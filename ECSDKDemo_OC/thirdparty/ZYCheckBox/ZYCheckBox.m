//
//  SegMMent.m
//  segment
//
//  Created by ZHY on 5/29/14.
//  Copyright (c) 2014 张 扬. All rights reserved.
//

#import "ZYCheckBox.h"



@implementation ZYCheckBox

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(id)initWithFrame:(CGRect)frame Interval:(CGFloat)interval titleItems:(NSArray *)titles UnSelectedImage:(UIImage *)unSelectImg SelectedImage:(UIImage *)selectedImg DefaulSelIndex:(int)defaulIndex{
    self.Buttons = [NSMutableArray array];
    self.lastIndex = 0;
    self.isSpecial = NO;
    self.currentIndex = defaulIndex;
    if (self = [super initWithFrame:frame]) {
        
        CGFloat width = frame.size.width/titles.count - interval;
        
        
        for (int i=0; i<titles.count; i++) {
            UIButton* button = [UIButton buttonWithType:(UIButtonTypeCustom)];
            button.frame = CGRectMake(interval +(width+interval)*i, 0, width, frame.size.height);
            [button addTarget:self action:@selector(btnAction:) forControlEvents:(UIControlEventTouchUpInside)];
            button.titleLabel.font = [UIFont systemFontOfSize:13];
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [button setTitle:[titles objectAtIndex:i] forState:(UIControlStateNormal)];
            [button setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
            
            if (unSelectImg) {
                [button setImage:unSelectImg forState:(UIControlStateNormal)];
            }
            if (selectedImg) {
                [button setImage:selectedImg forState:(UIControlStateSelected)];
            }
//            if (i == defaulIndex) {
//                button.selected = YES;
//            }

            [self addSubview:button];
            [self.Buttons addObject:button];
            
        }
    }
    
    return self;
}

//选择以后对事件
-(void)btnAction:(UIButton*)sender
{
//    NSUInteger j = [self.Buttons indexOfObject:sender];
//    _lastIndex = _currentIndex;
//    _currentIndex = i;
//    self.selectedIndex = _currentIndex;
//    UIButton* lastBtn = [self.Buttons objectAtIndex:_lastIndex];
//    [lastBtn setSelected:NO];
//    [sender setSelected:YES];

    NSMutableArray* seletedArray = [NSMutableArray array];
    
    BOOL sel = sender.selected ;
    sender.selected = !sel;
    
    self.isSpecial = YES;
    
    //判断是不是特殊形式
    if (self.isSpecial) {
        UIButton* btn1 = self.Buttons[1];
        UIButton* btn2 = self.Buttons[2];
        
        if (btn1 == sender) {
            if (!btn1.selected) {
                btn2.selected = NO;
            }
        }
        if (btn2 == sender) {
            if (btn2.selected) {
                btn1.selected = YES;
            }
        }
    }
    
    
    for (int i=0;i<self.Buttons.count;i++) {
        UIButton* btn = self.Buttons[i];
        [seletedArray addObject:[NSNumber numberWithBool:btn.selected]];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(ZYCheckBox:didSelectedAtIndex:)]) {
        [self.delegate ZYCheckBox:self didSelectedAtIndex:seletedArray];
    }
    
    if (self.block) {
        self.block(seletedArray,self);
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

-(void)setbtnsTitleFont:(UIFont*)theFont{
    for (UIButton* btn in self.Buttons) {
        btn.titleLabel.font = theFont;
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

-(void)setSelectedBlock:(ZYCheckBoxSelectBlock)block
{
    self.block = block;
}

@end
