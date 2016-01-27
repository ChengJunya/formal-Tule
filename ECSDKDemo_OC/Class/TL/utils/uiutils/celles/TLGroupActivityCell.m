//
//  TLGroupActivityCell.m
//  TL
//
//  Created by Rainbow on 2/16/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "TLGroupActivityCell.h"
#import "RIconTextBtn.h"
#import "TLActivityDTO.h"
@implementation TLGroupActivityCell


-(void)initContent{
    
    TLActivityDTO *cellDto = self.cellData;
    //titlebox
    //contentbox
//    self.backgroundColor = UIColorFromRGBA(0x000000, 0.5);
//    CGFloat cellTempHeight = 200.f;
    
    if (self.cellContentView) {
        [self.cellContentView removeFromSuperview];
        self.cellContentView = nil;
    }
    
    self.cellContentView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:self.cellContentView];
    
    
    CGFloat topHeight = 40.f;
    CGFloat vGap = 10.f;
    CGFloat hGap = 10.f;
    CGFloat bottomHieght = 30.f;
    CGFloat anchorRadios = 16.f;
    CGFloat textPaddingLeft = hGap*2+anchorRadios*2;
    
    //--------title
    NSString *titleStr = cellDto.title;
    NSDictionary *titleDic = [NSDictionary dictionaryWithObjectsAndKeys:FONT_16,NSFontAttributeName ,nil];
    CGSize titleSize = [titleStr sizeWithAttributes:titleDic];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(hGap, (topHeight-titleSize.height)/2, titleSize.width, titleSize.height)];
    titleLabel.text = titleStr;
    titleLabel.textColor = COLOR_MAIN_TEXT;
    titleLabel.font = FONT_16;
    [self.cellContentView addSubview:titleLabel];
    
    //--------publish data
    NSDictionary *infoDic = [NSDictionary dictionaryWithObjectsAndKeys:FONT_14,NSFontAttributeName ,nil];
    
    NSString *publishDateStr = cellDto.publishTime;
    CGSize publishDateStrSize = [publishDateStr sizeWithAttributes:infoDic];
    
    UILabel *publishDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.cellContentView.frame)-publishDateStrSize.width-hGap, (topHeight-publishDateStrSize.height)/2, publishDateStrSize.width, publishDateStrSize.height)];
    publishDateLabel.text = publishDateStr;
    publishDateLabel.textColor = COLOR_MAIN_TEXT;
    publishDateLabel.font = FONT_14;
    [self.cellContentView addSubview:publishDateLabel];
    
    CALayer *topLine = [CALayer layer];
    topLine.frame = CGRectMake(hGap, topHeight, CGRectGetWidth(self.cellContentView.frame)-hGap*2, 1.f);
    topLine.backgroundColor = UIColorFromRGBA(0xCCCCCC, 0.5).CGColor;
    [self.cellContentView.layer addSublayer:topLine];
    
    
    
    CGFloat textHeight = publishDateStrSize.height;

    
    CGFloat imageHeight = textHeight*5+vGap*3;
    CGFloat textWidth = CGRectGetWidth(self.cellContentView.frame)-textPaddingLeft-imageHeight-hGap*2;
    
    
    
    NSString *city = cellDto.destnation;//目标城市
    NSString *costAverage = cellDto.costAverage;
    NSString *pCount = cellDto.personNum;
    NSString *content = cellDto.desc;
    
    
    
    
    UILabel *cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(textPaddingLeft, topHeight+vGap, textWidth, textHeight)];
    cityLabel.text = city;
    cityLabel.textColor = COLOR_MAIN_TEXT;
    cityLabel.font = FONT_14;
    [self.cellContentView addSubview:cityLabel];
    
//    CALayer *cityAnchor = [CALayer layer];
//    cityAnchor.frame = CGRectMake(vGap+anchorRadios, CGRectGetMinY(cityLabel.frame)+(textHeight-anchorRadios*2)/2, anchorRadios*2, anchorRadios*2);
//    cityAnchor.cornerRadius = anchorRadios;
//    cityAnchor.backgroundColor = [[UIColor blueColor] CGColor];
    
    UIImageView *cityAnchor = [[UIImageView alloc] initWithFrame:CGRectMake(vGap, CGRectGetMinY(cityLabel.frame)+(textHeight-anchorRadios)/2, anchorRadios, anchorRadios)];
    cityAnchor.image = [UIImage imageNamed:@"tl_activity_city_dot"];
    [self.cellContentView addSubview:cityAnchor];
    
    UILabel *startEndTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(textPaddingLeft, topHeight+vGap*2+textHeight, textWidth, textHeight)];
    startEndTimeLabel.text = costAverage;
    startEndTimeLabel.textColor = COLOR_MAIN_TEXT;
    startEndTimeLabel.font = FONT_14;
    [self.cellContentView addSubview:startEndTimeLabel];
    
