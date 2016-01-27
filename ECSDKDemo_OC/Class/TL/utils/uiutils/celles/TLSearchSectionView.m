//
//  TLSearchSectionView.m
//  TL
//
//  Created by Rainbow on 2/20/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "TLSearchSectionView.h"

@implementation TLSearchSectionView

- (instancetype)initWithFrame:(CGRect)frame sectionData:(id)sectionData
{
    self = [super initWithFrame:frame];
    if (self) {
        self.sectionData = sectionData;
        [self setupView];
    }
    return self;
}

-(void)setupView{
    CGFloat sectionHeight = 40.f;
    self.backgroundColor = UIColorFromRGBA(0xCCCCCC, 0.5);
    NSString *sectionName = [self.sectionData valueForKey:@"TITLE"];
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.f, 5.f, CGRectGetWidth(self.frame), sectionHeight-10)];
    nameLabel.text = sectionName;
    nameLabel.textColor = COLOR_MAIN_TEXT;
    nameLabel.font = FONT_16;
    [self addSubview:nameLabel];
    
    self.sectionHeight = sectionHeight;
}

@end
