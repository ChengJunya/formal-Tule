//
//  RegisterStepBViewController.m
//  alijk
//
//  Created by easy on 14-7-31.
//  Copyright (c) 2014年 zhongxin. All rights reserved.
//

#import "RegisterStepBViewController.h"

#import "ZXTextField.h"
#import "ZXColorButton.h"
#import "ZXCheckUtils.h"
#import "ZXUIHelper.h"
#import "TLHelper.h"
#import "ZXSingleCheckbox.h"
#import "CertifyCodeRequestDTO.h"
#import "CertifyCodeHelper.h"
#import "PhoneRequestDTO.h"
#import "PhoneResponseCodeDTO.h"
#import "RegisterStepCViewController.h"


@interface RegisterStepBViewController ()
{
    //ZXTextField *_phoneNumField;
    ZXTextField *_certifyCodeField;
    //ZXTextField *_pwdField;
    //ZXTextField *_repeatPwdField;
    //ZXTextField *_inviteCodeField;
    ZXColorButton *_getCodeBtn;
//    ZXSingleCheckbox *_checkbox;
    //UILabel *_phoneNumShowInfo;
    UILabel *_codeShowInfo;
    //UILabel *_pwdShowInfo;
    //UILabel *_againPwdShowInfo;
    //UILabel *_recommendShowInfo;
    UIButton *_nextStepBtn;
}

@property (nonatomic, strong) UIButton *nextStepBtn;

@end


@implementation RegisterStepBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.frame = [[UIScreen mainScreen] bounds];
    self.view.backgroundColor = COLOR_DEF_BG;
    
    self.title = MultiLanguage(registerStepBTitle);
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


#pragma mark -
#pragma mark - ui

- (void)addAllUIResources
{
    CGFloat yOffSet = NAVIGATIONBAR_HEIGHT+STATUSBAR_HEIGHT;
    __weak RegisterStepBViewController *weakSelf = self;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.userInteractionEnabled = YES;
    [self.view addSubview:scrollView];
    
//    // input textfield
//    CGRect phoneNumRect = CGRectMake(UI_LAYOUT_MARGIN, 12.f, UI_COMM_BTN_WIDTH, UI_COMM_BTN_HEIGHT);
//    ZXTextField *phoneNumField = [[ZXTextField alloc] initWithFrame:phoneNumRect];
//    phoneNumField.placeholder = MultiLanguage(rsavcInputPhone);
//    phoneNumField.font = FONT_16;
//    phoneNumField.largeTextLength = 11;
//    phoneNumField.keyboardType = UIKeyboardTypeNumberPad;
//    phoneNumField.autoHideKeyboard = YES;
//    [scrollView addSubview:phoneNumField];
//    _phoneNumField = phoneNumField;
//    _phoneNumShowInfo = [ZXCheckUtils addShowInfoByTextField:phoneNumField spuerView:scrollView];
    
    CGRect certifyCodeRect = CGRectMake(UI_LAYOUT_MARGIN, 12.f+yOffSet, UI_COMM_BTN_WIDTH-108.f, UI_COMM_BTN_HEIGHT);
    ZXTextField *certifyCodeField = [[ZXTextField alloc] initWithFrame:certifyCodeRect];
    certifyCodeField.placeholder = MultiLanguage(rsavcInputCode);
    certifyCodeField.font = FONT_16;
    certifyCodeField.largeTextLength = 6;
    certifyCodeField.autoHideKeyboard = YES;
    [scrollView addSubview:certifyCodeField];
    _certifyCodeField = certifyCodeField;
    _codeShowInfo = [ZXCheckUtils addShowInfoByTextField:certifyCodeField spuerView:scrollView];
    CGRect codeShowInfoFrame = _codeShowInfo.frame;
    _codeShowInfo.frame = (CGRect){.origin = CGRectOrigin(codeShowInfoFrame), .size = CGSizeMake(UI_COMM_BTN_WIDTH, CGRectHeight(codeShowInfoFrame))};
    
//    CGRect pwdFieldRect = CGRectMake(UI_LAYOUT_MARGIN, 132.f, UI_COMM_BTN_WIDTH, UI_COMM_BTN_HEIGHT);
//    ZXTextField *pwdField = [[ZXTextField alloc] initWithFrame:pwdFieldRect];
//    pwdField.placeholder = MultiLanguage(rsavcInputPwd);
//    pwdField.font = FONT_16;
//    pwdField.largeTextLength = 20;
//    pwdField.secureTextEntry = YES;
//    pwdField.autoHideKeyboard = YES;
//    [scrollView addSubview:pwdField];
//    _pwdField = pwdField;
//    _pwdShowInfo = [ZXCheckUtils addShowInfoByTextField:pwdField spuerView:scrollView];
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
    // 获取验证码按钮
    CGRect getCodeBtnFrame = CGRectMake(UI_LAYOUT_MARGIN+CGRectGetWidth(certifyCodeRect)+8.f, 12.f+yOffSet, 100.f, UI_COMM_BTN_HEIGHT);
    ZXColorButton *getCodeBtn = [ZXColorButton buttonWithType:EZXBT_BOX_GRAY frame:getCodeBtnFrame title:MultiLanguage(rsavcGetCode) font:FONT_16 block:^{
        [weakSelf clickGetCodeButton];
    }];
    [scrollView addSubview:getCodeBtn];
    _getCodeBtn = getCodeBtn;
    
    // nextstep button
    CGRect nextStepBtnFrame = CGRectMake(UI_LAYOUT_MARGIN, CGRectGetMaxY(certifyCodeField.frame) + 16.f, UI_COMM_BTN_WIDTH, UI_COMM_BTN_HEIGHT);
    UIButton *nextStepBtn = [ZXColorButton buttonWithType:EZXBT_SOLID_GREEN frame:nextStepBtnFrame title:MultiLanguage(fpavcNextStep) font:FONT_18 block:^{
        [weakSelf clickNextStepButton];
    }];
    [scrollView addSubview:nextStepBtn];
    self.nextStepBtn = nextStepBtn;
}

