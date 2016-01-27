//
//  TLSecondDetailView.m
//  TL
//
//  Created by Rainbow on 2/20/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "TLSecondDetailView.h"
#import "TLFormItem.h"
#import "TLSecondGoodsResult.h"
#import "TLHelper.h"
#import "ChatViewController.h"
#import "TLNewSecondViewController.h"
@interface TLSecondDetailView(){
    TLSecondGoodsResult *detailDto;
}

@end

@implementation TLSecondDetailView

- (instancetype)initWithFrame:(CGRect)frame viewData:(id)viewData detailData:(id)detailData{
    detailDto = detailData;
    self = [super initWithFrame:frame viewData:viewData type:@"5"];
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
    [self addOperButtons];
    [self addBasicInfo];

    //[self validateYOffSet];
    //[self addTextContent];
    [self addOperBtns];
    
    
    
}


-(void)toUpdate{
    [RTLHelper pushViewControllerWithName:@"TLNewSecondViewController" itemData:detailDto block:^(TLNewSecondViewController* obj) {
        obj.operationType = @"2";
    }];
}
-(void)toDelete{
    
}

-(void)addBasicInfo{
    NSString *title = detailDto.title;
    if (title) {
        TLFormItem *titleItem = [[TLFormItem alloc] initWithFrame:CGRectMake(0.f, self.yOffSet+TLDETAILVIEW_V_GAP, CGRectGetWidth(self.frame), 40.f) itemData:@{@"LABEL_NAME":@"宝贝名称：",@"LABEL_VALUE":title}];
        titleItem.frame = titleItem.itemFrame;
        [self.viewContentScroll addSubview:titleItem];
        self.yOffSet = self.yOffSet + CGRectGetHeight(titleItem.frame) + TLDETAILVIEW_V_GAP;
    }
    
    NSString *newPercent = detailDto.oldDesc;
    
    if (newPercent) {
        TLFormItem *newPercentItem = [[TLFormItem alloc] initWithFrame:CGRectMake(0.f, self.yOffSet+TLDETAILVIEW_V_GAP, CGRectGetWidth(self.frame), 40.f) itemData:@{@"LABEL_NAME":@"成色：",@"LABEL_VALUE":newPercent}];
        newPercentItem.frame = newPercentItem.itemFrame;
        [self.viewContentScroll addSubview:newPercentItem];
        
        
        self.yOffSet = self.yOffSet + CGRectGetHeight(newPercentItem.frame) + TLDETAILVIEW_V_GAP;
    }
    
    
    NSString *price = detailDto.price;
    if (price) {
        TLFormItem *priceItem = [[TLFormItem alloc] initWithFrame:CGRectMake(0.f, self.yOffSet+TLDETAILVIEW_V_GAP, CGRectGetWidth(self.frame), 40.f) itemData:@{@"LABEL_NAME":@"价钱：",@"LABEL_VALUE":price}];
        priceItem.frame = priceItem.itemFrame;
        [self.viewContentScroll addSubview:priceItem];
        
        self.yOffSet = self.yOffSet + CGRectGetHeight(priceItem.frame) + TLDETAILVIEW_V_GAP;
    }
    
    
    NSString *city = detailDto.address;
    if (city) {
        TLFormItem *cityItem = [[TLFormItem alloc] initWithFrame:CGRectMake(0.f, self.yOffSet+TLDETAILVIEW_V_GAP, CGRectGetWidth(self.frame), 40.f) itemData:@{@"LABEL_NAME":@"所在地：",@"LABEL_VALUE":city}];
        cityItem.frame = cityItem.itemFrame;
        [self.viewContentScroll addSubview:cityItem];
        self.yOffSet = self.yOffSet + CGRectGetHeight(cityItem.frame) + TLDETAILVIEW_V_GAP;
    }
    
    NSString *carContent = detailDto.goodsDesc;
    if (carContent) {
        TLFormItem *activityContentItem = [[TLFormItem alloc] initWithFrame:CGRectMake(0.f, self.yOffSet+TLDETAILVIEW_V_GAP, CGRectGetWidth(self.frame), 120.f) itemData:@{@"LABEL_NAME":@"车辆描述：",@"LABEL_VALUE":carContent}];
        activityContentItem.frame = activityContentItem.itemFrame;
        [self.viewContentScroll addSubview:activityContentItem];
        self.yOffSet = self.yOffSet + CGRectGetHeight(activityContentItem.frame) + TLDETAILVIEW_V_GAP;
    }
    
}

-(void)addOperBtns{
    UIButton *ctBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.f, self.yOffSet, CGRectGetWidth(self.frame), 40.f)];
    [ctBtn setTitle:@"联系店主" forState:UIControlStateNormal];
    [ctBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [ctBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    ctBtn.titleLabel.font = FONT_18B;
    [self.viewContentScroll addSubview:ctBtn];
     [ctBtn addTarget:self action:@selector(ctBtnHander:) forControlEvents:UIControlEventTouchUpInside];
    
    self.yOffSet = self.yOffSet + CGRectGetHeight(ctBtn.frame) + TLDETAILVIEW_V_GAP;
}


-(void)ctBtnHander:(UIButton*)btn{
    
    
    [RTLHelper pushViewControllerWithName:@"ChatViewController" itemData:@{@"SESSION_ID":detailDto.user.voipAccount} block:^(ChatViewController* obj) {
        obj.title = detailDto.user.userName;
    }];
//    
//    
//    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",detailDto.userPhone];
//    UIWebView * callWebview = [[UIWebView alloc] init];
//    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
//    [self addSubview:callWebview];
    
}
@end
