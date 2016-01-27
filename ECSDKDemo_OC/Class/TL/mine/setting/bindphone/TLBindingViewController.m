//
//  TLBindingViewController.m
//  TL
//
//  Created by YONGFU on 5/22/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "TLBindingViewController.h"
#import "FogotPwdStepBController.h"

#import "ZXTextField.h"
#import "ZXColorButton.h"
#import "ZXUIHelper.h"
#import "ZXCheckUtils.h"

#import "CertifyCodeHelper.h"
#import "UserDataHelper.h"
#import "PhoneRequestDTO.h"
#import "PhoneResponseCodeDTO.h"
#import "CertifyCodeRequestDTO.h"
#import "TLHelper.h"

@interface TLBindingViewController ()
{
    ZXTextField *_phoneNumField;
    ZXTextField *_certifyCodeField;
    ZXColorButton *_getCodeBtn;
    UILabel *_phoneNumShowInfo;
    UILabel *_codeShowInfo;
}

@end


@implementation TLBindingViewController

- (void)viewDidLoad
{
    self.title = @"绑定手机";
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.frame = [[UIScreen mainScreen] bounds];
    self.view.backgroundColor = COLOR_DEF_BG;
    
    
    
    [self addAllUIResources];
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
    WEAK_SELF(self);
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:scrollView];
    
    // input textfield
    CGRect phoneNumRect = CGRectMake(UI_LAYOUT_MARGIN, 12.f+yOffSet, UI_COMM_BTN_WIDTH, UI_COMM_BTN_HEIGHT);
    ZXTextField *phoneNumField = [[ZXTextField alloc] initWithFrame:phoneNumRect];
    phoneNumField.placeholder = @"请输入要绑定的手机";
    phoneNumField.largeTextLength = 14;
    phoneNumField.font = FONT_16;
    phoneNumField.keyboardType = UIKeyboardTypePhonePad;
    phoneNumField.leftIconName = @"tl_phone";
    phoneNumField.autoHideKeyboard = YES;
    [scrollView addSubview:phoneNumField];
    _phoneNumField = phoneNumField;
    _phoneNumShowInfo = [ZXCheckUtils addShowInfoByTextField:phoneNumField spuerView:scrollView];
    
    CGFloat getCodeBtnWidth = 100.f;
    CGRect certifyCodeRect = CGRectMake(UI_LAYOUT_MARGIN, 72.f+yOffSet, UI_COMM_BTN_WIDTH-getCodeBtnWidth-8, UI_COMM_BTN_HEIGHT);
    ZXTextField *certifyCodeField = [[ZXTextField alloc] initWithFrame:certifyCodeRect];
    certifyCodeField.placeholder = MultiLanguage(fpavcInputCode);
    certifyCodeField.largeTextLength = 6;
    certifyCodeField.font = FONT_16;
    certifyCodeField.autoHideKeyboard = YES;
    [scrollView addSubview:certifyCodeField];
    _certifyCodeField = certifyCodeField;
    _codeShowInfo = [ZXCheckUtils addShowInfoByTextField:certifyCodeField spuerView:scrollView];
    CGRect codeShowInfoFrame = _codeShowInfo.frame;
    _codeShowInfo.frame = (CGRect){.origin = CGRectOrigin(codeShowInfoFrame), .size = CGSizeMake(UI_COMM_BTN_WIDTH, CGRectHeight(codeShowInfoFrame))};
    
    // 获取验证码按钮
    CGRect getCodeBtnFrame = CGRectMake(UI_LAYOUT_MARGIN + CGRectGetWidth(certifyCodeRect)+8.f, 72.f+yOffSet, getCodeBtnWidth, UI_COMM_BTN_HEIGHT);
    ZXColorButton *getCodeBtn = [ZXColorButton buttonWithType:EZXBT_BOX_GRAY frame:getCodeBtnFrame title:MultiLanguage(fpavcGetCode) font:FONT_16 block:^{
        [weakSelf clickGetCodeButton];
    }];
    [scrollView addSubview:getCodeBtn];
    _getCodeBtn = getCodeBtn;
    
    // nextstep button
    CGRect nextStepBtnFrame = CGRectMake(UI_LAYOUT_MARGIN, 132.f+yOffSet, UI_COMM_BTN_WIDTH, UI_COMM_BTN_HEIGHT);
    UIButton *nextStepBtn = [ZXColorButton buttonWithType:EZXBT_SOLID_GREEN frame:nextStepBtnFrame title:@"绑定" font:FONT_18 block:^{
        [weakSelf clickNextStepButton];
    }];
    
    
    [scrollView addSubview:nextStepBtn];
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
    PhoneRequestDTO * request = [[PhoneRequestDTO alloc] init];
    request.phoneNum = [_phoneNumField.text copy];
    
    NSNumber *requestTag = [GDataManager asyncRequestByType:NetAdapter_User_ForgotPassword_GetUserKey andObject:request success:^(PhoneResponseCodeDTO *responseDTO) {
        [GCertifyCodeHelper saveVerifySmsSuccess:_phoneNumField.text PageType:K_CT_ForgetVC];
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
        
        [GHUDAlertUtils toggleMessage:@"密码发送成功，请查收密码短信！"];
        
        
        //        [RTLHelper gotoLoginViewController];
        [self pushViewControllerWithName:@"TLForgotPwdStepCControllerViewController" block:^(id obj) {
            
        }];
        
        
    } failure:^(ResponseDTO *responseDTO) {
        [GHUDAlertUtils hideLoadingInView:self.view];
        [GHUDAlertUtils toggleMessage:responseDTO.resultDesc];
    }];
    [self.requestArray addObject:requestTag];
    
    //[RTLHelper gotoLoginViewController];
}

