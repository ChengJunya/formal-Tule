//
//  TLKeyValueItemView.m
//  TL
//
//  Created by Rainbow on 2/19/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "TLKeyValueItemView.h"

@implementation TLKeyValueItemView

- (instancetype)initWithFrame:(CGRect)frame itemData:(NSArray *)itemData
{
    self = [super initWithFrame:frame];
    if (self) {
        self.itemData = itemData;
        [self setupView];
    }
    return self;
}

-(void)setupView{
    [self.itemData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CGFloat itemWidth = CGRectGetWidth(self.frame)/self.itemData.count;
        CGFloat itemHeight = CGRectGetHeight(self.frame)/2;
        
        CGRect keyFrame = CGRectMake(itemWidth*idx, 0.f, itemWidth, itemHeight);
        CGRect valueFrame = CGRectMake(itemWidth*idx, itemHeight, itemWidth, itemHeight);
        CALayer *keyBg = [CALayer layer];
        keyBg.frame = keyFrame;
        keyBg.borderColor = UIColorFromRGBA(0xCCCCCC, 0.5).CGColor;
        keyBg.borderWidth = 0.5f;
        [self.layer addSublayer:keyBg];
        
        
        CALayer *valueBg = [CALayer layer];
        valueBg.frame = valueFrame;
        valueBg.borderColor = UIColorFromRGBA(0xCCCCCC, 0.5).CGColor;
        valueBg.borderWidth = 0.5f;
        [self.layer addSublayer:valueBg];
        
        NSString *keyStr = [obj valueForKey:@"KEY"];
        NSString *valueStr = [obj valueForKey:@"VALUE"];
        
        UILabel *keyLabel = [[UILabel alloc] initWithFrame:keyFrame];
        keyLabel.text = keyStr;
        keyLabel.font = FONT_14;
        keyLabel.textColor = COLOR_MAIN_TEXT;
        keyLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:keyLabel];
        
        UILabel *valueLabel = [[UILabel alloc] initWithFrame:valueFrame];
        valueLabel.text = valueStr;
        valueLabel.font = FONT_14;
        valueLabel.textColor = COLOR_MAIN_TEXT;
        valueLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:valueLabel];
        
        
    }];
}
@end
