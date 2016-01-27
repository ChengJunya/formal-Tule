//
//  TLCarServiceDetailView.m
//  TL
//
//  Created by Rainbow on 2/19/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "TLCarServiceDetailView.h"
#import "TLFormItem.h"
#import "TLStarLevel.h"
#import "ZXColorButton.h"
#import "TLCarServiceResult.h"
#import "TLHelper.h"
#import "TLNewServiceViewController.h"
#import "ChatViewController.h"
@interface TLCarServiceDetailView(){
    TLCarServiceResult *detailDto;
}

@end

@implementation TLCarServiceDetailView

- (instancetype)initWithFrame:(CGRect)frame viewData:(id)viewData detailData:(id)detailData{
    detailDto = detailData;
    self = [super initWithFrame:frame viewData:viewData type:@"52"];
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
    [RTLHelper pushViewControllerWithName:@"TLNewServiceViewController" itemData:detailDto block:^(TLNewServiceViewController* obj) {
        obj.operateType = @"2";
    }];
}
-(void)toDelete{
    
}

-(void)addBasicInfo{
    NSString *carType = detailDto.serviceType;
    if (carType) {
        TLFormItem *carTypeItem = [[TLFormItem alloc] initWithFrame:CGRectMake(0.f, self.yOffSet+TLDETAILVIEW_V_GAP, CGRectGetWidth(self.frame), 40.f) itemData:@{@"LABEL_NAME":@"服务类型：",@"LABEL_VALUE":carType}];
        carTypeItem.frame = carTypeItem.itemFrame;
        [self.viewContentScroll addSubview:carTypeItem];
        self.yOffSet = self.yOffSet + CGRectGetHeight(carTypeItem.frame) + TLDETAILVIEW_V_GAP;
    }
    
    NSString *startLevel = detailDto.rank;
    
    if (startLevel) {
        
        TLFormItem *starItem = [[TLFormItem alloc] initWithFrame:CGRectMake(0.f, self.yOffSet+TLDETAILVIEW_V_GAP, CGRectGetWidth(self.frame), 40.f) itemData:@{@"LABEL_NAME":@"评分：",@"LABEL_VALUE":@""}];
        starItem.frame = starItem.itemFrame;
        [self.viewContentScroll addSubview:starItem];
        
        TLStarLevel *levelView = [[TLStarLevel alloc] initWithFrame:CGRectMake(100.f, self.yOffSet+TLDETAILVIEW_V_GAP+5.f, CGRectGetWidth(self.frame)-100-80-TLDETAILVIEW_H_GAP, 30.f) level:5 currentLevel:startLevel.integerValue];
        [self.viewContentScroll addSubview:levelView];
        
        
        UIButton *doStarBtn = [ZXColorButton buttonWithType:EZXBT_BOX_GREEN frame:CGRectMake(CGRectGetWidth(self.frame)-100.f, self.yOffSet+TLDETAILVIEW_V_GAP+5.f, 100-TLDETAILVIEW_H_GAP, 28) title:@"我要评分" font:FONT_14 block:^{
            if (self.StarBlock) {
                self.StarBlock(detailDto);
            }
        }];
        [self.viewContentScroll addSubview:doStarBtn];
        
        self.yOffSet = self.yOffSet + CGRectGetHeight(levelView.frame) + TLDETAILVIEW_V_GAP;
    }

    
    
    
    NSString *city = detailDto.address;
    if (city) {
        TLFormItem *cityItem = [[TLFormItem alloc] initWithFrame:CGRectMake(0.f, self.yOffSet+TLDETAILVIEW_V_GAP, CGRectGetWidth(self.frame), 40.f) itemData:@{@"LABEL_NAME":@"所在地：",@"LABEL_VALUE":city}];
        cityItem.frame = cityItem.itemFrame;
        [self.viewContentScroll addSubview:cityItem];
        self.yOffSet = self.yOffSet + CGRectGetHeight(cityItem.frame) + TLDETAILVIEW_V_GAP;
    }
    
    NSString *carContent = detailDto.serviceDesc;
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
    
    if (detailDto.user.voipAccount==nil) {
        [GHUDAlertUtils toggleMessage:@"店主信息不全无法联系！"];
        return;
    }
    
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
