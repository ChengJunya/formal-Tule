//
//  TLDetailCarInfoViewController.m
//  TL
//
//  Created by Rainbow on 2/19/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "TLDetailCarInfoViewController.h"
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

#import "CoreData+MagicalRecord.h"
#import "TLTripDataEntity.h"
#import "TLTripTravelEntity.h"
#import "TLTripDetailEntity.h"
#import "TLImageEntity.h"
#import "TLTripUserEntity.h"

#import "TLListCarEntity.h"
#import "TLCarDetailEntity.h"


@interface TLDetailCarInfoViewController ()

@property (nonatomic,strong) TLCarDEtailResultDTO *detailDto;

@end

@implementation TLDetailCarInfoViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    [self getDetailData];
}


-(void)addDetailView{
    if ([self.view viewWithTag:1503211745]) {
        [[self.view viewWithTag:1503211745] removeFromSuperview];
    }
    
    TLTripDetailDTO *tripDetailDto = [[TLTripDetailDTO alloc] init];
    tripDetailDto.travelId = self.detailDto.carId;
    tripDetailDto.cityId = @"";
    tripDetailDto.cityName = @"";
    tripDetailDto.title = self.detailDto.carType;
    tripDetailDto.createTime = self.detailDto.createTime;
    tripDetailDto.viewCount = @"";
    tripDetailDto.commentCount = @"";
    tripDetailDto.collectCount = @"";
    tripDetailDto.content = self.detailDto.carDesc;
    tripDetailDto.images = self.detailDto.images;
    tripDetailDto.user = nil;
    
    
    
    //self.title = @"新车资讯";
    TLCarInfoDetailView *detailView = [[TLCarInfoDetailView alloc] initWithFrame:CGRectMake(0.f, NAVIGATIONBAR_HEIGHT+STATUSBAR_HEIGHT, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-NAVIGATIONBAR_HEIGHT-STATUSBAR_HEIGHT) viewData:tripDetailDto detailData:self.detailDto];
    
    detailView.MoreImageBlock = ^(){
        [self initTLPhotoBrowser];
        
    };
    detailView.CommentItemBlock = ^(){
        [self addComment];
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

-(void)downloadAction{
    TLListCarDTO *itemDTO = self.itemData;
    
    
    NSArray *dataArray = [TLListCarEntity MR_findByAttribute:@"carId" withValue:itemDTO.carId];
    if (dataArray.count>0) {
        [GHUDAlertUtils toggleMessage:@"已经下载到本地！"];
        return;
    }
    
   
    
    TLListCarEntity *tripDataEndity = [TLListCarEntity MR_createEntity];
    tripDataEndity.carId = itemDTO.carId;
    tripDataEndity.carType = itemDTO.carType;
    tripDataEndity.priceRange = itemDTO.priceRange;
    tripDataEndity.publishTime = itemDTO.publishTime;
    tripDataEndity.editor = itemDTO.editor;
    tripDataEndity.createTime = itemDTO.createTime;
    tripDataEndity.carImageUrl = itemDTO.carImageUrl;
    
    
    
   
    
    
    TLCarDetailEntity *tripDetailEntity = [TLCarDetailEntity MR_createEntity];
    tripDetailEntity.carId = _detailDto.carId;
    tripDetailEntity.carType = _detailDto.carType;
    //tripDetailEntity.oilCost = _detailDto.oilCost;
    //tripDetailEntity.priceRange = _detailDto.priceRange;
    tripDetailEntity.publishTime = _detailDto.publishTime;
    tripDetailEntity.editor = _detailDto.editor;
    tripDetailEntity.createTime = _detailDto.createTime;
    tripDetailEntity.carDesc = _detailDto.carDesc;
    
    
    





    tripDetailEntity.carMaker = _detailDto.carMaker;
    tripDetailEntity.carBrand = _detailDto.carBrand;
    tripDetailEntity.seatCount = _detailDto.seatCount;
    tripDetailEntity.color = _detailDto.color;
    tripDetailEntity.price_low = _detailDto.price_low;
    tripDetailEntity.engine_low = _detailDto.engine_low;
    tripDetailEntity.gearBox_low = _detailDto.gearBox_low;
    tripDetailEntity.oilCost_low = _detailDto.oilCost_low;
    tripDetailEntity.drive_low = _detailDto.drive_low;
    tripDetailEntity.oilType_low = _detailDto.oilType_low;
    tripDetailEntity.price_high = _detailDto.price_high;
    tripDetailEntity.engine_high = _detailDto.engine_high;
    tripDetailEntity.gearBox_high = _detailDto.gearBox_high;
    tripDetailEntity.oilCost_high = _detailDto.oilCost_high;
    tripDetailEntity.drive_high = _detailDto.drive_high;
    tripDetailEntity.oilType_high = _detailDto.oilType_high;
    tripDetailEntity.viewCount = _detailDto.viewCount;
    tripDetailEntity.carEvalDesc = _detailDto.carEvalDesc;

    
    
    
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

-(void)communicateAction{
    [self addComment];
}

-(void)collectAction{
    [self addCollect];
}

-(void)shareAction{
    
    
    NSString *imageUrl = [NSString stringWithFormat:@"%@%@",TL_SERVER_BASE_URL,[self.detailDto.images[0] imageUrl]];
    
    TLShareDTO *shareDto = [[TLShareDTO alloc] init];
    shareDto.shareUrl = UMSOCIAL_WXAPP_URL;//obj.shareUrl;
    shareDto.shareDesc = self.detailDto.carDesc.length>50?[self.detailDto.carDesc substringToIndex:49]:self.detailDto.carDesc;//self.detailDto.carDesc;//obj.shareDesc;
    shareDto.shareTitle = self.detailDto.carType;//obj.title;
    shareDto.shareImageUrl = imageUrl;//obj.imageUrl;
    shareDto.patAwardId = @"";//obj.patAwardId;
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SHARE object:shareDto];
}

-(void)getDetailData{
    WEAK_SELF(self);
    TLCarDetailRequestDTO *requestDTO = [[TLCarDetailRequestDTO alloc] init];
    TLListCarDTO *itemDTO = self.itemData;
    requestDTO.carId = itemDTO.carId;
    requestDTO.dataType = self.dataType;
    
    [GHUDAlertUtils toggleLoadingInView:self.view];
    [GTLModuleDataHelper getNewCarDetail:requestDTO requestArray:self.requestArray block:^(id obj, BOOL ret) {
        
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
    TLListCarDTO *itemDTO = self.itemData;
    requestDTO.objId = itemDTO.carId;
    requestDTO.type = @"5";
    
    
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
    
    NSDictionary *itemData = @{@"travelId":self.detailDto.carId,@"type":MODULE_CARINFO_INFO_TYPE};
    
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
@end