//淘宝验证码
- (void)sendRequestToGetTaobaoCertifyCode
{
    //    ExtRegRequestDTO * request = [[ExtRegRequestDTO alloc] init];
    //    request.mobilephone = [_phoneNumField.text copy];
    //
    //    NSNumber *requestTag = [GDataManager asyncRequestByType:NetAdapter_User_RegisterExt_UserKey andObject:request success:^(ExtRegResponseDTO *responseDTO) {
    //        [GHUDAlertUtils toggleMessage:MultiLanguage(rsavcGetCodeSucceed)];
    //    } failure:^(ResponseDTO *responseDTO) {
    //        [_getCodeBtn stopCountdown];
    //        [GHUDAlertUtils toggleMessage:MultiLanguage(rsavcGetCodeFailure)];
    //    }];
    //    [self.requestArray addObject:requestTag];
}
//淘宝手机号绑定
- (void)sendRequestToTaobaoBinding:(NSString*)phone code:(NSString*)code
{
    //    ExtRegRequestDTO * request = [[ExtRegRequestDTO alloc] init];
    //    request.extUserId = _taobaoUser.user_id;
    //    request.extUserType = @"1";
    //    request.mobilephone = [_phoneNumField.text copy];
    //    request.key = [_certifyCodeField.text copy];
    //    request.recommendCode = @"";
    //    request.nikeName = _taobaoUser.user_nick;
    //    request.tbAccount = _taobaoUser.user_nick;
    //    request.areaCode = @"";
    //    request.fromChannel = PublishAppChannel;
    //    request.versionNum = [GAppversionHelper appVersion];
    //    request.clientType = 2;
    //
    //    [GHUDAlertUtils toggleLoadingInView:self.view];
    //    NSNumber *requestTag = [GDataManager asyncRequestByType:NetAdapter_User_RegisterExt andObject:request success:^(id responseDTO) {
    //        [GHUDAlertUtils hideLoadingInView:self.view];
    //        //绑定成功
    //        if (_taobaoBinding) {
    //            _taobaoBinding(YES);
    //        }
    //    } failure:^(ResponseDTO *responseDTO) {
    //        [GHUDAlertUtils hideLoadingInView:self.view];
    //        [GHUDAlertUtils toggleMessage:responseDTO.retMessage];
    //    }];
    //    [self.requestArray addObject:requestTag];
}


#pragma mark -
#pragma mark - action

- (void)clickGetCodeButton
{
    NSString *phoneNumber = [_phoneNumField.text copy];
    NSInteger reqCount = [GCertifyCodeHelper getCertifyCodeTimes:phoneNumber PageType:K_CT_ForgetVC];
    
    if (reqCount == 0)
    {
        [GHUDAlertUtils toggleMessage:MultiLanguage(fverifySmsTimesOut)];
        
        return;
    }
    
    if ([ZXCheckUtils checkRegPhoneNumber:phoneNumber showInfo:_phoneNumShowInfo]) {
        [_getCodeBtn countdownWithTime:60];
        
        if (_forPurpose == PhoneVerify4ForgetPwd) {
            [self sendRequestToGetCertifyCode];
        }
        else if(_forPurpose == PhoneVerify4TaoBinding) {
            [self sendRequestToGetTaobaoCertifyCode];
        }
    }
}

- (void)clickNextStepButton
{
    NSString *phoneNumber = [_phoneNumField.text copy];
    NSString *cerCode = [_certifyCodeField.text copy];
    
    
    CertifyCodeRequestDTO *request = [[CertifyCodeRequestDTO alloc] init];
    request.phoneNum = phoneNumber;
    request.validateMessage = cerCode;
    request.message = cerCode;
    
    [GHUDAlertUtils toggleLoadingInView:self.view];
    [GDataManager asyncRequestByType:NetAdapter_RebindPhone andObject:request success:^(id responseDTO) {
        [GHUDAlertUtils hideLoadingInView:self.view];
        //验证成功
        
        [GHUDAlertUtils toggleMessage:@"绑定成功！"];
        
        
    } failure:^(ResponseDTO *responseDTO) {
        [GHUDAlertUtils hideLoadingInView:self.view];
        [GHUDAlertUtils toggleMessage:responseDTO.resultDesc];
    }];

}

@end
