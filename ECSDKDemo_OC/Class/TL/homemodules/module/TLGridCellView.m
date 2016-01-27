//
//  TLGridCellView.m
//  TL
//
//  Created by YONGFU on 5/31/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "TLGridCellView.h"

@implementation TLGridCellView

- (instancetype)initWithFrame:(CGRect)frame items:(NSArray *)items
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = COLOR_WHITE_BG;
        _cellDataArray = items;
        [self setupViews];
    }
    return self;
}

-(void)setupViews{
    
    [self.cellDataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        CGFloat itemWidth = CGRectGetWidth(self.frame)/self.cellDataArray.count;
        CGFloat itemHeight = CGRectGetHeight(self.frame);
        
        CGRect keyFrame = CGRectMake(itemWidth*idx, 0.f, itemWidth, itemHeight);
       
        CALayer *keyBg = [CALayer layer];
        keyBg.frame = keyFrame;
        keyBg.borderColor = UIColorFromRGBA(0xCCCCCC, 0.5).CGColor;
        keyBg.borderWidth = 0.5f;
        [self.layer addSublayer:keyBg];
        
        
       
        
        NSString *keyStr = [obj valueForKey:@"NAME"];

        
        UILabel *keyLabel = [[UILabel alloc] initWithFrame:keyFrame];
        keyLabel.text = keyStr;
        keyLabel.font = FONT_14;
        keyLabel.textColor = COLOR_MAIN_TEXT;
        keyLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:keyLabel];
        
        
    }];
}


@end
