//
//  TLMineStoreListItem.m
//  TL
//
//  Created by Rainbow on 2/27/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "TLMineStoreListItem.h"
#import "RUILabel.h"

@interface TLMineStoreListItem(){
    RUILabel *nameLabel;
}

@end

@implementation TLMineStoreListItem

- (instancetype)initWithFrame:(CGRect)frame itemData:(id)itemData
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGBA(0xFFFFFF, 0.5);
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
        [self setupView];
    }
    return self;
}
-(void)setupView{
    
    NSString *name = [self.itemData valueForKey:@"NAME"];
    NSString *itemImageStr = [self.itemData valueForKey:@"IMAGE"];
    
    CGFloat hGap = 20.f;
    CGFloat vGap = 15.f;
    CGFloat itemImageWidth = CGRectGetHeight(self.frame)-vGap*2;
    //image
    UIImageView *itemImageView = [[UIImageView alloc] initWithFrame:CGRectMake(hGap, (CGRectGetHeight(self.frame)-itemImageWidth)/2, itemImageWidth*2, itemImageWidth)];
    itemImageView.image = [UIImage imageNamed:itemImageStr];
    [self addSubview:itemImageView];
    //text
    nameLabel = [[RUILabel alloc] initWithFrame:CGRectZero str:name font:FONT_16 color:COLOR_MAIN_TEXT];
    nameLabel.frame = CGRectMake(hGap*2+itemImageWidth*2, (CGRectGetHeight(self.frame)-CGRectGetHeight(nameLabel.frame))/2, CGRectGetWidth(nameLabel.frame), CGRectGetHeight(nameLabel.frame));
    [self addSubview:nameLabel];
    //goicon
    if (self.isShowAction) {
        CGFloat goIconWidth = 60.f;
        CGFloat goIconHeight = 30.f;
//        UIImageView *goIconView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)-goIconWidth-hGap, (CGRectGetHeight(self.frame)-goIconHeight)/2, goIconWidth, goIconHeight)];
//        goIconView.image = [UIImage imageNamed:@"tl_mine_into"];
//        [self addSubview:goIconView];
        
        UIButton *buyBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)-goIconWidth-hGap, (CGRectGetHeight(self.frame)-goIconHeight)/2, goIconWidth, goIconHeight)];
        [buyBtn setTitle:@"购买" forState:UIControlStateNormal];
        [buyBtn setTitleColor:COLOR_ORANGE_TEXT forState:UIControlStateNormal];
        [buyBtn setTitleColor:COLOR_MAIN_TEXT forState:UIControlStateHighlighted];
        buyBtn.titleLabel.font = FONT_16B;
        buyBtn.userInteractionEnabled = NO;
        [self addSubview:buyBtn];
    }
    
    CALayer *line = [CALayer layer];
    line.backgroundColor = UIColorFromRGBA(0xcccccc, 0.5).CGColor;
    line.frame = CGRectMake(0.f, CGRectGetHeight(self.frame)-1, CGRectGetWidth(self.frame), 1.f);
    [self.layer addSublayer:line];
}
- (void)setTitle:(NSString*)title{
    nameLabel.text = title;
    CGSize nameSize = [title sizeWithAttributes:@{NSFontAttributeName:FONT_16}];
    nameLabel.frame = CGRectMake(nameLabel.x, nameLabel.y, nameSize.width, nameLabel.height);
    
}
@end
