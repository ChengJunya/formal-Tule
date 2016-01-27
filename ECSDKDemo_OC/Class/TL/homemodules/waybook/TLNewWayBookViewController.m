//
//  TLNewWayBookViewController.m
//  TL
//
//  Created by Rainbow on 2/16/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "TLNewWayBookViewController.h"
#import "RIconTextBtn.h"
#import "TLAddTripRequestDTO.h"
#import "ZXTextView.h"
#import "TLModuleDataHelper.h"
#import "TLAddTripResponseDTO.h"
#import "TLTripDataDTO.h"
#import "TLNewWaybookNodeViewController.h"
@interface TLNewWayBookViewController (){
    UITextField *titleField;
    ZXTextView *contentLabel;
}
@property (nonatomic,strong) TLTripDetailDTO *detailDto;
@end

@implementation TLNewWayBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.detailDto = self.itemData;
    if (self.type.integerValue==2) {
        self.title = @"写路书";
    }else if(self.type.integerValue==3){
        self.title = @"写游记";
    }
    [self addAllUIResources];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navBarHidden = NO;
    self.navBackItemHidden = NO;
    
    self.navView.actionBtns = @[[self addPublishActionBtn]];
    
    if (self.operateType.integerValue==2) {
        [self updateUI];
    }
}

- (UIButton*)addPublishActionBtn
{
    
    //    UIImage *backImage = [UIImage imageNamed:@"ico_backon"];
    UIButton *actionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    actionBtn.frame = CGRectMake(0.f, 0.f, 44.f, 44.f);
    [actionBtn setTitleColor:COLOR_NAV_TEXT forState:UIControlStateNormal];
    [actionBtn setTitleColor:COLOR_BTN_BOX_GRAY_TEXT forState:UIControlStateHighlighted];
    [actionBtn setTitle:self.operateType.integerValue==1?@"下一步":@"保存" forState:UIControlStateNormal];
    actionBtn.titleLabel.font = FONT_14B;
    //[actionBtn setImage:[UIImage imageNamed:@"more_xiaoxi"] forState:UIControlStateNormal];
    //    [actionBtn setImage:[UIImage imageNamed:@"ico_backon" ] forState:UIControlStateHighlighted];
    [actionBtn addTarget:self action:@selector(nextBtnHandler) forControlEvents:UIControlEventTouchUpInside];
    return actionBtn;
}




-(void)nextBtnHandler{
   
    TLAddTripRequestDTO *tripRequestDTO = [[TLAddTripRequestDTO alloc] init];
    tripRequestDTO.title = titleField.text;
    tripRequestDTO.cityId = @"1";
    tripRequestDTO.content = contentLabel.text;
    tripRequestDTO.isTop = @"0";
    tripRequestDTO.userImage = @[];
    tripRequestDTO.type = self.type;
    tripRequestDTO.operateType = self.operateType;
    tripRequestDTO.objId = self.detailDto.travelId.length>0?self.detailDto.travelId:@"";
    
    if (tripRequestDTO.title.length==0||tripRequestDTO.content.length==0) {
        [GHUDAlertUtils toggleMessage:@"请输入发表的内容"];
        return;
    }
    
    WEAK_SELF(self);
    
    [GHUDAlertUtils toggleLoadingInView:self.view];
    [GTLModuleDataHelper addTrip:tripRequestDTO requestArray:self.requestArray block:^(id obj, BOOL ret) {
        [GHUDAlertUtils hideLoadingInView:self.view];
        
        TLAddTripResponseDTO *response = obj;
        if (ret) {
            if (self.operateType.integerValue==1) {
                TLTripDataDTO *dto = [[TLTripDataDTO alloc] init];
                dto.travelId = response.result.travelId;
                dto.title = tripRequestDTO.title;
                [GHUDAlertUtils toggleMessage:@"发表成功"];
                titleField.text = @"";
                contentLabel.text = @"";
                [weakSelf pushViewControllerWithName:@"TLNewWaybookNodeViewController" itemData:dto block:^(TLNewWaybookNodeViewController* obj) {
                    obj.operateType = self.operateType;
                    obj.type = self.type;
                }];
            }else{
                [GHUDAlertUtils toggleMessage:@"保存成功"];
            }
            
        }else{
            [GHUDAlertUtils toggleMessage:response.resultDesc];
            
        }
    }];

    
    
    
}