//    CALayer *startEndTimeAnchor = [CALayer layer];
//    startEndTimeAnchor.frame = CGRectMake(vGap+anchorRadios, CGRectGetMinY(startEndTimeLabel.frame)+(textHeight-anchorRadios*2)/2, anchorRadios*2, anchorRadios*2);
//    startEndTimeAnchor.cornerRadius = anchorRadios;
//    startEndTimeAnchor.backgroundColor = [[UIColor greenColor] CGColor];
//    [self.cellContentView.layer addSublayer:startEndTimeAnchor];
    
    UIImageView *costAverageAnchor = [[UIImageView alloc] initWithFrame:CGRectMake(vGap, CGRectGetMinY(startEndTimeLabel.frame)+(textHeight-anchorRadios)/2, anchorRadios, anchorRadios)];
    costAverageAnchor.image = [UIImage imageNamed:@"tl_activity_pay_dot"];
    [self.cellContentView addSubview:costAverageAnchor];
//----------------
    
    UILabel *pCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(textPaddingLeft, topHeight+vGap*3+textHeight*2, textWidth, textHeight)];
    pCountLabel.text = pCount;
    pCountLabel.textColor = COLOR_MAIN_TEXT;
    pCountLabel.font = FONT_14;
    [self.cellContentView addSubview:pCountLabel];
    
//    CALayer *pCountAnchor = [CALayer layer];
//    pCountAnchor.frame = CGRectMake(vGap+anchorRadios, CGRectGetMinY(pCountLabel.frame)+(textHeight-anchorRadios*2)/2, anchorRadios*2, anchorRadios*2);
//    pCountAnchor.cornerRadius = anchorRadios;
//    pCountAnchor.backgroundColor = [[UIColor orangeColor] CGColor];
//    [self.cellContentView.layer addSublayer:pCountAnchor];
    
    UIImageView *pCountAnchor = [[UIImageView alloc] initWithFrame:CGRectMake(vGap, CGRectGetMinY(pCountLabel.frame)+(textHeight-anchorRadios)/2, anchorRadios, anchorRadios)];
    pCountAnchor.image = [UIImage imageNamed:@"tl_activity_person_dot"];
    [self.cellContentView addSubview:pCountAnchor];
    //----------------
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(textPaddingLeft, topHeight+vGap*4+textHeight*3, textWidth, textHeight*2)];
    contentLabel.text = content;
    contentLabel.textColor = COLOR_MAIN_TEXT;
    contentLabel.font = FONT_14;
    contentLabel.numberOfLines = 2;
    [self.cellContentView addSubview:contentLabel];
    
//    CALayer *contentAnchor = [CALayer layer];
//    contentAnchor.frame = CGRectMake(vGap+anchorRadios, CGRectGetMinY(contentLabel.frame)+(textHeight-anchorRadios*2)/2, anchorRadios*2, anchorRadios*2);
//    contentAnchor.cornerRadius = anchorRadios;
//    contentAnchor.backgroundColor = [[UIColor redColor] CGColor];
//    [self.cellContentView.layer addSublayer:contentAnchor];
    
    UIImageView *contentAnchor = [[UIImageView alloc] initWithFrame:CGRectMake(vGap, CGRectGetMinY(contentLabel.frame)+(textHeight-anchorRadios)/2, anchorRadios, anchorRadios)];
    contentAnchor.image = [UIImage imageNamed:@"tl_activity_describe"];
    [self.cellContentView addSubview:contentAnchor];
    //----------------

    
