//
//  TLLeftMenu.m
//  TL
//
//  Created by Rainbow on 2/7/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "TLLeftMenuCell.h"

@interface TLLeftMenuCell(){
    CALayer *pointLayer;
}
@property (nonatomic,strong) UIImageView *itemImageView;
@property (nonatomic,strong) UILabel *itemNameLabel;
@end

@implementation TLLeftMenuCell

-(void)initContent{
    CGFloat xOffSet = 40.f;
    CGFloat hGap = 20.0f;
    CGFloat vGap = 3.0f;
    CGFloat imageHeight = (CGRectGetHeight(self.frame)-vGap*2)/2;
    CGSize imageSize = CGSizeMake(imageHeight, imageHeight);
    //self.cellData :@{@"ID":@"01",@"NAME":@"更新系统",@"IMAGE":@"more_share"},
    NSString *itemName = [self.cellData valueForKey:@"NAME"];
    NSString *itemImageName = [self.cellData valueForKey:@"IMAGE"];
    
    //
    if (_itemImageView) {
        [_itemImageView removeFromSuperview];
    }
    _itemImageView = [[UIImageView alloc] initWithFrame:CGRectMake(xOffSet, vGap, imageSize.width, imageSize.height)];
    _itemImageView.image = [UIImage imageNamed:itemImageName];
    _itemImageView.center = CGPointMake(xOffSet+imageSize.width/2, CGRectGetHeight(self.frame)/2);
    [self addSubview:_itemImageView];
    
    if (_itemNameLabel) {
        [_itemNameLabel removeFromSuperview];
    }
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:FONT_18B,NSFontAttributeName ,nil];
    CGSize nameSize = [itemName sizeWithAttributes:dic];
    CGFloat labelVGap = (CGRectGetHeight(self.frame)-nameSize.height)/2;
    _itemNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(xOffSet+hGap+imageSize.width, labelVGap , nameSize.width, nameSize.height)];
    _itemNameLabel.text = itemName;
    _itemNameLabel.textColor = COLOR_TABLE_CELL;
    [self addSubview:_itemNameLabel];
    
    
    CGFloat pointRadios = 5.f;
    
    if (pointLayer) {
        [pointLayer removeFromSuperlayer];
    }
    
    if ([[self.cellData valueForKey:@"isShowPoint"] integerValue]==1) {
        
        pointLayer = [CALayer layer];
        
        [pointLayer setFrame:CGRectMake(_itemNameLabel.maxX+hGap, self.height/2-pointRadios, pointRadios*2, pointRadios*2)];
        pointLayer.cornerRadius = pointRadios;
        pointLayer.backgroundColor = [[UIColor redColor] CGColor];
        [self.layer addSublayer:pointLayer];
    }
    
    
    self.cellHeight = 40.f;
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
}
@end
