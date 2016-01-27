//
//  TLStoreDetailViewController.m
//  TL
//
//  Created by Rainbow on 2/8/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "TLStoreDetailViewController.h"
#import "TLStoreDetailView.h"
#import "TLPhotoBrowserViewController.h"
#import "TLStarLevel.h"
#import "TLTripDetailDTO.h"
#import "TLListMerchantDetailResultDTO.h"
#import "TLShareDTO.h"
#import "TLListMerchantDetailRequestDTO.h"
#import "TLStoreDTO.h"
#import "TLModuleDataHelper.h"
#import "TLSaveCollectRequestDTO.h"


#import "TLPhotoBrowserViewController.h"
#import "TLCarCommentDetailView.h"
#import "TLPhotoBrowserViewController.h"
#import "TLCarInfoDetailView.h"
#import "TLGroupActivityDetailView.h"
#import "TLPhotoBrowserViewController.h"
#import "TLShareDTO.h"
#import "TLActivityDetailDTO.h"
#import "TLActivityDetailRequestDTO.h"
#import "TLActivityDTO.h"
#import "TLTripDetailDTO.h"
#import "TLModuleDataHelper.h"
#import "TLTripDetailDTO.h"
#import "TLCarDEtailResultDTO.h"
#import "TLListCarDTO.h"
#import "TLCarEvalDetailResultDTO.h"
#import "TLCarEvalutionDTO.h"
#import "TLSecondGoodsDTO.h"
#import "TLCarServiceDTO.h"


#import "CoreData+MagicalRecord.h"
#import "TLTripDataEntity.h"
#import "TLTripTravelEntity.h"
#import "TLTripDetailEntity.h"
#import "TLImageEntity.h"
#import "TLTripUserEntity.h"
#import "TLStoreDetailEntity.h"
#import "TLStoreEntity.h"


@interface TLStoreDetailViewController ()
@property (nonatomic,strong) UIView *starCommentView;
@property (nonatomic,assign) NSUInteger currentStarLevel;
@property (nonatomic,strong) TLListMerchantDetailResultDTO *detailDto;
@end

@implementation TLStoreDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self getDetailData];
}


-(void)addDetailView{
    if ([self.view viewWithTag:1503211745]) {
        [[self.view viewWithTag:1503211745] removeFromSuperview];
    }
    
    TLTripDetailDTO *tripDetailDto = [[TLTripDetailDTO alloc] init];
    tripDetailDto.travelId = self.detailDto.merchantId;
    tripDetailDto.cityId = @"";
    tripDetailDto.cityName = @"";
    tripDetailDto.title = self.detailDto.merchantId;
    tripDetailDto.createTime = self.detailDto.createTime;
    tripDetailDto.viewCount = self.detailDto.viewCount;
    tripDetailDto.commentCount = self.detailDto.commentCount;
    tripDetailDto.collectCount = @"";
    tripDetailDto.content = self.detailDto.merchantDesc;
    tripDetailDto.images = self.detailDto.images;
    tripDetailDto.user = nil;
    
    
    //self.title = @"商家详情";
    TLStoreDetailView *detailView = [[TLStoreDetailView alloc] initWithFrame:CGRectMake(0.f, NAVIGATIONBAR_HEIGHT+STATUSBAR_HEIGHT, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-NAVIGATIONBAR_HEIGHT-STATUSBAR_HEIGHT) viewData:tripDetailDto detailData:self.detailDto];
    detailView.tag = 1503211745;
    detailView.MoreImageBlock = ^(){
        [self initTLPhotoBrowser];
        
    };
    detailView.CommentItemBlock = ^(){
        [self addComment];
    };
    detailView.StarBlock = ^(id itemData){
        [self starComment:itemData];
    };
    [self.view addSubview:detailView];
    
    
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navBarHidden = NO;
    self.navBackItemHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)communicateAction{
    [self addComment];
}

