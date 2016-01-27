//
//  TLStoreDetailView.m
//  TL
//
//  Created by Rainbow on 2/20/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "TLStoreDetailView.h"
#import "TLFormItem.h"
#import "TLStarLevel.h"
#import "ZXColorButton.h"
#import "TLListMerchantDetailResultDTO.h"
#import "TLImageDTO.h"
#import "TLModuleDataHelper.h"
#import <MapKit/MapKit.h>

@interface TLStoreDetailView(){
    TLListMerchantDetailResultDTO *detailDto;
}

@end

@implementation TLStoreDetailView

- (instancetype)initWithFrame:(CGRect)frame viewData:(id)viewData detailData:(id)detailData{
    detailDto = detailData;
    self = [super initWithFrame:frame viewData:viewData type:@"9"];
    if (self) {
        
    }
    return self;
}
-(void)setUpViews{
    
    [self addImageView];
    
    //[self addUserIcon];
    //[self addTitle];
    //[self addPublishDate];
    //[self addCity];
    //[self addInfoView];
    [self addStoreInfo];
    [self addBasicInfo];
    //[self validateYOffSet];
    //[self addTextContent];
    //[self addOperBtns];
    
    
}


-(void)addStoreInfo{

    //*****end add userImage ******
    NSString *userIconUrl = [NSString stringWithFormat:@"%@%@",TL_SERVER_BASE_URL,detailDto.merchantIcon];

    if (userIconUrl) {
        
        UIImageView *userImageView = [[UIImageView alloc] initWithFrame:CGRectMake(TLDETAILVIEW_H_GAP, self.yOffSet+TLDETAILVIEW_V_GAP, TLDETAILVIEW_USER_IMAGE_HEIGHT, TLDETAILVIEW_USER_IMAGE_HEIGHT)];
        userImageView.layer.borderWidth = 0.5f;
        userImageView.layer.borderColor = [UIColor grayColor].CGColor;
        userImageView.layer.cornerRadius = TLDETAILVIEW_USER_IMAGE_HEIGHT/2;
        [self.viewContentScroll addSubview:userImageView];
        userImageView.layer.masksToBounds = YES;
        
        [userImageView sd_setImageWithURL:[NSURL URLWithString:userIconUrl] placeholderImage:[UIImage imageNamed:@"ico_loading_logo"]];
        
    }
    
    NSString *title = detailDto.merchantName;
    //addtitle ------
    NSDictionary *titleDic = [NSDictionary dictionaryWithObjectsAndKeys:FONT_14B,NSFontAttributeName ,nil];
    CGSize titleStrSize = [title sizeWithAttributes:titleDic];
    
    
    
    //    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:titleStr];
    //
    //    NSRange start = [titleStr rangeOfString:@" - "];
    //
    //    [str addAttribute:NSForegroundColorAttributeName value:COLOR_MAIN_TEXT range:NSMakeRange(0,start.location+start.length)];
    //    [str addAttribute:NSForegroundColorAttributeName value:COLOR_BTN_SOLID_ORANGE_SUFACE range:NSMakeRange(start.location+3,titleStr.length-start.location-start.length)];
    
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(TLDETAILVIEW_H_GAP*2+TLDETAILVIEW_USER_IMAGE_HEIGHT, self.yOffSet+TLDETAILVIEW_V_GAP+(TLDETAILVIEW_USER_IMAGE_HEIGHT-titleStrSize.height)/2, titleStrSize.width, titleStrSize.height)];
    titleLabel.font = FONT_14B;
    titleLabel.text = title;
    titleLabel.textColor = COLOR_MAIN_TEXT;
    [self.viewContentScroll addSubview:titleLabel];
    
    
    UIButton *getInCorrectBtn = [ZXColorButton buttonWithType:EZXBT_BOX_GREEN frame:CGRectMake(CGRectGetWidth(self.frame)-100.f, self.yOffSet+TLDETAILVIEW_V_GAP+(TLDETAILVIEW_USER_IMAGE_HEIGHT-28)/2, 100-TLDETAILVIEW_H_GAP, 28) title:@"纠错" font:FONT_14 block:^{
        [self inCorrectBtnAction];
    }];
    [self.viewContentScroll addSubview:getInCorrectBtn];
    
    
    self.yOffSet = self.yOffSet + TLDETAILVIEW_USER_IMAGE_HEIGHT + TLDETAILVIEW_V_GAP;

}

