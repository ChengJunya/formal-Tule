//
//  RTextCell.m
//  TL
//
//  Created by Rainbow on 2/16/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "RTextCell.h"

@implementation RTextCell

-(void)initContent{
    
    
    
    if (self.cellContentView) {
        [self.cellContentView removeFromSuperview];
        self.cellContentView = nil;
    }
    
    self.cellContentView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:self.cellContentView];
    
    
  
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:FONT_14,NSFontAttributeName ,nil];
    NSString *title = [self.cellData valueForKey:@"TITLE"];
    CGSize titleSize = [title sizeWithAttributes:dic];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.f,(CGRectGetHeight(self.cellContentView.frame)-titleSize.height)/2, CGRectGetWidth(self.cellContentView.frame), titleSize.height)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = FONT_14;
    titleLabel.textColor = COLOR_MAIN_TEXT;
    titleLabel.text = title;
    [self.cellContentView addSubview:titleLabel];
    
    
    
    self.cellHeight = 40.f;
    
}

@end