-(void)downloadAction{
    TLStoreDTO *itemDTO = self.itemData;
    
    
    NSArray *dataArray = [TLStoreEntity MR_findByAttribute:@"merchantId" withValue:itemDTO.merchantId];
    if (dataArray.count>0) {
        [GHUDAlertUtils toggleMessage:@"已经下载到本地！"];
        return;
    }
    
   
    
    TLStoreEntity *tripDataEndity = [TLStoreEntity MR_createEntity];
    tripDataEndity.merchantId = itemDTO.merchantId;
    tripDataEndity.merchantName = itemDTO.merchantName;
    tripDataEndity.rank = itemDTO.rank;
    tripDataEndity.merchantType = itemDTO.merchantType;
    tripDataEndity.editor = itemDTO.editor;
    tripDataEndity.createTime = itemDTO.createTime;
    tripDataEndity.merchantImageUrl = itemDTO.merchantImageUrl;
    tripDataEndity.distance = itemDTO.distance;
    
    
    
   
    
    TLStoreDetailEntity *tripDetailEntity = [TLStoreDetailEntity MR_createEntity];
    tripDetailEntity.merchantId = _detailDto.merchantId;
    tripDetailEntity.merchantName = _detailDto.merchantName;
    tripDetailEntity.createTime = _detailDto.createTime;
    tripDetailEntity.viewCount = _detailDto.viewCount;
    tripDetailEntity.commentCount = _detailDto.commentCount;
    tripDetailEntity.rank = _detailDto.rank;
    tripDetailEntity.openTime = _detailDto.openTime;
    tripDetailEntity.address = _detailDto.address;
    tripDetailEntity.park = _detailDto.park;
    tripDetailEntity.merchantDesc = _detailDto.merchantDesc;
    tripDetailEntity.merchantIcon = _detailDto.merchantIcon;
    
    
    
    
   
    
    [_detailDto.images enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        TLImageDTO *imageDto = obj;
        TLImageEntity *image = [TLImageEntity MR_createEntity];
        image.imageName = imageDto.imageName;
        image.imageUrl = imageDto.imageUrl;
        [tripDetailEntity addImagesObject:image];
    }];
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError *error) {
        [GHUDAlertUtils toggleMessage:@"下载成功"];
    }];
    

}

-(void)collectAction{
    [self addCollect];
}

-(void)shareAction{
    
    
    NSString *imageUrl = [NSString stringWithFormat:@"%@%@",TL_SERVER_BASE_URL,self.detailDto.images.count==0?@"https://mmbiz.qlogo.cn/mmbiz/8iar9j6LGcQW1SFufDicnDibEFMMmg8VLGMfbB5IDwpgbpONt86vgjeiacWiciaNj2tqsk9uFHeTDT3YiaqCibQVCK9ZibQ/0?wx_fmt=png":[self.detailDto.images[0] imageUrl]];
    
    TLShareDTO *shareDto = [[TLShareDTO alloc] init];
    shareDto.shareUrl = UMSOCIAL_WXAPP_URL;//obj.shareUrl;
    shareDto.shareDesc = self.detailDto.merchantDesc.length>50?[self.detailDto.merchantDesc substringToIndex:49]:self.detailDto.merchantDesc;//self.detailDto.merchantDesc;//obj.shareDesc;
    shareDto.shareTitle = self.detailDto.merchantName;//obj.title;
    shareDto.shareImageUrl = imageUrl;//obj.imageUrl;
    shareDto.patAwardId = @"";//obj.patAwardId;
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SHARE object:shareDto];
}

-(void)getDetailData{
    WEAK_SELF(self);
    TLListMerchantDetailRequestDTO *requestDTO = [[TLListMerchantDetailRequestDTO alloc] init];
    TLStoreDTO *itemDTO = self.itemData;
    requestDTO.merchantId = itemDTO.merchantId;
    requestDTO.dataType = self.dataType;
    
    [GHUDAlertUtils toggleLoadingInView:self.view];
    [GTLModuleDataHelper getStoreDetail:requestDTO requestArray:self.requestArray block:^(id obj, BOOL ret) {
        
        
        
        
        [GHUDAlertUtils hideLoadingInView:self.view];
        if (ret) {
            weakSelf.detailDto = obj;
            [weakSelf addDetailView];
            
        }else{
            ResponseDTO *response = obj;
            [GHUDAlertUtils toggleMessage:response.resultDesc];
        }
    }];
    
}



-(void)addCollect{
    WEAK_SELF(self);
    TLSaveCollectRequestDTO *requestDTO = [[TLSaveCollectRequestDTO alloc] init];
    TLStoreDTO *itemDTO = self.itemData;
    requestDTO.objId = itemDTO.merchantId;
    requestDTO.type = MODULE_STORE_TYPE;
    
    
    [GHUDAlertUtils toggleLoadingInView:self.view];
    [GTLModuleDataHelper addCollect:requestDTO requestArr:self.requestArray block:^(id obj, BOOL ret) {
        
        [GHUDAlertUtils hideLoadingInView:self.view];
        if (ret) {
            [weakSelf addDetailView];
            
        }else{
            ResponseDTO *response = obj;
            [GHUDAlertUtils toggleMessage:response.resultDesc];
        }
    }];
    
}


