//
//  TLMineListItem.m
//  TL
//
//  Created by Rainbow on 2/26/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "TLMineListItem.h"
#import "RUILabel.h"

@implementation TLMineListItem

- (instancetype)initWithFrame:(CGRect)frame itemData:(id)itemData
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGBA(0xFFFFFF, 0.5);
        CGFloat vGap = 5.f;
        self.imageSize = CGSizeMake(CGRectGetHeight(self.frame)-vGap*2, CGRectGetHeight(self.frame)-vGap*2);
        self.isShowAction = YES;
        self.itemData = itemData;
        [self setupView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame itemData:(id)itemData isShowAction:(BOOL)isShowAction
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGBA(0xFFFFFF, 0.5);
        self.isShowAction = isShowAction;
        self.itemData = itemData;
        CGFloat vGap = 5.f;
        
        self.imageSize = CGSizeMake(CGRectGetHeight(self.frame)-vGap*2, CGRectGetHeight(self.frame)-vGap*2);
        [self setupView];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame itemData:(id)itemData isShowAction:(BOOL)isShowAction imageSize:(CGSize)imageSize
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGBA(0xFFFFFF, 0.5);
        self.isShowAction = isShowAction;
        self.itemData = itemData;
        self.imageSize = imageSize;
        [self setupView];
    }
    return self;
}
-(void)setupView{
    
    NSString *name = [self.itemData valueForKey:@"NAME"];
    NSString *subName = [self.itemData valueForKey:@"SUB_NAME"];
    NSString *itemImageStr = [self.itemData valueForKey:@"IMAGE"];
    
    CGFloat hGap = 20.f;

    //CGFloat itemImageWidth = CGRectGetHeight(self.frame)-vGap*2;
    //image
    UIImageView *itemImageView = [[UIImageView alloc] initWithFrame:CGRectMake(hGap, (CGRectGetHeight(self.frame)-self.imageSize.height)/2, self.imageSize.width , self.imageSize.height)];
    itemImageView.image = [UIImage imageNamed:itemImageStr];
    [self addSubview:itemImageView];
    //text
    RUILabel *nameLabel = [[RUILabel alloc] initWithFrame:CGRectZero str:name font:FONT_16 color:COLOR_MAIN_TEXT];
    nameLabel.frame = CGRectMake(hGap*2+self.imageSize.width, (CGRectGetHeight(self.frame)-CGRectGetHeight(nameLabel.frame))/2, CGRectGetWidth(nameLabel.frame), CGRectGetHeight(nameLabel.frame));
    [self addSubview:nameLabel];
    
    if (subName.length>0) {
        RUILabel *subLabel = [[RUILabel alloc] initWithFrame:CGRectZero str:subName font:FONT_14 color:COLOR_ASSI_TEXT];
        subLabel.frame = CGRectMake(CGRectGetWidth(self.frame)-30-hGap-subLabel.width, (CGRectGetHeight(self.frame)-CGRectGetHeight(subLabel.frame))/2, CGRectGetWidth(subLabel.frame), CGRectGetHeight(subLabel.frame));
        [self addSubview:subLabel];

    }
    
    
    //goicon
    if (self.isShowAction) {
        CGFloat goIconWidth = 10.f;
        CGFloat goIconHeight = 30.f;
        UIImageView *goIconView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)-goIconWidth-hGap, (CGRectGetHeight(self.frame)-goIconHeight)/2, goIconWidth, goIconHeight)];
        goIconView.image = [UIImage imageNamed:@"tl_mine_into"];
        [self addSubview:goIconView];

    }
    
    CALayer *line = [CALayer layer];
    line.backgroundColor = UIColorFromRGBA(0xcccccc, 0.5).CGColor;
    line.frame = CGRectMake(0.f, CGRectGetHeight(self.frame)-1, CGRectGetWidth(self.frame), 1.f);
    [self.layer addSublayer:line];
}

@end

