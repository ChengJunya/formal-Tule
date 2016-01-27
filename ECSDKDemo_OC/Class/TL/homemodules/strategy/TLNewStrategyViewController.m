//
//  TLNewStrategyViewController.m
//  TL
//
//  Created by Rainbow on 2/13/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "TLNewStrategyViewController.h"
#import "TLModuleDataHelper.h"
#import "TLAddTripRequestDTO.h"
#import "BaseDTOModel.h"

@interface TLNewStrategyViewController ()
@end

@implementation TLNewStrategyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"写攻略";
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navBarHidden = NO;
    self.navBackItemHidden = NO;
    
    self.navView.actionBtns = @[[self addPublishActionBtn]];
}

- (UIButton*)addPublishActionBtn
{
    
    //    UIImage *backImage = [UIImage imageNamed:@"ico_backon"];
    UIButton *actionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    actionBtn.frame = CGRectMake(0.f, 0.f, 44.f, 44.f);
    [actionBtn setTitleColor:COLOR_NAV_TEXT forState:UIControlStateNormal];
    [actionBtn setTitleColor:COLOR_BTN_BOX_GRAY_TEXT forState:UIControlStateHighlighted];
    [actionBtn setTitle:@"发表" forState:UIControlStateNormal];
    actionBtn.titleLabel.font = FONT_14B;
    //[actionBtn setImage:[UIImage imageNamed:@"more_xiaoxi"] forState:UIControlStateNormal];
    //    [actionBtn setImage:[UIImage imageNamed:@"ico_backon" ] forState:UIControlStateHighlighted];
    [actionBtn addTarget:self action:@selector(publishBtnHandler) forControlEvents:UIControlEventTouchUpInside];
    return actionBtn;
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
    
    /**
     @property(nonatomic,copy) NSString *title;
     @property(nonatomic,copy) NSString *cityId;
     @property(nonatomic,copy) NSString *content;
     @property(nonatomic,copy) NSString *isTop; //0 1
     @property(nonatomic,copy) NSArray *userImage;
     @property(nonatomic,copy) NSString *type;//1 2 3
     */
    TLAddTripRequestDTO *tripRequestDTO = [[TLAddTripRequestDTO alloc] init];
    tripRequestDTO.title = formData[@"title"];
    tripRequestDTO.cityId = formData[@"cityId"];
    tripRequestDTO.content = formData[@"content"];
    tripRequestDTO.isTop = formData[@"isTop"];
    tripRequestDTO.userImage = formData[@"images"];
    tripRequestDTO.type = MODULE_STRATEGY_TYPE;
    tripRequestDTO.operateType = self.operateType;
    tripRequestDTO.objId = self.detailDto.travelId.length>0?self.detailDto.travelId:@"";

    

    [GHUDAlertUtils toggleLoadingInView:self.view];
    [GTLModuleDataHelper addTrip:tripRequestDTO requestArray:self.requestArray block:^(id obj, BOOL ret) {
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