-(void)inCorrectBtnAction{
    TLMerchantErrorRequestDTO *request = [[TLMerchantErrorRequestDTO alloc] init];
    request.merchantId = detailDto.merchantId;
    [GTLModuleDataHelper merchantError:request requestArr:[NSMutableArray array] block:^(id obj, BOOL ret) {
        ResponseDTO *response = obj;
        [GHUDAlertUtils toggleMessage:response.resultDesc];
    }];
}

-(void)addBasicInfo{
   
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
    
    
    
    TLFormItem *titleItem = [[TLFormItem alloc] initWithFrame:CGRectMake(0.f, self.yOffSet+TLDETAILVIEW_V_GAP, CGRectGetWidth(self.frame), 40.f) itemData:@{@"LABEL_NAME":@"商家信息",@"LABEL_VALUE":@""}];
    titleItem.backgroundColor = COLOR_DEF_BG;
    titleItem.frame = titleItem.itemFrame;
    [self.viewContentScroll addSubview:titleItem];
    self.yOffSet = self.yOffSet + CGRectGetHeight(titleItem.frame) + TLDETAILVIEW_V_GAP;

    
    
    NSString *storeType = detailDto.merchantType;
    
    if (storeType) {
        TLFormItem *storeTypeItem = [[TLFormItem alloc] initWithFrame:CGRectMake(0.f, self.yOffSet+TLDETAILVIEW_V_GAP, CGRectGetWidth(self.frame), 40.f) itemData:@{@"LABEL_NAME":@"商家类型：",@"LABEL_VALUE":storeType}];
        storeTypeItem.frame = storeTypeItem.itemFrame;
        [self.viewContentScroll addSubview:storeTypeItem];
        
        
        self.yOffSet = self.yOffSet + CGRectGetHeight(storeTypeItem.frame) + TLDETAILVIEW_V_GAP;
    }
    
    NSString *phone = detailDto.phone;
    
    if (phone) {
        TLFormItem *phoneItem = [[TLFormItem alloc] initWithFrame:CGRectMake(0.f, self.yOffSet+TLDETAILVIEW_V_GAP, CGRectGetWidth(self.frame)-TLDETAILVIEW_H_GAP-80, 40.f) itemData:@{@"LABEL_NAME":@"联系电话：",@"LABEL_VALUE":phone}];
        phoneItem.frame = phoneItem.itemFrame;
        [self.viewContentScroll addSubview:phoneItem];
        
        UIButton *callBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)-80.f, self.yOffSet+TLDETAILVIEW_V_GAP+5.f, 80-TLDETAILVIEW_H_GAP, 28)];
        [callBtn setBackgroundImage:[UIImage imageNamed:@"tl_store_call"] forState:UIControlStateNormal];
                [callBtn addTarget:self action:@selector(ctBtnHander:) forControlEvents:UIControlEventTouchUpInside];
        [self.viewContentScroll addSubview:callBtn];

        
        self.yOffSet = self.yOffSet + CGRectGetHeight(phoneItem.frame) + TLDETAILVIEW_V_GAP;
    }
    
    
    
    NSString *openTime = detailDto.openTime;
    
    if (openTime) {
        TLFormItem *openTimeItem = [[TLFormItem alloc] initWithFrame:CGRectMake(0.f, self.yOffSet+TLDETAILVIEW_V_GAP, CGRectGetWidth(self.frame), 40.f) itemData:@{@"LABEL_NAME":@"营业时间：",@"LABEL_VALUE":openTime}];
        openTimeItem.frame = openTimeItem.itemFrame;
        [self.viewContentScroll addSubview:openTimeItem];
        
        
        self.yOffSet = self.yOffSet + CGRectGetHeight(openTimeItem.frame) + TLDETAILVIEW_V_GAP;
    }
    
    
   
    
    NSString *city = detailDto.address;
    if (city) {
        TLFormItem *cityItem = [[TLFormItem alloc] initWithFrame:CGRectMake(0.f, self.yOffSet+TLDETAILVIEW_V_GAP, CGRectGetWidth(self.frame)-TLDETAILVIEW_H_GAP-80, 40.f) itemData:@{@"LABEL_NAME":@"所在地：",@"LABEL_VALUE":city}];
        cityItem.frame = cityItem.itemFrame;
        [self.viewContentScroll addSubview:cityItem];
        
        
        UIButton *locationBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)-80.f, self.yOffSet+TLDETAILVIEW_V_GAP+5.f, 80-TLDETAILVIEW_H_GAP, 28)];
        [locationBtn setBackgroundImage:[UIImage imageNamed:@"tl_store_location"] forState:UIControlStateNormal];
        
        [self.viewContentScroll addSubview:locationBtn];

        [locationBtn addTarget:self action:@selector(gotomap) forControlEvents:UIControlEventTouchUpInside];
        
        
        self.yOffSet = self.yOffSet + CGRectGetHeight(cityItem.frame) + TLDETAILVIEW_V_GAP;
    }
    
    NSString *park = detailDto.park.integerValue==0?@"没有停车场":@"有停车场";
    if (park) {
        TLFormItem *parkItem = [[TLFormItem alloc] initWithFrame:CGRectMake(0.f, self.yOffSet+TLDETAILVIEW_V_GAP, CGRectGetWidth(self.frame), 40.f) itemData:@{@"LABEL_NAME":@"停车场：",@"LABEL_VALUE":park}];
        parkItem.frame = parkItem.itemFrame;
        [self.viewContentScroll addSubview:parkItem];
        
        self.yOffSet = self.yOffSet + CGRectGetHeight(parkItem.frame) + TLDETAILVIEW_V_GAP;
    }
    
    
    NSString *carContent = detailDto.merchantDesc;
    if (carContent) {
        TLFormItem *activityContentItem = [[TLFormItem alloc] initWithFrame:CGRectMake(0.f, self.yOffSet+TLDETAILVIEW_V_GAP, CGRectGetWidth(self.frame), 120.f) itemData:@{@"LABEL_NAME":@"商家描述：",@"LABEL_VALUE":carContent}];
        activityContentItem.frame = activityContentItem.itemFrame;
        [self.viewContentScroll addSubview:activityContentItem];
        self.yOffSet = self.yOffSet + CGRectGetHeight(activityContentItem.frame) + TLDETAILVIEW_V_GAP;
    }
    
}