//    
//

    
        NSString *bgImageUrl = [NSString stringWithFormat:@"%@%@",TL_SERVER_BASE_URL,cellDto.activityImage];

    
    //    CGFloat imageHeight = self.cellContentView.height;
    //    CGFloat imageWidth = self.cellContentView.width;
    if (bgImageUrl) {
        UIImageView *cellImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.cellContentView.frame)-imageHeight-hGap, topHeight+vGap, imageHeight, imageHeight)];
        cellImage.backgroundColor = UIColorFromRGBA(0x000000, 0.5);
        //cellImage.alpha = 0.f;
        [self.cellContentView addSubview:cellImage];
        [cellImage sd_setImageWithURL:[NSURL URLWithString:bgImageUrl] placeholderImage:[UIImage imageNamed:@"ico_loading_logo"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            cellImage.image = [RUtiles changeImage:image height:cellImage.height width:cellImage.width];
        }];
        
       
        
        
        
        

        
    }
    

    CALayer *bottomLine = [CALayer layer];
    bottomLine.frame = CGRectMake(hGap, topHeight+imageHeight+vGap*2, CGRectGetWidth(self.cellContentView.frame)-hGap*2, 1.f);
    bottomLine.backgroundColor = UIColorFromRGBA(0xCCCCCC, 0.5).CGColor;
    [self.cellContentView.layer addSublayer:bottomLine];
    
    
    
    NSString *favorableCountStr = cellDto.viewCount;
    CGSize favorableCountSize = [favorableCountStr sizeWithAttributes:infoDic];
    
    NSString *commentCountStr = cellDto.commentCount;
    CGSize commentCountSize = [commentCountStr sizeWithAttributes:infoDic];
    
    
    RIconTextBtn *favorableImageTextBtn = [[RIconTextBtn alloc] initWithFrame:CGRectMake(hGap, CGRectGetMaxY(bottomLine.frame)+vGap, 20.0+commentCountSize.width+10.f, 20.f)];
    [favorableImageTextBtn setImage:[UIImage imageNamed:@"tl_activity_popularity"] forState:UIControlStateNormal];
    [favorableImageTextBtn setTitle:favorableCountStr forState:UIControlStateNormal];
    favorableImageTextBtn.titleLabel.font = FONT_14;
    [favorableImageTextBtn setTitleColor:COLOR_MAIN_TEXT forState:UIControlStateNormal];
    //favorableImageTextBtn.layer.borderColor = [UIColor orangeColor].CGColor;
    //favorableImageTextBtn.layer.borderWidth = 0.5f;
    [self.cellContentView addSubview:favorableImageTextBtn];

  
    RIconTextBtn *commentImageTextBtn = [[RIconTextBtn alloc] initWithFrame:CGRectMake(CGRectGetMaxX(favorableImageTextBtn.frame)+ hGap, CGRectGetMinY(favorableImageTextBtn.frame), 20.0+favorableCountSize.width+10.f, 20.f)];
    [commentImageTextBtn setImage:[UIImage imageNamed:@"tl_activity_comment"] forState:UIControlStateNormal];
    [commentImageTextBtn setTitle:commentCountStr forState:UIControlStateNormal];
    commentImageTextBtn.titleLabel.font = FONT_14;
    [commentImageTextBtn setTitleColor:COLOR_MAIN_TEXT forState:UIControlStateNormal];
    
    [self.cellContentView addSubview:commentImageTextBtn];
    
    
    NSString *currentUserCount = [NSString stringWithFormat:@"已报名:%@",cellDto.enrollCount];
    CGSize currentUserCountSize = [currentUserCount sizeWithAttributes:infoDic];
    NSMutableAttributedString *currentUserCountColorStr = [[NSMutableAttributedString alloc] initWithString:currentUserCount];
    
    NSRange typeStart = [currentUserCount rangeOfString:@":"];
    
    [currentUserCountColorStr addAttribute:NSForegroundColorAttributeName value:COLOR_ORANGE_TEXT range:NSMakeRange(0,typeStart.location+typeStart.length)];
    [currentUserCountColorStr addAttribute:NSForegroundColorAttributeName value:COLOR_MAIN_TEXT range:NSMakeRange(typeStart.location+typeStart.length,currentUserCount.length-typeStart.location-typeStart.length)];
    
    UILabel *currentUserCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.cellContentView.frame)-hGap-currentUserCountSize.width, CGRectGetMaxY(bottomLine.frame)+vGap, currentUserCountSize.width, currentUserCountSize.height)];
    currentUserCountLabel.font = FONT_14;
    currentUserCountLabel.attributedText = currentUserCountColorStr;
    [self.cellContentView addSubview:currentUserCountLabel];
    
    
    CALayer *sepLine = [CALayer layer];
    sepLine.frame = CGRectMake(0, CGRectGetMaxY(currentUserCountLabel.frame)+vGap, CGRectGetWidth(self.cellContentView.frame), 10.f);
    sepLine.backgroundColor = UIColorFromRGBA(0xCCCCCC, 0.5).CGColor;
    [self.cellContentView.layer addSublayer:sepLine];


