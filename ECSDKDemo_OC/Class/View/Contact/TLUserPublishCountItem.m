//
//  TLUserPublishCountItem.m
//  TL
//
//  Created by Rainbow on 3/1/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "TLUserPublishCountItem.h"
#import "RUILabel.h"

@implementation TLUserPublishCountItem

- (instancetype)initWithFrame:(CGRect)frame itemData:(id)itemData
{
    self = [super initWithFrame:frame];
    if (self) {
        self.itemData = itemData;
        CGFloat vGap = 10.f;
        RUILabel *countLabel = [[RUILabel alloc] initWithFrame:CGRectZero str:[self.itemData valueForKey:@"count"] font:FONT_16B color:COLOR_MAIN_TEXT];
        countLabel.textAlignment = NSTextAlignmentCenter;
        countLabel.frame = CGRectMake(0.f, vGap, CGRectGetWidth(self.frame), CGRectGetHeight(countLabel.frame));
        [self addSubview:countLabel];
        
        
        RUILabel *nameLabel = [[RUILabel alloc] initWithFrame:CGRectZero str:[self.itemData valueForKey:@"name"] font:FONT_14 color:COLOR_MAIN_TEXT];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.frame = CGRectMake(0.f, vGap+CGRectGetMaxY(countLabel.frame), CGRectGetWidth(self.frame), CGRectGetHeight(nameLabel.frame));
        [self addSubview:nameLabel];
    }
    return self;
}

@end
