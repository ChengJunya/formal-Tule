//
//  TLCarCommentDetailView.m
//  TL
//
//  Created by Rainbow on 2/19/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "TLCarCommentDetailView.h"
#import "TLKeyValueItemView.h"
#import "TLCarEvalDetailResultDTO.h"

@interface TLCarCommentDetailView(){
    TLCarEvalDetailResultDTO *detailDto;
}

@end

@implementation TLCarCommentDetailView
- (instancetype)initWithFrame:(CGRect)frame viewData:(id)viewData detailData:(id)detailData{
    detailDto = detailData;
    self = [super initWithFrame:frame viewData:viewData type:@"53"];
    if (self) {
        
    }
    return self;
}

-(void)setUpViews{
    [self addTitleAndPublishTime];
    [self addImageView];
    [self addCarBasicInfo];
    //[self addUserIcon];
    //[self addTitle];
    //[self addPublishDate];
    //[self addCity];
    //[self addInfoView];
    //[self validateYOffSet];
    [self addTextContent];
    
    
    
}

-(void)addTitleAndPublishTime{
    NSDictionary *dic18 = [NSDictionary dictionaryWithObjectsAndKeys:FONT_18B,NSFontAttributeName, nil];
    NSDictionary *dic14 = [NSDictionary dictionaryWithObjectsAndKeys:FONT_14,NSFontAttributeName, nil];
    NSString *title = detailDto.carType;
    NSString *publisTime = detailDto.publishTime;
    NSString *userName = detailDto.editor;
    NSString *puStr = [NSString stringWithFormat:@"编辑：%@    %@",userName,publisTime];
    
    CGSize titleSize = [title sizeWithAttributes:dic18];
    CGSize puSize = [puStr sizeWithAttributes:dic14];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(TLDETAILVIEW_H_GAP, self.yOffSet+TLDETAILVIEW_V_GAP, CGRectGetWidth(self.frame)-TLDETAILVIEW_H_GAP*2, titleSize.height)];
    titleLabel.font = FONT_18B;
    titleLabel.text = title;
    titleLabel.textColor = COLOR_MAIN_TEXT;
    [self.viewContentScroll addSubview:titleLabel];
    
    self.yOffSet = self.yOffSet + titleSize.height + TLDETAILVIEW_V_GAP;
    
    UILabel *puLabel = [[UILabel alloc] initWithFrame:CGRectMake(TLDETAILVIEW_H_GAP, self.yOffSet+TLDETAILVIEW_V_GAP, CGRectGetWidth(self.frame)-TLDETAILVIEW_H_GAP*2, puSize.height)];
    puLabel.font = FONT_14;
    puLabel.text = puStr;
    puLabel.textColor = COLOR_MAIN_TEXT;
    [self.viewContentScroll addSubview:puLabel];
    
    self.yOffSet = self.yOffSet + puSize.height + TLDETAILVIEW_V_GAP;
    
    CALayer *line = [CALayer layer];
    line.frame = CGRectMake(0.f, self.yOffSet+TLDETAILVIEW_V_GAP, CGRectGetWidth(self.frame), 1.f);
    line.backgroundColor = UIColorFromRGBA(0xCCCCCC, 0.5).CGColor;
    [self.viewContentScroll.layer addSublayer:line];
    
    self.yOffSet = self.yOffSet + CGRectGetHeight(line.frame) + TLDETAILVIEW_V_GAP*2;
    
    
    
    
}

-(void)addCarBasicInfo{
    NSString *carType = detailDto.carType;
    NSString *oil = detailDto.oilCost;
    NSString *onMarketTime = detailDto.publishTime;
    
    NSArray *keyValueArray = @[@{@"KEY":@"车型",@"VALUE":carType},
                               @{@"KEY":@"油耗",@"VALUE":oil},
                               @{@"KEY":@"上市时间",@"VALUE":onMarketTime}];
    TLKeyValueItemView *item = [[TLKeyValueItemView alloc] initWithFrame:CGRectMake(0.f, self.yOffSet+TLDETAILVIEW_V_GAP, CGRectGetWidth(self.frame), 80.f) itemData:keyValueArray];
    [self.viewContentScroll addSubview:item];
    
    self.yOffSet = self.yOffSet + CGRectGetHeight(item.frame) + TLDETAILVIEW_V_GAP*2;
    
}


@end