-(void)addComment{
    
    NSDictionary *itemData = @{@"travelId":self.detailDto.merchantId,@"type":MODULE_STORE_TYPE};
    
    [self pushViewControllerWithName:@"TLCommentViewController" itemData:itemData block:^(id obj) {
        
    }];
}


-(void)initTLPhotoBrowser{
    
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    NSArray *imageURLs = self.detailDto.images;
    [imageURLs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        TLImageDTO *imageDto = obj;
        NSString *imageUrl = [NSString stringWithFormat:@"%@%@",TL_SERVER_BASE_URL,imageDto.imageUrl];
        [photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:imageUrl]]];
    }];
    TLPhotoBrowserViewController *browser = [[TLPhotoBrowserViewController alloc] initWithTLPhotos:photos];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:nc animated:YES completion:nil];
    
    
}



-(void)starComment:(id)itemData{
    [self addStarCommentView];
}

-(void)addStarCommentView{
    CGFloat viewWidth = 220.f;
    CGFloat viewHeight = 130.f;
    CGFloat vGap = 10.f;
    CGFloat hGap = 10.f;
    self.starCommentView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.starCommentView];
    self.starCommentView.backgroundColor = UIColorFromRGBA(0x000000, 0.2f);
    UIView *smallView = [[UIView alloc] initWithFrame:CGRectMake((CGRectWidth(self.starCommentView.frame)-viewWidth)/2, (CGRectGetHeight(self.starCommentView.frame)-viewHeight)/2, viewWidth, viewHeight)];
    smallView.backgroundColor = COLOR_DEF_BG;
    [self.starCommentView addSubview:smallView];
    
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(hGap, vGap, viewWidth-hGap*2, 20.f)];
    titleLabel.font = FONT_16B;
    titleLabel.text = @"点击星星评分：";
    titleLabel.textColor = COLOR_MAIN_TEXT;
    [smallView addSubview:titleLabel];
    
    TLStarLevel *starLevel = [[TLStarLevel alloc] initWithFrame:CGRectMake(hGap, CGRectGetMaxY(titleLabel.frame)+vGap, viewWidth, 40.f) level:5 currentLevel:1];
    starLevel.tag = 201502;
    starLevel.isStarSelect = YES;
    [smallView addSubview:starLevel];
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.f, CGRectGetHeight(smallView.frame)-30.f, viewWidth/2, 30.f)];
    cancelBtn.layer.borderColor = UIColorFromRGBA(0xCCCCCC, 0.5).CGColor;
    cancelBtn.layer.borderWidth = 0.5f;
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(closeViewHandler) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitleColor:COLOR_MAIN_TEXT forState:UIControlStateNormal];
    [smallView addSubview:cancelBtn];
    
    
    UIButton *okBtn = [[UIButton alloc] initWithFrame:CGRectMake(viewWidth/2, CGRectGetHeight(smallView.frame)-30.f, viewWidth/2, 30.f)];
    [okBtn addTarget:self action:@selector(closeViewHandler) forControlEvents:UIControlEventTouchUpInside];
    okBtn.layer.borderColor = UIColorFromRGBA(0xCCCCCC, 0.5).CGColor;
    okBtn.layer.borderWidth = 0.5f;
    [okBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [okBtn setTitle:@"确认" forState:UIControlStateNormal];
    [smallView addSubview:okBtn];
    
}


-(void)closeViewHandler{
    if (self.starCommentView) {
        TLStarLevel *tmpLevel = (TLStarLevel*)[self.starCommentView viewWithTag:201502];
        self.currentStarLevel = tmpLevel.currentLevel;
        [self mackScore:[NSString stringWithFormat:@"%d",self.currentStarLevel]];
        [self.starCommentView removeFromSuperview];
    }
}


-(void)mackScore:(NSString *)level{
    WEAK_SELF(self);
    TLCarServiceMackScoreRequest *requestDTO = [[TLCarServiceMackScoreRequest alloc] init];
    TLStoreDTO *itemDTO = self.itemData;
    requestDTO.merchantId = itemDTO.merchantId;
    requestDTO.score = level;
    
    
    [GHUDAlertUtils toggleLoadingInView:self.view];
    [GTLModuleDataHelper makeStoreScore:requestDTO requestArr:self.requestArray block:^(id obj, BOOL ret) {
        
        
        [GHUDAlertUtils hideLoadingInView:self.view];
        if (ret) {
            [weakSelf getDetailData];
            
        }else{
            ResponseDTO *response = obj;
            [GHUDAlertUtils toggleMessage:response.resultDesc];
        }
    }];
}


@end
