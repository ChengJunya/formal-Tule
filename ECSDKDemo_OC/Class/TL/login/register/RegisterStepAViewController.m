//
//  RegisterStepAViewController.m
//  alijk
//
//  Created by easy on 14-7-31.
//  Copyright (c) 2014年 zhongxin. All rights reserved.
//

#import "RegisterStepAViewController.h"

#import "ZXTextField.h"
#import "ZXColorButton.h"
#import "ZXCheckUtils.h"
#import "ZXUIHelper.h"
#import "TLHelper.h"
#import "ZXSingleCheckbox.h"
#import "CCitySelectView.h"
#import "RIconTextBtn.h"
#import "AddressDataHelper.h"
#import "TLCityDTO.h"
#import "TLProvinceDTO.h"
#import "TLDistrictDTO.h"
#import "RegisterStepCViewController.h"
#import "RegisterStepBViewController.h"

@interface RegisterStepAViewController ()
{
    ZXTextField *_phoneNumField;
//    ZXTextField *_certifyCodeField;
    RIconTextBtn *_cityBtn;
//    ZXTextField *_repeatPwdField;
//    ZXTextField *_inviteCodeField;
//    ZXColorButton *_getCodeBtn;
//    ZXSingleCheckbox *_checkbox;
    UILabel *_phoneNumShowInfo;
//    UILabel *_codeShowInfo;
//    UILabel *_pwdShowInfo;
//    UILabel *_againPwdShowInfo;
//    UILabel *_recommendShowInfo;
    UIButton *_nextStepBtn;
    UIView *citySelectView;
    CCitySelectView *select;
    BOOL isCitySelected;
    RIconTextBtn *cityBtn;
    UILabel *_cityShowInfo;
    
    UITextField *codeField;
    
    
    UIView *selectPhoneTypeView;
    UIButton *selectPhoneTypeBtn;
    UITextField *phoneField;
    BOOL isNative;//是否国内
    
}

@property (nonatomic, strong) UIButton *nextStepBtn;

@end


@implementation RegisterStepAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.frame = [[UIScreen mainScreen] bounds];
    self.view.backgroundColor = COLOR_DEF_BG;
    isNative = YES;
    isCitySelected = NO;
    self.title = MultiLanguage(registerStepATitle);
    [self addAllUIResources];
    [self addGesRecognizerBlockToTextField];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navBarHidden = NO;
    self.navBackItemHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self removeAllUIResources];
}

-(void)showSelectView{
   
    selectPhoneTypeView.hidden = NO;
    
}

-(void)phoneAction{
    [self hideSelectView];
    [selectPhoneTypeBtn setTitle:@"+86" forState:UIControlStateNormal];
    _phoneNumField.enabled = YES;
    _phoneNumField.placeholder = MultiLanguage(rsavcInputPhone);
    isNative = YES;
}
-(void)poreinBtnAction{
    [self hideSelectView];
    [selectPhoneTypeBtn setTitle:@"国外" forState:UIControlStateNormal];
    _phoneNumField.enabled = NO;
    _phoneNumField.placeholder = @"国外用户不需要输入手机号";
    isNative = NO;

}

-(void)hideSelectView{
    if (selectPhoneTypeView !=nil) {
        selectPhoneTypeView.hidden = YES;
    }
}

-(void)selectPhoneBtnAction:(UIButton *)btn{
    selectPhoneTypeView.hidden = !selectPhoneTypeView.hidden;

}


#pragma mark -
#pragma mark - ui

