//
//  TLSecondCell.m
//  TL
//
//  Created by Rainbow on 2/20/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "TLSecondCell.h"
#import "TLSecondGoodsDTO.h"
@implementation TLSecondCell


-(void)initContent{
    
    TLSecondGoodsDTO *cellDto = self.cellData;
    //titlebox
    //contentbox
//    self.backgroundColor = UIColorFromRGBA(0x000000, 0.5);
    CGFloat yOffSet = 0.f;
    CGFloat imageHeight =  75.f;
    CGFloat imageWidth = 100.f;
    
    
    if (self.cellContentView) {
        [self.cellContentView removeFromSuperview];
        self.cellContentView = nil;
    }
    
    self.cellContentView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:self.cellContentView];
    
    
    CGFloat vGap = 3.f;
    CGFloat hGap = 10.f;
    
    CGFloat textPaddingLeft = hGap*2+imageWidth;
    
    
    //
    //add image
   
     NSString *bgImageUrl = [NSString stringWithFormat:@"%@%@",TL_SERVER_BASE_URL,cellDto.goodsImageUrl];
    if (bgImageUrl) {
        UIImageView *cellImage = [[UIImageView alloc] initWithFrame:CGRectMake(hGap, vGap, imageWidth, imageHeight)];
        cellImage.backgroundColor = UIColorFromRGBA(0x000000, 0.5);
        //cellImage.alpha = 0.f;
        [self.cellContentView addSubview:cellImage];
        [cellImage sd_setImageWithURL:[NSURL URLWithString:bgImageUrl] placeholderImage:[UIImage imageNamed:@"ico_loading_logo"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            cellImage.image = [RUtiles changeImage:image height:cellImage.height width:cellImage.width];
        }];
        
    }
    
    
    
    
    
    
    
    
    //--------title
    NSString *titleStr = cellDto.goodsName;
    NSDictionary *titleDic = [NSDictionary dictionaryWithObjectsAndKeys:FONT_16B,NSFontAttributeName ,nil];
    CGSize titleSize = [titleStr sizeWithAttributes:titleDic];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(textPaddingLeft, yOffSet+vGap, titleSize.width, titleSize.height)];
    titleLabel.text = titleStr;
    titleLabel.textColor = COLOR_MAIN_TEXT;
    titleLabel.font = FONT_16B;
    [self.cellContentView addSubview:titleLabel];
    
    
    
   
    
    
    yOffSet = yOffSet + vGap + titleSize.height;
    
    
    
    NSString *userName = [NSString stringWithFormat:@"%@",cellDto.editor];
    NSDictionary *infoDic = [NSDictionary dictionaryWithObjectsAndKeys:FONT_14,NSFontAttributeName ,nil];
    CGSize userNameSize = [userName sizeWithAttributes:infoDic];
    
    CGFloat textHeight = userNameSize.height;
    CGFloat textWidth = CGRectGetWidth(self.cellContentView.frame)-textPaddingLeft-hGap*2;
    
    
    
   
    
    
    NSString *newPercent =[NSString stringWithFormat:@"成色：%@", cellDto.oldDesc];
    UILabel *newPercentLabel = [[UILabel alloc] initWithFrame:CGRectMake(textPaddingLeft, yOffSet+vGap, textWidth, textHeight)];
    newPercentLabel.text = newPercent;
    newPercentLabel.textColor = COLOR_MAIN_TEXT;
    newPercentLabel.font = FONT_14;
    [self.cellContentView addSubview:newPercentLabel];
    
    yOffSet = yOffSet + vGap + textHeight;
    //----------------
    
    NSString *content =[NSString stringWithFormat:@"%@", cellDto.goodsDesc];
 
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(textPaddingLeft, yOffSet+vGap, textWidth, textHeight)];
    contentLabel.text = content;
    contentLabel.textColor = COLOR_MAIN_TEXT;
    contentLabel.font = FONT_14;
    [self.cellContentView addSubview:contentLabel];
    
    yOffSet = yOffSet + vGap + textHeight;
    
    //----------user-----
    
   
    
    UILabel *userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.cellContentView.frame)-userNameSize.width-hGap, yOffSet+vGap, userNameSize.width, userNameSize.height)];
    userNameLabel.text = userName;
    userNameLabel.textColor = COLOR_MAIN_TEXT;
    userNameLabel.font = FONT_14;
    [self.cellContentView addSubview:userNameLabel];
    
    
    
    //----------------
    NSString *price = [NSString stringWithFormat:@"%@",cellDto.price];
    
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(textPaddingLeft, yOffSet+vGap, textWidth, textHeight)];
    priceLabel.text = price;
    priceLabel.textColor = [UIColor orangeColor];
    priceLabel.font = FONT_14;
    [self.cellContentView addSubview:priceLabel];
    
    yOffSet = yOffSet + vGap + textHeight;
    
    CALayer *bottomLine = [CALayer layer];
    bottomLine.frame = CGRectMake(hGap, yOffSet+vGap, CGRectGetWidth(self.cellContentView.frame)-hGap*2, 1.f);
    bottomLine.backgroundColor = UIColorFromRGBA(0xCCCCCC, 0.5).CGColor;
    [self.cellContentView.layer addSublayer:bottomLine];
    
    
    
    self.cellHeight = yOffSet+vGap*2;
    
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    
    // Configure the view for the selected state
    if (selected) {
        NSLog(@"selected");
        self.backgroundColor = [UIColor clearColor];
        
        //[self action];
        
    }else{
        NSLog(@"unSelected");
        self.backgroundColor = [UIColor clearColor];
    }
    
}

@end
