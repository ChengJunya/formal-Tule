//
//  TLStoreProItem.m
//  TL
//
//  Created by Rainbow on 2/27/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "TLStoreProItem.h"
#import "RUILabel.h"
@implementation TLStoreProItem

- (instancetype)initWithFrame:(CGRect)frame itemData:(id)itemData
{
    self = [super initWithFrame:frame];
    if (self) {
        self.itemData = itemData;
        [self setupSubViews];
    }
    return self;
}

-(void)setupSubViews{
    CGFloat vGap = 3.f;
    CGFloat hGap = 3.f;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:FONT_14,NSFontAttributeName ,nil];
    NSString *name = [self.itemData valueForKey:@"NAME"];
    CGSize userNameSize = [name sizeWithAttributes:dic];
    
    CGFloat imageWidth = CGRectGetHeight(self.frame)-userNameSize.height-vGap*3;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(hGap+(CGRectGetWidth(self.frame)-imageWidth)/2, vGap, imageWidth, imageWidth)];
    imageView.image = [UIImage imageNamed:[self.itemData valueForKey:@"IMAGE"]];
    [self addSubview:imageView];
    
    
    
    CGFloat textWidth = CGRectGetWidth(self.frame);
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(hGap, CGRectGetHeight(self.frame)-vGap-userNameSize.height, textWidth-hGap*2, userNameSize.height)];
    nameLabel.text = name;
    nameLabel.font = FONT_14;
    nameLabel.textColor = COLOR_MAIN_TEXT;
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:nameLabel];
    
    
    
}
@end
