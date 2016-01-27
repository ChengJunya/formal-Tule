//
//  TLCarInfoCell.m
//  TL
//
//  Created by Rainbow on 2/18/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "TLCarInfoCell.h"
#import "RIconTextBtn.h"
#import "TLListCarDTO.h"
@implementation TLCarInfoCell

-(void)initContent{
    
    TLListCarDTO *cellDto = self.cellData;
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

    NSString *bgImageUrl = [NSString stringWithFormat:@"%@%@",TL_SERVER_BASE_URL,cellDto.carImageUrl];
    if (bgImageUrl) {
        UIImageView *cellImage = [[UIImageView alloc] initWithFrame:CGRectMake(hGap, vGap, imageWidth, imageHeight)];
        cellImage.backgroundColor = UIColorFromRGBA(0x000000, 0.5);
        //cellImage.alpha = 0.f;
        [self.cellContentView addSubview:cellImage];
        [cellImage sd_setImageWithURL:[NSURL URLWithString:bgImageUrl] placeholderImage:[UIImage imageNamed:@"ico_loading_logo"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            cellImage.image = [RUtiles changeImage:image height:cellImage.height width:cellImage.width];
        }];
    
    }
    

    
    
    
    
    NSDictionary *infoDic = [NSDictionary dictionaryWithObjectsAndKeys:FONT_14,NSFontAttributeName ,nil];
    
    NSString *publishDateStr = [NSString stringWithFormat:@"%@",cellDto.createTime];
    CGSize publishDateStrSize = [publishDateStr sizeWithAttributes:infoDic];
    
    //--------title
    NSString *carType = cellDto.carType;
    NSDictionary *titleDic = [NSDictionary dictionaryWithObjectsAndKeys:FONT_16,NSFontAttributeName ,nil];
    CGSize titleSize = [@"H" sizeWithAttributes:titleDic];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(textPaddingLeft, yOffSet+vGap, self.width-textPaddingLeft-hGap*3-publishDateStrSize.width, titleSize.height)];
    titleLabel.text = carType;
    titleLabel.textColor = COLOR_MAIN_TEXT;
    titleLabel.font = FONT_16;
    [self.cellContentView addSubview:titleLabel];
    
    
    
    //--------publish data
    
    
    UILabel *publishDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.cellContentView.frame)-publishDateStrSize.width-hGap, yOffSet+vGap, publishDateStrSize.width, publishDateStrSize.height)];
    publishDateLabel.text = publishDateStr;
    publishDateLabel.textColor = COLOR_MAIN_TEXT;
    publishDateLabel.font = FONT_14;
    [self.cellContentView addSubview:publishDateLabel];
    
   
    yOffSet = yOffSet + vGap + titleSize.height;
    
    
    CGFloat textHeight = publishDateStrSize.height;

    CGFloat textWidth = CGRectGetWidth(self.cellContentView.frame)-textPaddingLeft-hGap*2;
    
    
    
    NSString *price = [NSString stringWithFormat:@"价格：%@",cellDto.priceRange];
   
    NSString *onMarketTime =[NSString stringWithFormat:@"上市日期：%@", cellDto.publishTime];
    
    
    
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(textPaddingLeft, yOffSet+vGap, textWidth, textHeight)];
    priceLabel.text = price;
    priceLabel.textColor = [UIColor orangeColor];
    priceLabel.font = FONT_14;
    [self.cellContentView addSubview:priceLabel];
    
    yOffSet = yOffSet + vGap + textHeight;
    
    
    
    UILabel *onMarketTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(textPaddingLeft, yOffSet+vGap, textWidth, textHeight)];
    onMarketTimeLabel.text = onMarketTime;
    onMarketTimeLabel.textColor = COLOR_MAIN_TEXT;
    onMarketTimeLabel.font = FONT_14;
    [self.cellContentView addSubview:onMarketTimeLabel];
    
    yOffSet = yOffSet + vGap + textHeight;
    //----------------
    
    NSString *userName = [NSString stringWithFormat:@"编辑：%@",cellDto.editor];
    
    UILabel *userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(textPaddingLeft, yOffSet+vGap, textWidth, textHeight)];
    userNameLabel.text = userName;
    userNameLabel.textColor = COLOR_MAIN_TEXT;
    userNameLabel.font = FONT_14;
    [self.cellContentView addSubview:userNameLabel];
    
    yOffSet = yOffSet + vGap + textHeight;
    //----------------
    
    
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
