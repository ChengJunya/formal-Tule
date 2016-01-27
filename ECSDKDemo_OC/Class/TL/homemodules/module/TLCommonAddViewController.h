//
//  TLCommonAddViewController.h
//  TL
//
//  Created by Rainbow on 2/16/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "SuperViewController.h"
#import "TLTripDataDTO.h"
#import "TLTripDetailDTO.h"
@interface TLCommonAddViewController : SuperViewController
@property (nonatomic,strong) NSString *operateType;//1-录入 2-修改
@property (nonatomic,strong) TLTripDetailDTO *detailDto;
@property (nonatomic,strong) NSString *type;//1-攻略
/**
 *NSDictionary *formData = @{
 @"title":titleField.text,
 @"isTop":isTop,
 @"cityId":cityId,
 @"content":contentLabel.text,
 @"images":imageDic};
 */
-(NSDictionary *)getFormData;
- (void)publishBtnHandler;
-(void)resetUI;
-(void)setUIByDto:(TLTripDataDTO*)tripDto;
@end
