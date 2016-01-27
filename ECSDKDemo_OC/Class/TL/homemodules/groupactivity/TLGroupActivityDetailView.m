//
//  TLGroupActivityDetailView.m
//  TL
//
//  Created by Rainbow on 2/16/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "TLGroupActivityDetailView.h"
#import "ImagePlayerView.h"
#import "RIconTextBtn.h"
#import "TLTuleAdView.h"
#import "TLFormItem.h"
#import "TLUserListView.h"
#import "TLTripDetailExtDTO.h"
#import "TLActivityDetailDTO.h"
#import "TLModuleDataHelper.h"
#import "TLActivityParticipateRequestDTO.h"
#import "UserDataHelper.h"
#import "UserInfoDTO.h"
#import "TLNewGroupActivityViewController.h"
#import "TLHelper.h"

@interface TLGroupActivityDetailView(){
    TLActivityDetailDTO *detailDto;
}



@end
@implementation TLGroupActivityDetailView

- (instancetype)initWithFrame:(CGRect)frame viewData:(id)viewData detailData:(id)detailData{
    detailDto = detailData;
    self = [super initWithFrame:frame viewData:viewData type:@"4"];
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
    //[self addTextContent];
    [self addActivityInfo];
    [self addUserList];
    [self addOperBtns];
}


-(void)toUpdate{
    [RTLHelper pushViewControllerWithName:@"TLNewGroupActivityViewController" itemData:detailDto block:^(TLNewGroupActivityViewController* obj) {
        obj.operateType = @"2";//修改
    }];
}

-(void)toDelete{
    
}


-(void)addActivityInfo{
    
   
    
    
    
    NSString *city = detailDto.destnation;
    if (city) {
        TLFormItem *cityItem = [[TLFormItem alloc] initWithFrame:CGRectMake(0.f, self.yOffSet+TLDETAILVIEW_V_GAP, CGRectGetWidth(self.frame), 40.f) itemData:@{@"LABEL_NAME":@"地点：",@"LABEL_VALUE":city}];
        cityItem.frame = cityItem.itemFrame;
        [self.viewContentScroll addSubview:cityItem];
        self.yOffSet = self.yOffSet + CGRectGetHeight(cityItem.frame) + TLDETAILVIEW_V_GAP;
    }
    
    
    NSString *activityDate = detailDto.costAverage;
    if (activityDate) {
        TLFormItem *activityDateItem = [[TLFormItem alloc] initWithFrame:CGRectMake(0.f, self.yOffSet+TLDETAILVIEW_V_GAP, CGRectGetWidth(self.frame), 40.f) itemData:@{@"LABEL_NAME":@"消费：",@"LABEL_VALUE":activityDate}];
        activityDateItem.frame = activityDateItem.itemFrame;
        [self.viewContentScroll addSubview:activityDateItem];
        self.yOffSet = self.yOffSet + CGRectGetHeight(activityDateItem.frame) + TLDETAILVIEW_V_GAP;
    }
    
    
    NSString *userCount = detailDto.personNum;
    if (userCount) {
        TLFormItem *userCountItem = [[TLFormItem alloc] initWithFrame:CGRectMake(0.f, self.yOffSet+TLDETAILVIEW_V_GAP, CGRectGetWidth(self.frame), 40.f) itemData:@{@"LABEL_NAME":@"人数：",@"LABEL_VALUE":userCount}];
        userCountItem.frame = userCountItem.itemFrame;
        [self.viewContentScroll addSubview:userCountItem];
        self.yOffSet = self.yOffSet + CGRectGetHeight(userCountItem.frame) + TLDETAILVIEW_V_GAP;
    }
    
    
    NSString *activityContent = detailDto.desc;
    if (activityContent) {
        TLFormItem *activityContentItem = [[TLFormItem alloc] initWithFrame:CGRectMake(0.f, self.yOffSet+TLDETAILVIEW_V_GAP, CGRectGetWidth(self.frame), 120.f) itemData:@{@"LABEL_NAME":@"活动描述：",@"LABEL_VALUE":activityContent}];
        activityContentItem.frame = activityContentItem.itemFrame;
        [self.viewContentScroll addSubview:activityContentItem];
        self.yOffSet = self.yOffSet + CGRectGetHeight(activityContentItem.frame) + TLDETAILVIEW_V_GAP;
    }
    

}