- (void)addAllUIResources
{
    CGFloat yOffSet = NAVIGATIONBAR_HEIGHT+STATUSBAR_HEIGHT;
    __weak RegisterStepAViewController *weakSelf = self;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.userInteractionEnabled = YES;
    [self.view addSubview:scrollView];
    
    
        CGRect phoneNumRect = CGRectMake(UI_LAYOUT_MARGIN, yOffSet+12.f, UI_COMM_BTN_WIDTH, UI_COMM_BTN_HEIGHT);
    
    
    UIView *phoneSelectView = [[UIView alloc] initWithFrame:phoneNumRect];
    phoneSelectView.layer.borderColor = COLOR_ASSI_TEXT.CGColor;
    phoneSelectView.layer.cornerRadius = 4.f;
    phoneSelectView.layer.borderWidth = 0.5f;
    phoneSelectView.layer.masksToBounds = YES;
    phoneSelectView.backgroundColor = COLOR_WHITE_BG;
    
    UIImageView *phoneIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, 36.f, phoneSelectView.height)];
    phoneIconImageView.image = [UIImage imageNamed:@"tl_phone"];
    [phoneSelectView addSubview:phoneIconImageView];
    
    [scrollView addSubview:phoneSelectView];
    
    selectPhoneTypeBtn = [[UIButton alloc] initWithFrame:CGRectMake(phoneIconImageView.maxX+2.f, 0.f, 40.f, phoneSelectView.height)];
    selectPhoneTypeBtn.titleLabel.font = FONT_14;
    [selectPhoneTypeBtn setTitle:@"+86" forState:UIControlStateNormal];
    [selectPhoneTypeBtn setTitleColor:COLOR_MAIN_TEXT forState:UIControlStateNormal];
    [phoneSelectView addSubview:selectPhoneTypeBtn];
    
    [selectPhoneTypeBtn addTarget:self action:@selector(selectPhoneBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    CALayer *vline = [CALayer layer];
    vline.frame = CGRectMake(selectPhoneTypeBtn.width-0.5f, 0.f, 0.5, selectPhoneTypeBtn.height);
    vline.backgroundColor = COLOR_ASSI_TEXT.CGColor;
    [selectPhoneTypeBtn.layer addSublayer:vline];
    
    
    // input textfield

    ZXTextField *phoneNumField = [[ZXTextField alloc] initWithFrame:CGRectMake(selectPhoneTypeBtn.maxX+2, 0.f, phoneSelectView.width-80, phoneSelectView.height)];
    phoneNumField.placeholder = MultiLanguage(rsavcInputPhone);
    phoneNumField.font = FONT_16;
    phoneNumField.textColor = COLOR_MAIN_TEXT;
    phoneNumField.largeTextLength = 11;
    phoneNumField.keyboardType = UIKeyboardTypeNumberPad;
    phoneNumField.autoHideKeyboard = YES;
    phoneNumField.zxBorderWidth = 0.f;
    //[scrollView addSubview:phoneNumField];
    _phoneNumField = phoneNumField;
    phoneNumField.layer.borderWidth = 0.f;

    
    
    phoneField = [[UITextField alloc] initWithFrame:phoneSelectView.frame];
    [phoneSelectView addSubview:phoneNumField];
//    phoneField.keyboardType = UIKeyboardTypeNumberPad;
//    phoneField.textColor = COLOR_MAIN_TEXT;
//    phoneField.font = FONT_16;
//    phoneField.placeholder = @"请输入手机号";
    
    _phoneNumShowInfo = [ZXCheckUtils addShowInfoByTextField:phoneField spuerView:scrollView];
    
    selectPhoneTypeView = [[UIView alloc] initWithFrame:CGRectMake(selectPhoneTypeBtn.x+10.f, phoneSelectView.maxY, 80.f, 60.f)];
    selectPhoneTypeView.hidden = YES;
    [scrollView addSubview:selectPhoneTypeView];
    selectPhoneTypeView.layer.borderWidth = 0.5f;
    selectPhoneTypeView.layer.borderColor = COLOR_ASSI_TEXT.CGColor;
    
    
    UIButton *phoneBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f, selectPhoneTypeView.width, 30.f)];
    [phoneBtn setTitle:@"+86" forState:UIControlStateNormal];
    phoneBtn.backgroundColor = COLOR_WHITE_BG;
    phoneBtn.titleLabel.font = FONT_14;
    [phoneBtn setTitleColor:COLOR_MAIN_TEXT forState:UIControlStateNormal];
    [selectPhoneTypeView addSubview:phoneBtn];
    [phoneBtn addTarget:self action:@selector(phoneAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *foreinBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 30.f, selectPhoneTypeView.width, 30.f)];
    [foreinBtn setTitle:@"国外" forState:UIControlStateNormal];
    foreinBtn.backgroundColor = COLOR_WHITE_BG;
    foreinBtn.titleLabel.font = FONT_14;
    [foreinBtn setTitleColor:COLOR_MAIN_TEXT forState:UIControlStateNormal];
    [selectPhoneTypeView addSubview:foreinBtn];
    
    [foreinBtn addTarget:self action:@selector(poreinBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    
//    CGRect certifyCodeRect = CGRectMake(UI_LAYOUT_MARGIN, 72.f, UI_COMM_BTN_WIDTH-108.f, UI_COMM_BTN_HEIGHT);
//    ZXTextField *certifyCodeField = [[ZXTextField alloc] initWithFrame:certifyCodeRect];
//    certifyCodeField.placeholder = MultiLanguage(rsavcInputCode);
//    certifyCodeField.font = FONT_16;
//    certifyCodeField.largeTextLength = 6;
//    certifyCodeField.autoHideKeyboard = YES;
//    [scrollView addSubview:certifyCodeField];
//    _certifyCodeField = certifyCodeField;
//    _codeShowInfo = [ZXCheckUtils addShowInfoByTextField:certifyCodeField spuerView:scrollView];
//    CGRect codeShowInfoFrame = _codeShowInfo.frame;
//    _codeShowInfo.frame = (CGRect){.origin = CGRectOrigin(codeShowInfoFrame), .size = CGSizeMake(UI_COMM_BTN_WIDTH, CGRectHeight(codeShowInfoFrame))};
//    
    CGRect cityRect = CGRectMake(UI_LAYOUT_MARGIN, 132.f, UI_COMM_BTN_WIDTH, UI_COMM_BTN_HEIGHT);
    cityBtn = [[RIconTextBtn alloc] initWithFrame:cityRect withImageSize:CGSizeMake(UI_COMM_BTN_HEIGHT+10, UI_COMM_BTN_HEIGHT)];
    [cityBtn setImage:[UIImage imageNamed:@"tl_place"] forState:UIControlStateNormal];
    [cityBtn setTitle:@"请点击选择所在地市" forState:UIControlStateNormal];
    [cityBtn setTitleColor:UIColorFromRGBA(0xCCCCCC, 1) forState:UIControlStateNormal];
    cityBtn.titleLabel.font = FONT_16;
//    cityBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
//    cityBtn.contentHorizontalAlignment = NSTextAlignmentLeft;
    cityBtn.layer.borderColor = [UIColor colorWithWhite:0.1 alpha:0.2].CGColor;
    cityBtn.layer.borderWidth = 1.f;
    cityBtn.layer.backgroundColor = [UIColor whiteColor].CGColor;
    cityBtn.layer.cornerRadius = 5.f;
    cityBtn.layer.masksToBounds = YES;
    [cityBtn addTarget:self action:@selector(cityBtnHandler:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:cityBtn];
    _cityBtn = cityBtn;
    _cityShowInfo = [ZXCheckUtils addShowInfoByView:cityBtn spuerView:scrollView];

    
//
//    CGRect repeatPwdFieldRect = CGRectMake(UI_LAYOUT_MARGIN, 192.f, UI_COMM_BTN_WIDTH, UI_COMM_BTN_HEIGHT);
//    ZXTextField *repeatPwdField = [[ZXTextField alloc] initWithFrame:repeatPwdFieldRect];
//    repeatPwdField.placeholder = @"请再次输入密码";
//    repeatPwdField.font = FONT_16;
//    repeatPwdField.largeTextLength = 20;
//    repeatPwdField.secureTextEntry = YES;
//    repeatPwdField.autoHideKeyboard = YES;
//    [scrollView addSubview:repeatPwdField];
//    _repeatPwdField = repeatPwdField;
//    _againPwdShowInfo = [ZXCheckUtils addShowInfoByTextField:repeatPwdField spuerView:scrollView];
//    
    /*
    //分割线
    UIImageView *lineView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"separateLine"]];
    lineView.contentMode = UIViewContentModeScaleToFill;
    [lineView setFrame:CGRectMake(KNewPresCellBorder,CGRectGetMaxY(_repeatPwdField.frame) + 20.f, UI_COMM_BTN_WIDTH,1)];
    [scrollView addSubview:lineView];
    
    UILabel *tipsLabel = [[UILabel alloc] init];
    tipsLabel.text= @"如您有药店提供的邀请码,建议填写此项";
    tipsLabel.textColor = COLOR_MAIN_TEXT;
    tipsLabel.font = FONT_12;
    CGSize labelSize = [tipsLabel boundingRectWithSize:CGSizeMake(UI_COMM_BTN_WIDTH, 10000)];
    tipsLabel.frame = (CGRect){{KNewPresCellBorder,CGRectGetMaxY(lineView.frame) + KNewPresCellBorder},labelSize};
    [scrollView addSubview:tipsLabel];
    
    //邀请码
    ZXTextField *inviteCodeField = [[ZXTextField alloc] init];
    inviteCodeField.frame = CGRectMake(KNewPresCellBorder, CGRectGetMaxY(tipsLabel.frame) + 8.f, UI_COMM_BTN_WIDTH,UI_COMM_BTN_HEIGHT);
    inviteCodeField.placeholder = @"邀请码(选填)";
    inviteCodeField.font = FONT_16;
    inviteCodeField.largeTextLength = 6;
    inviteCodeField.autoHideKeyboard = YES;
    inviteCodeField.keyboardType = UIKeyboardTypeNumberPad;
    [scrollView addSubview:inviteCodeField];
    _inviteCodeField = inviteCodeField;
    _recommendShowInfo = [ZXCheckUtils addShowInfoByTextField:inviteCodeField spuerView:scrollView];
     */
    
    //同意协议
//    ZXSingleCheckbox *checkbox = [[ZXSingleCheckbox alloc] initWithFrame:CGRectMake(UI_LAYOUT_MARGIN, CGRectGetMaxY(repeatPwdField.frame) + 16.f, 140.f, 20.f)];
//    checkbox.textLabel.text = MultiLanguage(rsbvcAgreeProtocol);
//    checkbox.textLabel.font = FONT_14;
//    checkbox.isChecked = YES;
//    [checkbox setBlock:^(BOOL value) {
//        [weakSelf.nextStepBtn setEnabled:value];
//    }];
//    [scrollView addSubview:checkbox];
//    _checkbox = checkbox;
//    
//    // 查看协议按钮
//    UIButton *checkProtocolBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [checkProtocolBtn setBackgroundColor:[UIColor clearColor]];
//    checkProtocolBtn.frame = CGRectMake(UI_COMM_BTN_WIDTH-110.f, CGRectGetMaxY(repeatPwdField.frame) + 16.f, 138.f, 20.f);
//    [checkProtocolBtn setTitle:MultiLanguage(rsbvcCheckProtocol) forState:UIControlStateNormal];
//    [checkProtocolBtn setTitleColor:RGBColor(0.f, 90.f, 180.f, 1.f) forState:UIControlStateNormal];
//    [checkProtocolBtn setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
//    checkProtocolBtn.titleLabel.font = FONT_14;
//    checkProtocolBtn.titleLabel.textAlignment = NSTextAlignmentRight;
//    [checkProtocolBtn addTarget:self action:@selector(clickCheckProtocolButton) forControlEvents:UIControlEventTouchUpInside];
//    [scrollView addSubview:checkProtocolBtn];
//    
//    // 获取验证码按钮
//    CGRect getCodeBtnFrame = CGRectMake(UI_LAYOUT_MARGIN+CGRectGetWidth(certifyCodeRect)+8.f, 72.f, 100.f, UI_COMM_BTN_HEIGHT);
//    ZXColorButton *getCodeBtn = [ZXColorButton buttonWithType:EZXBT_BOX_GRAY frame:getCodeBtnFrame title:MultiLanguage(rsavcGetCode) font:FONT_16 block:^{
//        [weakSelf clickGetCodeButton];
//    }];
//    [scrollView addSubview:getCodeBtn];
//    _getCodeBtn = getCodeBtn;
    
    
    UIView *imageCodeView = [[UIView alloc] initWithFrame:CGRectMake(UI_LAYOUT_MARGIN, cityBtn.maxY+16.f, UI_COMM_BTN_WIDTH, UI_COMM_BTN_HEIGHT)];
    imageCodeView.layer.borderColor = [UIColor colorWithWhite:0.1 alpha:0.2].CGColor;
    imageCodeView.layer.borderWidth = 1.f;
    imageCodeView.layer.backgroundColor = [UIColor whiteColor].CGColor;
    imageCodeView.layer.cornerRadius = 5.f;
    imageCodeView.layer.masksToBounds = YES;
    [scrollView addSubview:imageCodeView];
    
    codeField = [[UITextField alloc] initWithFrame:CGRectMake(5, 0, imageCodeView.width-90.f, imageCodeView.height)];
    [imageCodeView addSubview:codeField];
    codeField.placeholder = @"请输入验证码,点击刷新";
    codeField.font = FONT_16;
    codeField.textColor = COLOR_MAIN_TEXT;
    codeField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    UIImageView *codeImage = [[UIImageView alloc] initWithFrame:CGRectMake(imageCodeView.width-2- 80.f, 2.f, 80.f, imageCodeView.height-4)];
    [imageCodeView addSubview:codeImage];
    NSString *codeImageUrl = [NSString stringWithFormat:@"%@%@",TL_SERVER_BASE_URL,@"/image.jsp"];
    codeImage.onTouchTapBlock = ^(UIImageView *imageView){
        imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:codeImageUrl]]];
    };
    codeImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:codeImageUrl]]];
    //[codeImage sd_setImageWithURL:[NSURL URLWithString:codeImageUrl] placeholderImage:[UIImage imageNamed:@"ico_loading_logo"]];
    
    
    // nextstep button
    CGRect nextStepBtnFrame = CGRectMake(UI_LAYOUT_MARGIN, CGRectGetMaxY(imageCodeView.frame) + 16.f, UI_COMM_BTN_WIDTH, UI_COMM_BTN_HEIGHT);
    UIButton *nextStepBtn = [ZXColorButton buttonWithType:EZXBT_SOLID_GREEN frame:nextStepBtnFrame title:MultiLanguage(fpavcNextStep) font:FONT_18 block:^{
        [weakSelf clickNextStepButton];
    }];
    [scrollView addSubview:nextStepBtn];
    self.nextStepBtn = nextStepBtn;
    
        [scrollView  bringSubviewToFront:selectPhoneTypeView];
}

