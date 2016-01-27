//
//  RColorButton.m
//  ContractManager
//
//  Created by Rainbow on 12/27/14.
//  Copyright (c) 2014 BONC. All rights reserved.
//

#import "RColorButton.h"

@implementation RColorButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
-(instancetype)initWithFrameColor:(CGRect)frame normalColor:(UIColor *)normalColor selectedColor:(UIColor *)selectedColor{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBtnBackgroundColor:selectedColor normalColor:normalColor];
    }
    return self;
}


-(void)setBtnBackgroundColor:(UIColor*)selectedColor normalColor:(UIColor*)normalColor{
    if (self.selected) {
        self.layer.backgroundColor = selectedColor.CGColor;//  [UIColor colorWithRed:0.0/255.0 green:159.0/255.0 blue:248.0/255.0 alpha:1].CGColor;
        self.layer.borderWidth = 1.0f;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        
    }else{
        self.layer.backgroundColor = normalColor.CGColor;// [UIColor colorWithRed:0.0/255.0 green:159.0/255.0 blue:248.0/255.0 alpha:0.5].CGColor;
        self.layer.borderWidth = 1.0f;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
    }
}

@end
