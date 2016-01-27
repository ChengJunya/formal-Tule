//
//  TLCarServiceCell.m
//  TL
//
//  Created by Rainbow on 2/18/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "TLCarServiceCell.h"
#import "RIconTextBtn.h"
#import "TLCarServiceDTO.h"
@implementation TLCarServiceCell
-(void)initContent{
    TLCarServiceDTO *cellDto = self.cellData;
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
    
    
    NSString *bgImageUrl = [NSString stringWithFormat:@"%@%@",TL_SERVER_BASE_URL,cellDto.serviceImageUrl];
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
    NSString *carType = cellDto.title;
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
    
    
    
    NSString *starLevel = [NSString stringWithFormat:@"%@",cellDto.rank];
    
    NSString *services =[NSString stringWithFormat:@"服务项目：%@", cellDto.serviceType];
    
    
    int starLevelCount = [starLevel intValue];
    
    CGFloat xOffSet = textPaddingLeft;
    
    for (int i=0; i<5; i++) {
        UIImageView *star = [[UIImageView alloc] initWithFrame:CGRectMake(xOffSet+(hGap+textHeight)*i, yOffSet+vGap, textHeight, textHeight)];
        if (i<starLevelCount) {
            star.image = [UIImage imageNamed:@"star1"];
        }else{
            star.image = [UIImage imageNamed:@"star2"];
        }
        [self.cellContentView addSubview:star];
    }
    
    
    
    
    
    
    yOffSet = yOffSet + vGap + textHeight;
    
    
    
    UILabel *servicesLabel = [[UILabel alloc] initWithFrame:CGRectMake(textPaddingLeft, yOffSet+vGap, textWidth, textHeight)];
    servicesLabel.text = services;
    servicesLabel.textColor = [UIColor orangeColor];
    servicesLabel.font = FONT_14;
    [self.cellContentView addSubview:servicesLabel];
    
    yOffSet = yOffSet + vGap + textHeight;
    //----------------
    
    NSString *userName = [NSString stringWithFormat:@"地址：%@",cellDto.address];
    
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
