//
//  TLCarRentDetailView.m
//  TL
//
//  Created by Rainbow on 2/19/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "TLCarRentDetailView.h"
#import "TLFormItem.h"
#import "TLViewCarRectResultDTO.h"
#import "TLNewCarRentViewController.h"
#import "TLHelper.h"
@interface TLCarRentDetailView(){
    TLViewCarRectResultDTO *detailDto;
}

@end

@implementation TLCarRentDetailView
- (instancetype)initWithFrame:(CGRect)frame viewData:(id)viewData detailData:(id)detailData{
    detailDto = detailData;
    self = [super initWithFrame:frame viewData:viewData type:@"7"];
    if (self) {
        
    }
    return self;
}
-(void)setUpViews{
    
    [self addImageView];
    
    [self addUserIcon];
    [self addTitle];
    [self addPublishDate];
    //[self addCity];
    [self addInfoView];
    [self validateYOffSet];
    [self addOperButtons];
    [self addBasicInfo];


    //[self addTextContent];
    [self addOperBtns];
    
    
}

-(void)toUpdate{
    [RTLHelper pushViewControllerWithName:@"TLNewCarRentViewController" itemData:detailDto block:^(TLNewCarRentViewController* obj) {
        obj.operateType = @"2";
    }];
}
-(void)toDelete{
    
}

-(void)addBasicInfo{
    NSString *carType = detailDto.carType;
    if (carType) {
        TLFormItem *carTypeItem = [[TLFormItem alloc] initWithFrame:CGRectMake(0.f, self.yOffSet+TLDETAILVIEW_V_GAP, CGRectGetWidth(self.frame), 40.f) itemData:@{@"LABEL_NAME":@"车型：",@"LABEL_VALUE":carType}];
        carTypeItem.frame = carTypeItem.itemFrame;
        [self.viewContentScroll addSubview:carTypeItem];
        self.yOffSet = self.yOffSet + CGRectGetHeight(carTypeItem.frame) + TLDETAILVIEW_V_GAP;
    }
    
    NSString *runKm = detailDto.driveDistance;

    if (runKm) {
        TLFormItem *runKmItem = [[TLFormItem alloc] initWithFrame:CGRectMake(0.f, self.yOffSet+TLDETAILVIEW_V_GAP, CGRectGetWidth(self.frame), 40.f) itemData:@{@"LABEL_NAME":@"行驶公里：",@"LABEL_VALUE":runKm}];
        runKmItem.frame = runKmItem.itemFrame;
        [self.viewContentScroll addSubview:runKmItem];
        
        
        self.yOffSet = self.yOffSet + CGRectGetHeight(runKmItem.frame) + TLDETAILVIEW_V_GAP;
    }
    

    NSString *rentType = detailDto.rentType;
    if (rentType) {
        TLFormItem *rentTypeItem = [[TLFormItem alloc] initWithFrame:CGRectMake(0.f, self.yOffSet+TLDETAILVIEW_V_GAP, CGRectGetWidth(self.frame), 40.f) itemData:@{@"LABEL_NAME":@"租赁方式：",@"LABEL_VALUE":rentType}];
        rentTypeItem.frame = rentTypeItem.itemFrame;
        [self.viewContentScroll addSubview:rentTypeItem];
        
        self.yOffSet = self.yOffSet + CGRectGetHeight(rentTypeItem.frame) + TLDETAILVIEW_V_GAP;
    }
    
   
    NSString *city = detailDto.address;
    if (city) {
        TLFormItem *cityItem = [[TLFormItem alloc] initWithFrame:CGRectMake(0.f, self.yOffSet+TLDETAILVIEW_V_GAP, CGRectGetWidth(self.frame), 40.f) itemData:@{@"LABEL_NAME":@"所在地：",@"LABEL_VALUE":city}];
        cityItem.frame = cityItem.itemFrame;
        [self.viewContentScroll addSubview:cityItem];
        self.yOffSet = self.yOffSet + CGRectGetHeight(cityItem.frame) + TLDETAILVIEW_V_GAP;
    }
    
    NSString *carContent = detailDto.carDesc;
    if (carContent) {
        TLFormItem *activityContentItem = [[TLFormItem alloc] initWithFrame:CGRectMake(0.f, self.yOffSet+TLDETAILVIEW_V_GAP, CGRectGetWidth(self.frame), 120.f) itemData:@{@"LABEL_NAME":@"车辆描述：",@"LABEL_VALUE":carContent}];
        activityContentItem.frame = activityContentItem.itemFrame;
        [self.viewContentScroll addSubview:activityContentItem];
        self.yOffSet = self.yOffSet + CGRectGetHeight(activityContentItem.frame) + TLDETAILVIEW_V_GAP;
    }
    
}

-(void)addOperBtns{
    UIButton *ctBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.f, self.yOffSet, CGRectGetWidth(self.frame), 40.f)];
    [ctBtn setTitle:@"联系出租人" forState:UIControlStateNormal];
    [ctBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [ctBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    ctBtn.titleLabel.font = FONT_18B;
 [ctBtn addTarget:self action:@selector(ctBtnHander:) forControlEvents:UIControlEventTouchUpInside];
    [self.viewContentScroll addSubview:ctBtn];
    
    
    self.yOffSet = self.yOffSet + CGRectGetHeight(ctBtn.frame) + TLDETAILVIEW_V_GAP;
}


-(void)ctBtnHander:(UIButton*)btn{
    
    
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",detailDto.userPhone];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self addSubview:callWebview];
    
}
@end