- (void)gotomap{
    WEAK_SELF(self);
    CustomActionSheet *sheet = [[CustomActionSheet alloc] initWithButtonTitles:@[@"高德地图(若未安装高德地图请先装)",@"苹果地图",MultiLanguage(scovcActionCancle)]];
    [sheet setButtonBackGroundImage:[UIImage resizedImage:@"btn_gray_n" leftScale:0.2 topScale:1] forState:(UIControlStateNormal)];
    [sheet setButtonBackGroundImage:[UIImage resizedImage:@"btn_gray_p" leftScale:0.2 topScale:1] forState:(UIControlStateHighlighted)];
    [sheet actionSheetSelectBlock:^(CustomActionSheet *actionSheet, NSUInteger index) {
        if (index == 0) {
            [weakSelf gotoAMap];
        }else if(index == 1){
            [weakSelf gotoAppleMap];
        }
    }];
    [sheet showActionSheetInView:nil];
    
    
    
    
    
   
    
    
    
   
    
    
}

-(void)gotoAMap{
    NSString *urlStr = [NSString stringWithFormat:@"iosamap://navi?sourceApplication=applicationName&backScheme=applicationScheme&poiname=fangheng&poiid=BGVIS&lat=%@&lon=%@&dev=1&style=2",detailDto.latitude,detailDto.longtitude];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    [[UIApplication sharedApplication] openURL:url];
}

-(void)gotoAppleMap{
    //获取当前位置
    MKMapItem *mylocation = [MKMapItem mapItemForCurrentLocation];
    
    //当前经维度
    float currentLatitude=mylocation.placemark.location.coordinate.latitude;
    float currentLongitude=mylocation.placemark.location.coordinate.longitude;
    
    CLLocationCoordinate2D coords1 = CLLocationCoordinate2DMake(currentLatitude,currentLongitude);
    
    
    
    //目的地位置
    
    
    
    CLLocationCoordinate2D coords2 = CLLocationCoordinate2DMake([detailDto.latitude doubleValue],[detailDto.longtitude doubleValue]);
    
    //当前的位置
    MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
    //起点
    //MKMapItem *currentLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coords1 addressDictionary:nil]];
    //目的地的位置
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coords2 addressDictionary:nil]];
    
    toLocation.name = detailDto.address;
    
    NSArray *items = [NSArray arrayWithObjects:currentLocation, toLocation, nil];
    NSDictionary *options = @{ MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsMapTypeKey: [NSNumber numberWithInteger:MKMapTypeStandard], MKLaunchOptionsShowsTrafficKey:@YES };
    //打开苹果自身地图应用，并呈现特定的item
    [MKMapItem openMapsWithItems:items launchOptions:options];
}


-(void)ctBtnHander:(UIButton*)btn{
    
    
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",detailDto.phone];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self addSubview:callWebview];
    
}



@end