- (void)removeAllUIResources
{
    [_getCodeBtn stopCountdown];
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
        NSString *phoneNumber = [self.itemData valueForKey:@"phoneNum"];
    PhoneRequestDTO * request = [[PhoneRequestDTO alloc] init];
    request.phoneNum = phoneNumber;
    request.rand = [self.itemData valueForKey:@"rand"];
    
    NSNumber *requestTag = [GDataManager asyncRequestByType:NetAdapter_User_ForgotPassword_GetUserKey andObject:request success:^(PhoneResponseCodeDTO *responseDTO) {
        [GCertifyCodeHelper saveVerifySmsSuccess:phoneNumber PageType:K_CT_ForgetVC];
        [GHUDAlertUtils toggleMessage:MultiLanguage(rsavcGetCodeSucceed)];
        
        
        
    } failure:^(ResponseDTO *responseDTO) {
        [_getCodeBtn stopCountdown];
        [GHUDAlertUtils toggleMessage:responseDTO.resultDesc];
    }];
    [self.requestArray addObject:requestTag];
}

- (void)sendRequestToCertifyCode:(NSString*)phone code:(NSString*)code
{
    //    [self pushViewControllerWithName:@"FogotPwdStepBController" block:^(FogotPwdStepBController *fogotPwdStepBVC) {
    //                    fogotPwdStepBVC.phoneNumber = phone;
    //                    fogotPwdStepBVC.cerCode = code;
    //                }];
    
    
    CertifyCodeRequestDTO *request = [[CertifyCodeRequestDTO alloc] init];
    request.phoneNum = phone;
    request.validateMessage = code;
    
    [GHUDAlertUtils toggleLoadingInView:self.view];
    NSNumber *requestTag = [GDataManager asyncRequestByType:NetAdapter_User_ForgotPassword_Certify andObject:request success:^(id responseDTO) {
        [GHUDAlertUtils hideLoadingInView:self.view];
        //验证成功
        
        //[GHUDAlertUtils toggleMessage:@"密码发送成功，请查收密码短信！"];
        
        
        [self pushViewControllerWithName:@"RegisterStepCViewController" itemData:self.itemData block:^(RegisterStepCViewController *obj) {
            obj.isChinaPhoneNum = self.isChinaPhoneNum;
        }];
        
        
    } failure:^(ResponseDTO *responseDTO) {
        [GHUDAlertUtils hideLoadingInView:self.view];
        [GHUDAlertUtils toggleMessage:responseDTO.resultDesc];
    }];
    [self.requestArray addObject:requestTag];
    
}


- (void)sendRequestToRegister
{
//    NSString *username = [_phoneNumField.text copy];
    NSString *certifyCode = [_certifyCodeField.text copy];
//    NSString *password = [_pwdField.text copy];
//    NSString *inviteCode = [_inviteCodeField.text copy];
    //[RTLHelper gotoRootViewController];
    [self pushViewControllerWithName:@"RegisterStepCViewController" block:^(id obj) {
        
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
    
//    _phoneNumField.gesRecognizerBlock = block;
    _certifyCodeField.gesRecognizerBlock = block;
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
    NSString *phoneNumber = [self.itemData valueForKey:@"phoneNum"];
    NSInteger reqCount = [GCertifyCodeHelper getCertifyCodeTimes:phoneNumber PageType:K_CT_RegistVC];
    
        if (reqCount == 0)
        {
            [GHUDAlertUtils toggleMessage:MultiLanguage(fverifySmsTimesOut)];
    
            return;
        }
    
    [_getCodeBtn countdownWithTime:60];
    [self sendRequestToGetCertifyCode];
    
}

- (void)clickNextStepButton
{
    NSString *phoneNum = [self.itemData valueForKey:@"phoneNum"];
    NSString *cerCode = [_certifyCodeField.text copy];
    if ([ZXCheckUtils checkCertifyCode:cerCode showInfo:_codeShowInfo]) {
        [self sendRequestToCertifyCode:phoneNum code:cerCode];
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
//        //        [GHUDAlertUtils toggleMessage:@"请选择同意协议"];
//    }
    
    
    
    
}

@end
