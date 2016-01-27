//
//  TLNewWaybookNodeViewController.m
//  TL
//
//  Created by Rainbow on 2/16/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "TLNewWaybookNodeViewController.h"
#import "TLAddTripRequestDTO.h"
#import "TLModuleDataHelper.h"
#import "TLIsTopRequestDTO.h"
#import "TLTripDataDTO.h"
#import "TLIsTopResultDTO.h"
#import "TLAddBookNodeRequestDTO.h"
@interface TLNewWaybookNodeViewController (){
    TLTripDataDTO *dto;
}

@end

@implementation TLNewWaybookNodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.type.integerValue==2) {
        self.title = @"写节点";
    }else if (self.type.integerValue==3){
        self.title = @"写游记";
    }
    
    dto = self.itemData;
    [self setUIByDto:dto];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)getIsTop{
    TLIsTopRequestDTO *requestDto = [[TLIsTopRequestDTO alloc] init];
    requestDto.objId = dto.travelId;
    requestDto.type = self.type;
    
    WEAK_SELF(self);
    [GHUDAlertUtils toggleLoadingInView:self.view];
    [GTLModuleDataHelper isTop:requestDto requestArray:self.requestArray block:^(id obj, BOOL ret) {
        
        [GHUDAlertUtils hideLoadingInView:self.view];
        TLIsTopResultDTO *result = obj;
        if (ret) {
            NSInteger isTop = result.isTop.integerValue;
            [weakSelf publishByIsTop:isTop];
        }else{
            
        }
    }];

}


-(void)publishByIsTop:(NSInteger)isTop{
        NSDictionary *formData = [self getFormData];
    if (isTop==1&&[formData[@"isTop"] isEqualToString:@"1"]) {//已经置顶
        [GHUDAlertUtils toggleMessage:@"您已经置顶"];
    }else{//可以置顶

        /**
         @property(nonatomic,copy) NSString *title;
         @property(nonatomic,copy) NSString *cityId;
         @property(nonatomic,copy) NSString *content;
         @property(nonatomic,copy) NSString *isTop; //0 1
         @property(nonatomic,copy) NSArray *userImage;
         @property(nonatomic,copy) NSString *type;//1 2 3
         */
        TLAddBookNodeRequestDTO *tripRequestDTO = [[TLAddBookNodeRequestDTO alloc] init];
        tripRequestDTO.cityId = formData[@"cityId"];
        tripRequestDTO.content = formData[@"content"];
        tripRequestDTO.isTop = formData[@"isTop"];
        tripRequestDTO.userImage = formData[@"images"];
        tripRequestDTO.travelId = dto.travelId;
        tripRequestDTO.operateType = self.operateType;
        tripRequestDTO.objId = self.detailDto.travelId.length>0?self.detailDto.travelId:@"";
        
        
        
        
        [GHUDAlertUtils toggleLoadingInView:self.view];
        [GTLModuleDataHelper addWayBookNode:tripRequestDTO requestArray:self.requestArray block:^(id obj, BOOL ret) {
            
            [GHUDAlertUtils hideLoadingInView:self.view];
            ResponseDTO *response = obj;
            if (ret) {
                [GHUDAlertUtils toggleMessage:@"发表成功"];
                [self resetUI];
            }else{
                [GHUDAlertUtils toggleMessage:response.resultDesc];
                
            }
        }];

    }
}

-(void)publishBtnHandler{
    
    
    /**
     *NSDictionary *formData = @{
     @"title":titleField.text,
     @"isTop":isTop,
     @"cityId":cityId,
     @"content":contentLabel.text,
     @"images":imageDic};
     */
    NSDictionary *formData = [self getFormData];
    if (formData==nil) {
        return;
    }
    
    [self getIsTop];
    
}



@end
