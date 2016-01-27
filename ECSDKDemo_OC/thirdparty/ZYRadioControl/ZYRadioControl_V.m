//
//  SegMMent.m
//  segment
//
//  Created by ZHY on 5/29/14.
//  Copyright (c) 2014 张 扬. All rights reserved.
//

#import "ZYRadioControl_V.h"



@implementation ZYRadioControl_V

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(id)initWithFrame:(CGRect)frame Interval:(CGFloat)interval titleItems:(NSArray *)titles UnSelectedImage:(UIImage *)unSelectImg SelectedImage:(UIImage *)selectedImg DefaulSelIndex:(NSUInteger)defaulIndex{
    self.Buttons = [NSMutableArray array];
    self.lastIndex = 0;
    self.disableIndex = -1;
    self.currentIndex = defaulIndex;
    if (self = [super initWithFrame:frame]) {
        
        CGFloat height = frame.size.height/titles.count - interval;
        
        for (int i=0; i<titles.count; i++) {
            UIButton* button = [UIButton buttonWithType:(UIButtonTypeCustom)];
            button.frame = CGRectMake(UI_LAYOUT_MARGIN ,interval +(height+interval)*i, frame.size.width-UI_LAYOUT_MARGIN , height);
            [button addTarget:self action:@selector(btnAction:) forControlEvents:(UIControlEventTouchUpInside)];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            [button setTitle:[titles objectAtIndex:i] forState:(UIControlStateNormal)];
            [button setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
            [button setImage:[UIImage imageNamed:@"RadioButton-Unselected"] forState:(UIControlStateNormal)];
            [button setImage:[UIImage imageNamed:@"RadioButton-Selected"] forState:(UIControlStateSelected)];
            [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
            if (unSelectImg) {
                [button setImage:unSelectImg forState:(UIControlStateNormal)];
            }
            if (selectedImg) {
                [button setImage:selectedImg forState:(UIControlStateSelected)];
            }
            if (i == defaulIndex) {
                button.selected = YES;
            }

            [self addSubview:button];
            [self.Buttons addObject:button];
            
        }
    }
    
    self.clipsToBounds = YES;
    return self;
}

//选择以后对事件
-(void)btnAction:(UIButton*)sender
{
    NSUInteger i = [self.Buttons indexOfObject:sender];
    
    if (self.disableIndex == i) {
        if (self.block) {
            self.block(self.disableIndex,self);
        }
        return;
    }
    
    _lastIndex = _currentIndex;
    _currentIndex = i;
    self.selectedIndex = _currentIndex;
    UIButton* lastBtn = [self.Buttons objectAtIndex:_lastIndex];
    [lastBtn setSelected:NO];
    [sender setSelected:YES];


    if (self.delegate && [self.delegate respondsToSelector:@selector(ZYRadioControl_V:didSelectedAtIndex:)]) {
        [self.delegate ZYRadioControl_V:self didSelectedAtIndex:i];
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

-(void)setSelectedBlock:(ZYRadioSelectBlock)block
{
    self.block = block;
}

@end
