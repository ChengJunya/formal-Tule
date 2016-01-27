//
//  SegMMent.m
//  segment
//
//  Created by ZHY on 5/29/14.
//  Copyright (c) 2014 张 扬. All rights reserved.
//

#import "ZYRadioControl.h"



@implementation ZYRadioControl

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
        
        CGFloat width;// = frame.size.width/titles.count - interval;
        CGFloat buttonY = 0;
        for (int i=0; i<titles.count; i++) {
            NSString* theTitle = [titles objectAtIndex:i];
            UIButton* button = [UIButton buttonWithType:(UIButtonTypeCustom)];
            [button addTarget:self action:@selector(btnAction:) forControlEvents:(UIControlEventTouchUpInside)];
            button.titleLabel.font = [UIFont systemFontOfSize:13];
            [button setTitle:theTitle forState:(UIControlStateNormal)];
            [button setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
            [button setImage:[UIImage imageNamed:@"RadioButton-Unselected"] forState:(UIControlStateNormal)];
            [button setImage:[UIImage imageNamed:@"RadioButton-Selected"] forState:(UIControlStateSelected)];
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            
            //计算title 的宽度
            
            CGSize actSize = [theTitle boundingRectWithSize:CGSizeMake(2000, 15) options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: button.titleLabel.font} context:nil].size;
            width = actSize.width+unSelectImg.size.width;
            if (width + interval > DEVICE_WIDTH/2) {
                CGFloat btnHeight = frame.size.height/titles.count -16;
                UIImageView *alineView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"separateLine"]];
                [alineView setFrame:CGRectMake(-12,(btnHeight+16)*i, DEVICE_WIDTH,1)];
                [self addSubview:alineView];
                button.frame = CGRectMake(0, CGRectGetMaxY(alineView.frame) + 8, width+interval, frame.size.height/titles.count -16);
            }
            else{
                button.frame = CGRectMake(buttonY, 0, width+interval, frame.size.height);
                buttonY += width+interval;
            }
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
    
    return self;
}

//选择以后对事件
-(void)btnAction:(UIButton*)sender
{
    NSUInteger i = [self.Buttons indexOfObject:sender];
    self.selectedIndex = i;
}

-(void)actionAtIndex:(NSUInteger)index{
    
    if (self.disableIndex == index) {
        if (self.block) {
            self.block(self.disableIndex,self);
        }
        return;
    }
    
    
    _lastIndex = _currentIndex;
    _currentIndex = index;
    UIButton* lastBtn = [self.Buttons objectAtIndex:_lastIndex];
    [lastBtn setSelected:NO];
    UIButton* currentBtn = [self.Buttons objectAtIndex:_currentIndex];
    [currentBtn setSelected:YES];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(ZYRadioControl:didSelectedAtIndex:)]) {
        [self.delegate ZYRadioControl:self didSelectedAtIndex:index];
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
    }
}

-(void)setSelectedBlock:(ZYRadioSelectBlock)block
{
    self.block = block;
}

-(void)setSelectedIndex:(NSUInteger)selectedIndex
{
    _selectedIndex = selectedIndex;
    [self actionAtIndex:selectedIndex];
}

-(void)setButtonTitle:(NSString*)text AtIndex:(NSInteger)index
{
    if (index >= self.Buttons.count) {
        return;
    }
    UIButton* btn = self.Buttons[index];
    [btn setTitle:text forState:(UIControlStateNormal)];
    [btn setTitle:text forState:(UIControlStateSelected)];
}

-(void)setButtonEnable:(BOOL)enable AtIndex:(NSInteger)index
{
    if (index >= self.Buttons.count) {
        return;
    }
    UIButton* btn = self.Buttons[index];
    btn.enabled = enable;
}



@end