-(void)updateUI{
    titleField.text = self.detailDto.title;
    contentLabel.text = self.detailDto.content;
}

-(void)addAllUIResources{
    CGFloat hGap = 5.f;
    CGFloat vGap = 5.f;
    //CGFloat topWidth = 80.f;
    CGFloat textHeight = 40.f;
    CGFloat addImageBtnHeight = 130.f;
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0.f, vGap+NAVIGATIONBAR_HEIGHT+STATUSBAR_HEIGHT, CGRectGetWidth(self.view.frame), textHeight)];
    [titleView setBackgroundColor:UIColorFromRGBA(0xFFFFFF, 1.0f)];
    [self.view addSubview:titleView];
    
    titleField = [[UITextField alloc] initWithFrame:CGRectMake(hGap, 0.f, CGRectGetWidth(titleView.frame)-hGap*2, CGRectHeight(titleView.frame))];
    [titleView addSubview:titleField];
    titleField.placeholder = @"写标题";
    
    /*
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleView.frame)+hGap, vGap+NAVIGATIONBAR_HEIGHT+STATUSBAR_HEIGHT, topWidth, textHeight)];
    [topView setBackgroundColor:UIColorFromRGBA(0xFFFFFF, 1.0f)];
    [self.view addSubview:topView];
    
    RIconTextBtn *topBtn = [[RIconTextBtn alloc] initWithFrame:CGRectMake(hGap, 0.f, CGRectGetWidth(topView.frame)-hGap*2, CGRectHeight(topView.frame))];
    [topBtn setImage:[UIImage imageNamed:@"ico_checkbox_notselect"] forState:UIControlStateNormal];
    [topBtn setImage:[UIImage imageNamed:@"ico_checkbox_select"] forState:UIControlStateSelected];
    [topBtn setTitle:@"置顶" forState:UIControlStateNormal];
    [topBtn setTitleColor:COLOR_MAIN_TEXT forState:UIControlStateNormal];
    [topBtn addTarget:self action:@selector(topBtnHandler:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:topBtn];
    */
    
    /*UIView *cityView = [[UIView alloc] initWithFrame:CGRectMake(0.f, vGap*2+NAVIGATIONBAR_HEIGHT+STATUSBAR_HEIGHT+textHeight, CGRectGetWidth(self.view.frame), textHeight)];
    [cityView setBackgroundColor:UIColorFromRGBA(0xFFFFFF, 1.0f)];
    [self.view addSubview:cityView];
    
    UITextField *cityField = [[UITextField alloc] initWithFrame:CGRectMake(hGap, 0.f, CGRectGetWidth(cityView.frame)-hGap*2, CGRectHeight(cityView.frame))];
    [cityView addSubview:cityField];
    cityField.placeholder = @"写入旅游点，多个城市用分号隔开";
    */
    
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0.f, vGap*2+NAVIGATIONBAR_HEIGHT+STATUSBAR_HEIGHT+textHeight, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-NAVIGATIONBAR_HEIGHT-STATUSBAR_HEIGHT-vGap*5-textHeight*2-addImageBtnHeight)];
    [contentView setBackgroundColor:UIColorFromRGBA(0xFFFFFF, 1.0f)];
    [self.view addSubview:contentView];
    
    //UITextView *contentTextView = [[UITextView alloc] initWithFrame:contentView.bounds];
    //[contentView addSubview:contentTextView];
    
    contentLabel = [[ZXTextView alloc] initWithFrame:contentView.bounds];
    contentLabel.font = FONT_16;
    contentLabel.textColor = COLOR_MAIN_TEXT;
//    contentLabel.largeTextLength = 200;
    contentLabel.placeholder = @"写正文";
    contentLabel.keyboardType = UIKeyboardTypeDefault;
    //    detailAddressLabel.delegate = self;//不能再设代理了,代理走的是helper
    contentLabel.autoHideKeyboard = YES;
    contentLabel.scrollEnabled = YES;
    [contentView addSubview:contentLabel];
    contentLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    
    
    
}



-(void)topBtnHandler:(UIButton*)btn{
    if (btn.selected) {
        btn.selected = NO;
    }else{
        btn.selected = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