- (void)removeAllUIResources
{
    //[_getCodeBtn stopCountdown];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark - net request

- (void)sendRequestToGetCertifyCode
{
//    SmsRequestDTO * request = [[SmsRequestDTO alloc] init];
//    request.smstype = 0;
//    request.devicesid = [_phoneNumField.text copy]; //GDevicesID; // 使用手机号
//    request.mobilephone = [_phoneNumField.text copy];
//    NSNumber *requestTag = [GDataManager asyncRequestByType:NetAdapter_User_Register_GetUserKey andObject:request success:^(SmsResponseDTO *responseDTO) {
//        [GHUDAlertUtils toggleMessage:MultiLanguage(rsavcGetCodeSucceed)];
//        [GCertifyCodeHelper saveVerifySmsSuccess:_phoneNumField.text PageType:K_CT_RegistVC];
//    } failure:^(ResponseDTO *responseDTO) {
//         [_getCodeBtn stopCountdown];
//        [GHUDAlertUtils toggleMessage:responseDTO.retMessage];
//    }];
//    [self.requestArray addObject:requestTag];
}

- (void)sendRequestToRegister
{
    NSString *phoneNum = [_phoneNumField.text copy];
    TLProvinceDTO *province = select.firstCoponentSelectedItem;
    TLCityDTO *city = select.subCoponentSelectedItem;
    TLDistrictDTO *district = [[TLDistrictDTO alloc] init]; //select.thirdCoponentSelectedItem;
    NSDictionary *itemData = @{@"phoneNum":phoneNum,@"province":province,@"city":city,@"district":district};
    
//    NSString *certifyCode = [_certifyCodeField.text copy];
//    NSString *password = [_pwdField.text copy];
//    NSString *inviteCode = [_inviteCodeField.text copy];
    [self pushViewControllerWithName:@"RegisterStepBViewController" itemData:itemData block:^(RegisterStepBViewController* obj) {
                obj.isChinaPhoneNum = isNative?@"1":@"0";
    }];
    
//    [GHUDAlertUtils toggleLoadingInView:self.view];
//    [GUserDataHelper registerWithUserName:username password:password certifyCode:certifyCode recommendCode:inviteCode block:^(ResponseDTO *loginDTO, BOOL ret) {
//        [GHUDAlertUtils hideLoadingInView:self.view];
//        if (ret) {
//            [self gotoNextVCWhenLoginSucceed:YES];
//        }
//        else {
//            [GHUDAlertUtils toggleMessage:loginDTO.retMessage];
//        }
//    }];
}


- (void)addGesRecognizerBlockToTextField
{
    GesRecognizer_Block block = ^(UIGestureRecognizer* gestureRecognizer, UITouch* touch) {
        if ([touch.view isKindOfClass:[UITextField class]] ||
            [touch.view isKindOfClass:[ZXSingleCheckbox class]])
        {
            return NO;
        }
        
        return YES;
    };
    
    _phoneNumField.gesRecognizerBlock = block;
//    _certifyCodeField.gesRecognizerBlock = block;
//    _pwdField.gesRecognizerBlock = block;
//    _repeatPwdField.gesRecognizerBlock = block;
//    _inviteCodeField.gesRecognizerBlock = block;
}

#pragma mark -
#pragma mark - action

- (void)clickCheckProtocolButton
{
    [self gotoCheckProtocolViewController];
}
- (void)gotoCheckProtocolViewController
{
//    [self pushViewControllerWithName:@"WebViewController" block:^(WebViewController *obj) {
//        obj.navTitle = MultiLanguage(amevcTitle);
//        obj.webUrl = URL_LICENCE;
//        obj.navMsgIconState = EWIST_HIDDEN;
//        obj.toobarShowState = EWIST_SHOW;
//        obj.isJSInteractive = NO;
//    }];
}


- (void)clickGetCodeButton
{
//    NSString *phoneNumber = [_phoneNumField.text copy];
//    NSInteger reqCount = [GCertifyCodeHelper getCertifyCodeTimes:phoneNumber PageType:K_CT_RegistVC];
//    
//    if (reqCount == 0)
//    {
//        [GHUDAlertUtils toggleMessage:MultiLanguage(fverifySmsTimesOut)];
//        
//        return;
//    }
//    
//    if ([ZXCheckUtils checkRegPhoneNumber:phoneNumber showInfo:_phoneNumShowInfo]) {
//        [_getCodeBtn countdownWithTime:60];
//        [self sendRequestToGetCertifyCode];
//    }
}

- (void)clickNextStepButton
{
    
    NSString *vCode = [codeField.text copy];
    if (vCode.length==0) {
        [GHUDAlertUtils toggleMessage:@"请输入验证码"];
        return;
    }
    
     NSString *phoneNumber = [_phoneNumField.text copy];
    
    if (isNative&&[ZXCheckUtils checkRegPhoneNumber:phoneNumber showInfo:_phoneNumShowInfo]&&[ZXCheckUtils checkEmpty:isCitySelected?@"SELECTED":@"" showInfo:@"请选择现居地" onLabel:_cityShowInfo]) {
        NSString *phoneNum = [_phoneNumField.text copy];
        TLProvinceDTO *province = select.firstCoponentSelectedItem;
        TLCityDTO *city = select.subCoponentSelectedItem;
        TLDistrictDTO *district = [[TLDistrictDTO alloc] init]; //select.thirdCoponentSelectedItem;
        NSDictionary *itemData = @{@"phoneNum":phoneNum,@"province":province,@"city":city,@"district":district,@"rand":vCode};
        

        [self pushViewControllerWithName:@"RegisterStepBViewController" itemData:itemData block:^(RegisterStepBViewController* obj) {
            obj.isChinaPhoneNum = isNative?@"1":@"0";
        }];
    }else
    
    if (!isNative&&[ZXCheckUtils checkEmpty:isCitySelected?@"SELECTED":@"" showInfo:@"请选择现居地" onLabel:_cityShowInfo]){
        NSString *phoneNum = [_phoneNumField.text copy];
        TLProvinceDTO *province = select.firstCoponentSelectedItem;
        TLCityDTO *city = select.subCoponentSelectedItem;
        TLDistrictDTO *district = [[TLDistrictDTO alloc] init]; //select.thirdCoponentSelectedItem;
        NSDictionary *itemData = @{@"phoneNum":phoneNum,@"province":province,@"city":city,@"district":district};
        

        [self pushViewControllerWithName:@"RegisterStepCViewController" itemData:itemData block:^(RegisterStepCViewController* obj) {
            obj.isChinaPhoneNum = isNative?@"1":@"0";
        }];
    }
    
//    if (_checkbox.isChecked) {
//        NSString *phoneNumber = [_phoneNumField.text copy];
//        NSString *cerCode = [_certifyCodeField.text copy];
//        NSString *password = [_pwdField.text copy];
//        NSString *againPwd = [_repeatPwdField.text copy];
//        NSString *recommend = [_inviteCodeField.text copy];
//        if ([ZXCheckUtils checkRegPhoneNumber:phoneNumber showInfo:_phoneNumShowInfo] &&
//            [ZXCheckUtils checkCertifyCode:cerCode showInfo:_codeShowInfo] &&
//            [ZXCheckUtils checkPassword:password showInfo:_pwdShowInfo] &&[ZXCheckUtils checkPassword:password pwdAgain:againPwd showInfo:_againPwdShowInfo] &&[ZXCheckUtils checkRecommendCode:recommend showInfo:_recommendShowInfo]) {
//            [self sendRequestToRegister];
//        }
//    }
//    else{
////        [GHUDAlertUtils toggleMessage:@"请选择同意协议"];
//    }
}


-(void)cityBtnHandler:(id *)btn{
    [self.view endEditing:YES];
    if(citySelectView==nil){
    
    citySelectView = [[UIView alloc] initWithFrame:self.view.bounds];
    citySelectView.backgroundColor = UIColorFromRGBA(0x000000, 0.5f);
    [self.view addSubview:citySelectView];
    
    CGFloat _yOffSet = 100.f;
    CGFloat hGap = 20.f;
    CGFloat frameWidth = CGRectWidth(citySelectView.frame)-hGap*2;
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(hGap, _yOffSet, frameWidth, 40.f)];
    titleView.layer.borderWidth = 0.5f;
    titleView.layer.borderColor = [UIColor colorWithWhite:0.1 alpha:0.2].CGColor;
    titleView.backgroundColor = COLOR_DEF_BG;
    [citySelectView addSubview:titleView];
    
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.f, 0.f, frameWidth, 40.f)];
    titleLabel.text = @"现居地";
    titleLabel.textColor = COLOR_MAIN_TEXT;
    titleLabel.font = FONT_16B;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [titleView addSubview:titleLabel];
    
    _yOffSet = _yOffSet + CGRectHeight(titleLabel.frame);
    
    select = [[CCitySelectView alloc] initWithFrame:CGRectMake(hGap, _yOffSet, CGRectWidth(citySelectView.frame)-40.f, 160.f)];
    select.layer.borderWidth = 0.5f;
    select.layer.borderColor = [UIColor colorWithWhite:0.1 alpha:0.2].CGColor;
    select.backgroundColor = COLOR_DEF_BG;
    select.firstCoponentNameKey = @"provinceName";
    select.subCoponentNameKey = @"cityName";
    //select.thirdCoponentNameKey = @"districtName";
        
        __weak RegisterStepAViewController *weakSealf = self;
    [citySelectView addSubview:select];
    select.PickerSelectBlock = ^(id selectedItem,CCitySelectView* selectView){
        TLProvinceDTO *province = selectedItem;
        [GHUDAlertUtils toggleLoadingInView:weakSealf.view];
        [GAddressHelper getCityList:province.provinceId requestArr:weakSealf.requestArray block:^(id obj, BOOL ret) {
            [GHUDAlertUtils hideLoadingInView:weakSealf.view];
            //验证成功
            if (ret) {
                NSArray *cityList = obj;
                [selectView setSubPickerArray:cityList];
            }
            
            
        }];
        
    };
        
