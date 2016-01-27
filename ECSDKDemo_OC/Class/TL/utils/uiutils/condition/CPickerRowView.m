//
//  CPickerRowView.m
//  TL
//
//  Created by Rainbow on 3/31/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "CPickerRowView.h"
#import "RIconTextBtn.h"

@interface CPickerRowView(){
    RIconTextBtn *btn;
}

@end

@implementation CPickerRowView

- (instancetype)initWithFrame:(CGRect)frame itemData:(id)itemData
{
    self = [super initWithFrame:frame];
    if (self) {
        self.itemData = itemData;
    }
    return self;
}

-(void)addViews{
    //addcheckbox
    CGFloat hGap = 10.f;
    CGFloat vGap = 5.f;
    btn = [[RIconTextBtn alloc] initWithFrame:CGRectMake(hGap, vGap, CGRectGetWidth(self.frame)-hGap*2, CGRectHeight(self.frame)-vGap*2)];
    [btn setImage:[UIImage imageNamed:@"tl_choice2"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"tl_choice1"] forState:UIControlStateSelected];
    [btn setTitle:[self.itemData valueForKey:@"name"] forState:UIControlStateNormal];
    [btn setTitleColor:COLOR_MAIN_TEXT forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(topBtnHandler:) forControlEvents:UIControlEventTouchUpInside];
    btn.selected = NO;
    self.isSelected = NO;
    [self addSubview:btn];
    //addlabel
}

-(void)topBtnHandler:(RIconTextBtn*)button{
    if (button.selected) {
        button.selected = NO;
        
    }else{
        button.selected = YES;
    }
    self.isSelected = button.selected;
}

@end
