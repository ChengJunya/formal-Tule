//
//  TLWayNodeView.m
//  TL
//
//  Created by Rainbow on 2/15/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "TLWayNodeView.h"
#import "RUtiles.h"
#import "TLLeftRawBox.h"
#import "TLWayBookNodeDTO.h"
#import "TLImageDTO.h"
@implementation TLWayNodeView

- (instancetype)initWithFrame:(CGRect)frame itemData:(id)itemData
{
    self = [super initWithFrame:frame];
    if (self) {
        self.itemData = itemData;
        [self setUpView];
    }
    return self;
}

-(void)setUpView{
    TLWayBookNodeDTO *dto = self.itemData;
    
    CGFloat linePaddingLeft = 60.f;
    CGFloat anchorPaddingTop = 40.f;
    CGFloat anchorRadius = 7.f;
    CGFloat boxPaddingTop = 20.f;
    CGFloat boxGap = 10.f;
    
    //draw time line
    CALayer *timeLineLayer = [CALayer layer];
    timeLineLayer.frame = CGRectMake(linePaddingLeft, 0.f, 2.f, CGRectGetHeight(self.frame));
    timeLineLayer.backgroundColor = [UIColorFromRGBA(0xCCCCCC, 1.f) CGColor];
    [self.layer addSublayer:timeLineLayer];
    
    //draw anchor point
    CALayer *anchorLayer = [CALayer layer];
    anchorLayer.frame = CGRectMake(linePaddingLeft-anchorRadius, anchorPaddingTop, anchorRadius*2, anchorRadius*2);
    anchorLayer.cornerRadius = anchorRadius;
    anchorLayer.backgroundColor = [[UIColor orangeColor] CGColor];
    [self.layer addSublayer:anchorLayer];
    
    //addDay
    NSDate *publishDate = [RUtiles dateFromString:dto.createTime format:@"yyyy-MM-dd hh:mm:ss"];
    NSDateComponents *comps = [RUtiles getDateComponents:publishDate];
    
    NSString *pYear = [NSString stringWithFormat:@"%ld",comps.year];
    NSString *pMonth = [NSString stringWithFormat:@"%ld/",comps.month];
    NSString *pDay = [NSString stringWithFormat:@"%ld/",comps.day];
    
    NSDictionary *dic18 = [NSDictionary dictionaryWithObjectsAndKeys:FONT_18,NSFontAttributeName ,nil];
    NSDictionary *dic16 = [NSDictionary dictionaryWithObjectsAndKeys:FONT_14,NSFontAttributeName ,nil];
    NSDictionary *dic12 = [NSDictionary dictionaryWithObjectsAndKeys:FONT_12,NSFontAttributeName ,nil];
    CGSize pYearSize = [pYear sizeWithAttributes:dic12];
    CGSize pMonthSize = [pMonth sizeWithAttributes:dic16];
    CGSize pDaySize = [pDay sizeWithAttributes:dic18];
    
    CGFloat dayPaddingLeft = (linePaddingLeft-pDaySize.width-pMonthSize.width)/2;
    UILabel *yearLabel = [[UILabel alloc] initWithFrame:CGRectMake(dayPaddingLeft, anchorPaddingTop+pDaySize.height, pYearSize.width, pYearSize.height)];
    yearLabel.text = pYear;
    yearLabel.font = FONT_12;
    yearLabel.textColor = COLOR_MAIN_TEXT;
    [self addSubview:yearLabel];
    
    UILabel *monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(dayPaddingLeft+pDaySize.width, anchorPaddingTop+(pDaySize.height-pMonthSize.height), pMonthSize.width, pMonthSize.height)];
    monthLabel.text = pMonth;
    monthLabel.font = FONT_14;
    monthLabel.textColor = [UIColor orangeColor];
    [self addSubview:monthLabel];
    
    UILabel *dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(dayPaddingLeft, anchorPaddingTop, pDaySize.width, pDaySize.height)];
    dayLabel.text = pDay;
    dayLabel.font = FONT_18;
    dayLabel.textColor = [UIColor orangeColor];
    [self addSubview:dayLabel];
    
    
    
    //draw box
    TLLeftRawBox *box = [[TLLeftRawBox alloc] initWithFrame:CGRectMake(linePaddingLeft+10.f, boxPaddingTop, CGRectGetWidth(self.frame)-linePaddingLeft-20.f, CGRectGetHeight(self.frame)-boxPaddingTop*2)];
    box.arrawPaddingTop = anchorPaddingTop - boxPaddingTop;
    
    [self addSubview:box];
    
    //add boxinfo
    UIView *infoView = [[UIView alloc] initWithFrame:CGRectMake(10.f, 0.f, CGRectGetWidth(box.frame)-10.f, CGRectGetHeight(box.frame))];
    [box addSubview:infoView];
    
    
    NSString *cityStr =  dto.cityName;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:FONT_18,NSFontAttributeName ,nil];
    CGSize cityStrSize = [cityStr sizeWithAttributes:dic];
    NSString *node1Contex = dto.content;
    CGSize node1ContexSize = [node1Contex sizeWithAttributes:dic16];
    
    UILabel *cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(boxGap, boxGap, cityStrSize.width, cityStrSize.height)];
    cityLabel.text = [NSString stringWithFormat:@"%@",cityStr];
    cityLabel.textColor = COLOR_MAIN_TEXT;
    //cityLabel.strokeColor = [UIColor blackColor];
    cityLabel.font = FONT_18;
    //cityLabel.strokeSize = 0.5f;
    [infoView addSubview:cityLabel];
    
    
    UILabel *node1ContexLabel = [[UILabel alloc] initWithFrame:CGRectMake(boxGap, CGRectGetMaxY(cityLabel.frame)+boxGap, CGRectGetWidth(infoView.frame)-boxGap*2, 40)];
    node1ContexLabel.text = [NSString stringWithFormat:@"%@",node1Contex];
    node1ContexLabel.textColor = COLOR_MAIN_TEXT;
    //cityLabel.strokeColor = [UIColor blackColor];
    node1ContexLabel.font = FONT_14;
    node1ContexLabel.numberOfLines = 2;
    //cityLabel.strokeSize = 0.5f;
    [infoView addSubview:node1ContexLabel];
    
    CGFloat imageWidth = (self.width- linePaddingLeft-20.f-boxGap*5)/4;
    CGFloat imageHeight = (self.height-boxPaddingTop*2)-cityStrSize.height-40-boxGap*4;
    imageWidth = MIN(imageWidth, imageHeight);
    
    NSArray<TLImageDTO> *imageArray = dto.images;
    [imageArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (idx<4) {
            TLImageDTO *imageDto = obj;
            CGRect imageFrame = CGRectMake(imageWidth*idx+boxGap*(idx+1), infoView.height-boxGap-imageWidth, imageWidth, imageWidth);
            

            NSString *imageUrl = [NSString stringWithFormat:@"%@%@",TL_SERVER_BASE_URL,imageDto.imageUrl];
            
            if (imageUrl) {
                
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageFrame];
                imageView.layer.borderWidth = 1.f;
                imageView.layer.borderColor = [UIColor whiteColor].CGColor;
                [infoView addSubview:imageView];
                
                [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"ico_loading_logo"]];
                
                
                
            }
        }
        
    }];
    
    
    
    UIButton *handlerBtn = [[UIButton alloc] initWithFrame:infoView.bounds];
    [infoView addSubview:handlerBtn];

    [handlerBtn addTarget:self action:@selector(boxSelectHandler:) forControlEvents:UIControlEventTouchUpInside];
    
    
}


-(void)boxSelectHandler:(id)btn{
    if (self.ItemSelectBlock) {
        self.ItemSelectBlock(self.itemData);
    }
}
@end
