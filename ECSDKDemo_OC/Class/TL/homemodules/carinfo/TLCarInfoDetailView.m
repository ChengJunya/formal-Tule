//
//  TLCarInfoDetailView.m
//  TL
//
//  Created by Rainbow on 2/19/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "TLCarInfoDetailView.h"
#import "TLKeyValueItemView.h"
#import "TLCarDEtailResultDTO.h"
#import "TLFormItem.h"
#import "TLGridCellView.h"
@interface TLCarInfoDetailView(){
    TLCarDEtailResultDTO *detailDto;
}

@end

@implementation TLCarInfoDetailView


- (instancetype)initWithFrame:(CGRect)frame viewData:(id)viewData detailData:(id)detailData{
    detailDto = detailData;
    self = [super initWithFrame:frame viewData:viewData type:@"51"];
    if (self) {
        
    }
    return self;
}

-(void)setUpViews{
    [self addTitleAndPublishTime];
    [self addCarBasicInfo];
    [self addCarOtherInfo];
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
    NSString *publisTime = detailDto.createTime;
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
    
    NSString *carMaker = detailDto.carMaker;
    if (carMaker) {
        TLFormItem *item = [[TLFormItem alloc] initWithFrame:CGRectMake(0.f, self.yOffSet+TLDETAILVIEW_V_GAP, CGRectGetWidth(self.frame), 40.f) itemData:@{@"LABEL_NAME":@"厂商：",@"LABEL_VALUE":carMaker}];
        item.frame = item.itemFrame;
        [self.viewContentScroll addSubview:item];
        self.yOffSet = self.yOffSet + CGRectGetHeight(item.frame) + TLDETAILVIEW_V_GAP;
    }
    
    
    NSString *carBrand = detailDto.carBrand;
    if (carBrand) {
        TLFormItem *item = [[TLFormItem alloc] initWithFrame:CGRectMake(0.f, self.yOffSet+TLDETAILVIEW_V_GAP, CGRectGetWidth(self.frame), 40.f) itemData:@{@"LABEL_NAME":@"品牌名称：",@"LABEL_VALUE":carBrand}];
        item.frame = item.itemFrame;
        [self.viewContentScroll addSubview:item];
        
        self.yOffSet = self.yOffSet + CGRectGetHeight(item.frame) + TLDETAILVIEW_V_GAP;
    }
    
    NSString *publishTime = detailDto.publishTime;
    if (publishTime) {
        TLFormItem *item = [[TLFormItem alloc] initWithFrame:CGRectMake(0.f, self.yOffSet+TLDETAILVIEW_V_GAP, CGRectGetWidth(self.frame), 40.f) itemData:@{@"LABEL_NAME":@"上市时间：",@"LABEL_VALUE":publishTime}];
        item.frame = item.itemFrame;
        [self.viewContentScroll addSubview:item];
        
        self.yOffSet = self.yOffSet + CGRectGetHeight(item.frame) + TLDETAILVIEW_V_GAP;
        
    }
    
    NSString *seatCount = detailDto.seatCount;
    if (seatCount) {
        TLFormItem *item = [[TLFormItem alloc] initWithFrame:CGRectMake(0.f, self.yOffSet+TLDETAILVIEW_V_GAP, CGRectGetWidth(self.frame), 40.f) itemData:@{@"LABEL_NAME":@"座位数：",@"LABEL_VALUE":seatCount}];
        item.frame = item.itemFrame;
        [self.viewContentScroll addSubview:item];
        
        self.yOffSet = self.yOffSet + CGRectGetHeight(item.frame) + TLDETAILVIEW_V_GAP;
        
        
    }
    
    NSString *color = detailDto.color;
    if (seatCount) {
        TLFormItem *item = [[TLFormItem alloc] initWithFrame:CGRectMake(0.f, self.yOffSet+TLDETAILVIEW_V_GAP, CGRectGetWidth(self.frame), 40.f) itemData:@{@"LABEL_NAME":@"颜色：",@"LABEL_VALUE":color}];
        item.frame = item.itemFrame;
        [self.viewContentScroll addSubview:item];
        
        self.yOffSet = self.yOffSet + CGRectGetHeight(item.frame) + TLDETAILVIEW_V_GAP;

        
    }
    
    

    
    
}

-(void)addCarOtherInfo{
    self.yOffSet  = self.yOffSet + TLDETAILVIEW_H_GAP;
    
    TLGridCellView *cellView0 = [[TLGridCellView alloc] initWithFrame:CGRectMake(0.f, self.yOffSet, self.width, 40.f) items:@[@{@"NAME":@""},@{@"NAME":@"低配"},@{@"NAME":@"高配"}]];
    
    [self.viewContentScroll addSubview:cellView0];
    
    self.yOffSet = self.yOffSet + CGRectGetHeight(cellView0.frame);
    
    
    TLGridCellView *cellView1 = [[TLGridCellView alloc] initWithFrame:CGRectMake(0.f, self.yOffSet, self.width, 40.f) items:@[@{@"NAME":@"价格"},@{@"NAME":detailDto.price_low},@{@"NAME":detailDto.price_high}]];
    
    [self.viewContentScroll addSubview:cellView1];
    
    self.yOffSet = self.yOffSet + CGRectGetHeight(cellView1.frame);
    
    TLGridCellView *cellView2 = [[TLGridCellView alloc] initWithFrame:CGRectMake(0.f, self.yOffSet, self.width, 40.f) items:@[@{@"NAME":@"发动机"},@{@"NAME":detailDto.engine_low},@{@"NAME":detailDto.engine_high}]];
    
    [self.viewContentScroll addSubview:cellView2];
    
    self.yOffSet = self.yOffSet + CGRectGetHeight(cellView2.frame);
    
    TLGridCellView *cellView3 = [[TLGridCellView alloc] initWithFrame:CGRectMake(0.f, self.yOffSet, self.width, 40.f) items:@[@{@"NAME":@"变速箱"},@{@"NAME":detailDto.gearBox_low},@{@"NAME":detailDto.gearBox_high}]];
    
    [self.viewContentScroll addSubview:cellView3];
    
    self.yOffSet = self.yOffSet + CGRectGetHeight(cellView3.frame);
    
    TLGridCellView *cellView4 = [[TLGridCellView alloc] initWithFrame:CGRectMake(0.f, self.yOffSet, self.width, 40.f) items:@[@{@"NAME":@"百公里油耗"},@{@"NAME":detailDto.oilCost_low},@{@"NAME":detailDto.oilCost_high}]];
    
    [self.viewContentScroll addSubview:cellView4];
    
    self.yOffSet = self.yOffSet + CGRectGetHeight(cellView4.frame);
    
    TLGridCellView *cellView5 = [[TLGridCellView alloc] initWithFrame:CGRectMake(0.f, self.yOffSet, self.width, 40.f) items:@[@{@"NAME":@"驱动"},@{@"NAME":detailDto.drive_low},@{@"NAME":detailDto.drive_high}]];
    
    [self.viewContentScroll addSubview:cellView5];
    
    self.yOffSet = self.yOffSet + CGRectGetHeight(cellView5.frame);
    
    TLGridCellView *cellView6 = [[TLGridCellView alloc] initWithFrame:CGRectMake(0.f, self.yOffSet, self.width, 40.f) items:@[@{@"NAME":@"然后标号"},@{@"NAME":detailDto.oilType_low},@{@"NAME":detailDto.oilType_low}]];
    
    [self.viewContentScroll addSubview:cellView6];
    
    self.yOffSet = self.yOffSet + CGRectGetHeight(cellView6.frame);

}



@end