//    select.PickerSubSelectBlock =^(id selectedItem,CCitySelectView* selectView){
//        TLCityDTO *city = selectedItem;
//        [GHUDAlertUtils toggleLoadingInView:weakSealf.view];
//        [GAddressHelper getDistrictList:city.cityId requestArr:weakSealf.requestArray block:^(id obj, BOOL ret) {
//            [GHUDAlertUtils hideLoadingInView:weakSealf.view];
//            //验证成功
//            if (ret) {
//                NSArray *districtList = obj;
//                [selectView setThirdPickerArray:districtList];
//            }
//            
//            
//        }];
//        
//    };

        
    [GHUDAlertUtils toggleLoadingInView:self.view];
    [GAddressHelper getProvinceList:self.requestArray block:^(id obj, BOOL ret) {
        [GHUDAlertUtils hideLoadingInView:self.view];
        //验证成功
        if (ret) {
            NSArray *proviceList = obj;
            [select setPickerArray:proviceList];
        }
        
        
    }];
    
    
    _yOffSet = _yOffSet + CGRectHeight(select);
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(hGap, _yOffSet, CGRectGetWidth(citySelectView.frame)/2-hGap, 40.f)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:COLOR_MAIN_TEXT forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    cancelBtn.titleLabel.font = FONT_16B;
    
    [cancelBtn addTarget:self action:@selector(cancelBtnHandler:) forControlEvents:UIControlEventTouchUpInside];
    
    cancelBtn.layer.borderWidth = 0.5f;
    cancelBtn.layer.borderColor = [UIColor colorWithWhite:0.1 alpha:0.2].CGColor;
    cancelBtn.backgroundColor = COLOR_DEF_BG;
    [citySelectView addSubview:cancelBtn];
    
    UIButton *okBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(citySelectView.frame)/2, _yOffSet, CGRectGetWidth(citySelectView.frame)/2-hGap, 40.f)];
    [okBtn setTitle:@"确定" forState:UIControlStateNormal];
    okBtn.titleLabel.font = FONT_16B;
    
        [okBtn addTarget:self action:@selector(okBtnHandler:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [okBtn setTitleColor:COLOR_ORANGE_TEXT forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    okBtn.layer.borderWidth = 0.5f;
    okBtn.layer.borderColor = [UIColor colorWithWhite:0.1 alpha:0.2].CGColor;
    okBtn.backgroundColor = COLOR_DEF_BG;
    [citySelectView addSubview:okBtn];
    
    
    }else{
        [self.view addSubview:citySelectView];
    }
    
}

-(void)cancelBtnHandler:(id)btn{
    [citySelectView removeFromSuperview];

}

-(void)okBtnHandler:(id)btn{
    [citySelectView removeFromSuperview];

    TLProvinceDTO *province = select.firstCoponentSelectedItem;
    TLCityDTO *city = select.subCoponentSelectedItem;
    TLDistrictDTO *district = [[TLDistrictDTO alloc] init]; //select.thirdCoponentSelectedItem;
    [cityBtn setTitle:[NSString stringWithFormat:@"%@    %@",province.provinceName,city.cityName] forState:UIControlStateNormal];
    [cityBtn setTitleColor:COLOR_MAIN_TEXT forState:UIControlStateNormal];
    isCitySelected = YES;
}

@end