//
//
//
//
//
//    
//    
//    
//    NSArray *wayNodeArray = [self.cellData valueForKey:@"NODES"];
//    CGFloat nodePaddingLeft = 60.f;
//    CGFloat nodePddingTop = userIconHeight + 50.f;
//    CGFloat nodeVGap = 50.0f;
//    CGFloat pointVGap = 7.f;
//    if (wayNodeArray.count>1) {
//        NSString *cityStr =  [[wayNodeArray objectAtIndex:0] valueForKey:@"CITY"];
//        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:FONT_18,NSFontAttributeName ,nil];
//        CGSize cityStrSize = [cityStr sizeWithAttributes:dic];
//        NSString *node1Contex = [[wayNodeArray objectAtIndex:0] valueForKey:@"CONTENT"];
//        CGSize node1ContexSize = [node1Contex sizeWithAttributes:infoDic];
//        
//        UILabel *cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(nodePaddingLeft, nodePddingTop, cityStrSize.width, cityStrSize.height)];
//        cityLabel.text = [NSString stringWithFormat:@"%@",cityStr];
//        cityLabel.textColor = [UIColor orangeColor];
//        //cityLabel.strokeColor = [UIColor blackColor];
//        cityLabel.font = FONT_18;
//        //cityLabel.strokeSize = 0.5f;
//        [self.cellContentView addSubview:cityLabel];
//        
//        
//        UILabel *node1ContexLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.f+cityStrSize.width+nodePaddingLeft, nodePddingTop+cityStrSize.height-node1ContexSize.height, CGRectGetWidth(self.cellContentView.frame)-30.f-cityStrSize.width-nodePaddingLeft, node1ContexSize.height)];
//        node1ContexLabel.text = [NSString stringWithFormat:@"%@",node1Contex];
//        node1ContexLabel.textColor = [UIColor whiteColor];
//        //cityLabel.strokeColor = [UIColor blackColor];
//        node1ContexLabel.font = FONT_14;
//        //cityLabel.strokeSize = 0.5f;
//        [self.cellContentView addSubview:node1ContexLabel];
//        
//        
//        
//        
//        
//        NSString *city2Str = [[wayNodeArray objectAtIndex:1] valueForKey:@"CITY"];
//        CGSize city2StrSize = [city2Str sizeWithAttributes:dic];
//        NSString *node2Contex = [[wayNodeArray objectAtIndex:1] valueForKey:@"CONTENT"];
//        CGSize node2ContexSize = [node2Contex sizeWithAttributes:infoDic];
//        
//        
//        
//        
//        UILabel *city2Label = [[UILabel alloc] initWithFrame:CGRectMake(nodePaddingLeft, nodePddingTop+nodeVGap, city2StrSize.width, city2StrSize.height)];
//        city2Label.text = [NSString stringWithFormat:@"%@",city2Str];
//        city2Label.textColor = [UIColor whiteColor];
//        //cityLabel.strokeColor = [UIColor blackColor];
//        city2Label.font = FONT_18;
//        //cityLabel.strokeSize = 0.5f;
//        [self.cellContentView addSubview:city2Label];
//        
//        
//        UILabel *node2ContexLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.f+city2StrSize.width+nodePaddingLeft, nodePddingTop+nodeVGap+city2StrSize.height-node2ContexSize.height, CGRectGetWidth(self.cellContentView.frame)-30.f-city2StrSize.width-nodePaddingLeft, node2ContexSize.height)];
//        node2ContexLabel.text = [NSString stringWithFormat:@"%@",node2Contex];
//        node2ContexLabel.textColor = [UIColor whiteColor];
//        //cityLabel.strokeColor = [UIColor blackColor];
//        node2ContexLabel.font = FONT_14;
//        //cityLabel.strokeSize = 0.5f;
//        [self.cellContentView addSubview:node2ContexLabel];
//        
//        
//        CALayer *startWhiteAnchor = [CALayer layer];
//        startWhiteAnchor.frame = CGRectMake(nodePaddingLeft-10.f-pointVGap, nodePddingTop+pointVGap, 10.f, 10.f);
//        startWhiteAnchor.cornerRadius = 5.f;
//        startWhiteAnchor.backgroundColor = [[UIColor whiteColor] CGColor];
//        CALayer *startRedAnchor = [CALayer layer];
//        startRedAnchor.frame = CGRectMake(nodePaddingLeft-8.f-pointVGap, nodePddingTop+2+pointVGap, 6.f, 6.f);
//        startRedAnchor.cornerRadius = 3.f;
//        startRedAnchor.backgroundColor = [[UIColor redColor] CGColor];
//        
//        CALayer *endWhiteAnchor = [CALayer layer];
//        endWhiteAnchor.frame = CGRectMake(nodePaddingLeft-8.f-pointVGap, nodePddingTop+nodeVGap+pointVGap, 6.f, 6.f);
//        endWhiteAnchor.cornerRadius = 3.f;
//        endWhiteAnchor.backgroundColor = [[UIColor whiteColor] CGColor];
//        
//        CALayer *vline = [CALayer layer];
//        vline.frame = CGRectMake(CGRectGetMaxX(startWhiteAnchor.frame)-6.f, CGRectGetMaxY(startWhiteAnchor.frame)+pointVGap, 2.f, nodeVGap-cityStrSize.height-pointVGap+2);
//        vline.backgroundColor = [[UIColor orangeColor] CGColor];
//        
//        
//        [self.cellContentView.layer addSublayer:startWhiteAnchor];
//        [self.cellContentView.layer addSublayer:startRedAnchor];
//        [self.cellContentView.layer addSublayer:endWhiteAnchor];
//        [self.cellContentView.layer addSublayer:vline];
//        
//    }
    
    
    
    self.cellHeight = topHeight+bottomHieght+imageHeight+vGap*3+10.f;
    
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