-(void)addUserList{
    
    TLFormItem *userCountItem = [[TLFormItem alloc] initWithFrame:CGRectMake(0.f, self.yOffSet+TLDETAILVIEW_V_GAP, CGRectGetWidth(self.frame), 40.f) itemData:@{@"LABEL_NAME":@"已报名的人",@"LABEL_VALUE":@""}];
    userCountItem.frame = userCountItem.itemFrame;
    [self.viewContentScroll addSubview:userCountItem];
    self.yOffSet = self.yOffSet + CGRectGetHeight(userCountItem.frame)+TLDETAILVIEW_V_GAP;
    
    TLUserListView *userListView = [[TLUserListView alloc] initWithFrame:CGRectMake(0.f, self.yOffSet, CGRectGetWidth(self.frame), 120.f) itemData:detailDto.enrollUsers];
    [self.viewContentScroll addSubview:userListView];
    self.yOffSet = self.yOffSet + CGRectGetHeight(userListView.frame) + TLDETAILVIEW_V_GAP;
}

-(void)addOperBtns{
    UIButton *ctBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.f, self.yOffSet, CGRectGetWidth(self.frame)/2, 30.f)];
    [ctBtn setTitle:@"联系召集人" forState:UIControlStateNormal];
    [ctBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [ctBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    ctBtn.titleLabel.font = FONT_18B;
    [self.viewContentScroll addSubview:ctBtn];
    [ctBtn addTarget:self action:@selector(ctBtnHander:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *inBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)/2, self.yOffSet, CGRectGetWidth(self.frame)/2, 30.f)];
    [inBtn setTitle:@"我要报名" forState:UIControlStateNormal];
    inBtn.titleLabel.font = FONT_18B;
    [inBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [inBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [self.viewContentScroll addSubview:inBtn];
    [inBtn addTarget:self action:@selector(inBtnHander:) forControlEvents:UIControlEventTouchUpInside];
    
    self.yOffSet = self.yOffSet + CGRectGetHeight(ctBtn.frame) + TLDETAILVIEW_V_GAP;
}


-(void)ctBtnHander:(UIButton*)btn{
    
    
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",detailDto.userPhone];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self addSubview:callWebview];
    
}
-(void)inBtnHander:(UIButton*)btn{
    WEAK_SELF(self);
    [GHUDAlertUtils showZXColorAlert:@"是否确定报名此活动？" subTitle:@"" cancleButton:MultiLanguage(comCancel) sureButtonTitle:MultiLanguage(comSure)  COLORButtonType:(RED_BUTTON_TYPE) buttonHeight:35 clickedBlock:^(ZXColorAlert *alert, NSUInteger index) {
        if (index == 1) {
            [weakSelf activityParicipate];
        }
    }];
    
    
    
}

-(void)activityParicipate{
    TLActivityParticipateRequestDTO *request = [[TLActivityParticipateRequestDTO alloc] init];
    request.activityId = detailDto.activityId;
    request.loginId = GUserDataHelper.tlUserInfo.loginId;
    [GHUDAlertUtils toggleLoadingInView:self];
    NSMutableArray *requestArray = [[NSMutableArray alloc] init];
    [GTLModuleDataHelper activityParticipate:request requestArray:requestArray block:^(id obj, BOOL ret) {
        
        
        [GHUDAlertUtils hideLoadingInView:self];
        ResponseDTO *response = obj;
        if (ret) {
            [GHUDAlertUtils toggleMessage:@"报名成功"];
            
        }else{
            [GHUDAlertUtils toggleMessage:response.resultDesc];
            
        }
    }];
}

@end
