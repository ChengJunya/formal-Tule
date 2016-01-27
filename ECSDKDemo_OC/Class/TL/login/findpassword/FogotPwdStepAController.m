//
//  FogotPwdStepAController.m
//  alijk
//
//  Created by easy on 14-7-30.
//  Copyright (c) 2014年 zhongxin. All rights reserved.
//

#import "FogotPwdStepAController.h"
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
#import "TLPwdFindRequest.h"


@interface FogotPwdStepAController ()
{
    ZXTextField *_phoneNumField;
    ZXTextField *_certifyCodeField;
    ZXColorButton *_getCodeBtn;
    UILabel *_phoneNumShowInfo;
    UILabel *_codeShowInfo;
    
    UITextField *codeField;
}

@end


@implementation FogotPwdStepAController

- (void)viewDidLoad
{
    self.title = MultiLanguage(fpavcTitle);
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
    __weak FogotPwdStepAController *weakSelf = self;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:scrollView];
    
    // input textfield
    CGRect phoneNumRect = CGRectMake(UI_LAYOUT_MARGIN, 12.f+yOffSet, UI_COMM_BTN_WIDTH, UI_COMM_BTN_HEIGHT);
    ZXTextField *phoneNumField = [[ZXTextField alloc] initWithFrame:phoneNumRect];
    phoneNumField.placeholder = MultiLanguage(fpavcInputPhone);
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
    
    
    
    
    UIView *imageCodeView = [[UIView alloc] initWithFrame:CGRectMake(UI_LAYOUT_MARGIN, certifyCodeField.maxY+16.f, UI_COMM_BTN_WIDTH, UI_COMM_BTN_HEIGHT)];
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
    CGRect nextStepBtnFrame = CGRectMake(UI_LAYOUT_MARGIN, imageCodeView.maxY+yOffSet+16.f, UI_COMM_BTN_WIDTH, UI_COMM_BTN_HEIGHT);
    UIButton *nextStepBtn = [ZXColorButton buttonWithType:EZXBT_SOLID_GREEN frame:nextStepBtnFrame title:@"获取新密码 " font:FONT_18 block:^{
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
    NSString *vCode = [codeField.text copy];
    PhoneRequestDTO * request = [[PhoneRequestDTO alloc] init];
    request.phoneNum = [_phoneNumField.text copy];
    request.rand = vCode;
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
        

        TLPwdFindRequest *findPwdRequest = [[TLPwdFindRequest alloc] init];
        findPwdRequest.phoneNum = phone;
        
        [GDataManager asyncRequestByType:NetAdapter_PwdFind andObject:findPwdRequest success:^(ResponseDTO* responseDTO) {
            [GHUDAlertUtils toggleMessage:@"密码发送成功，请查收密码短信！"];
            [self pushViewControllerWithName:@"TLForgotPwdStepCControllerViewController" block:^(id obj) {
                
            }];
        } failure:^(ResponseDTO* responseDTO) {
            [GHUDAlertUtils hideLoadingInView:self.view];
            [GHUDAlertUtils toggleMessage:responseDTO.resultDesc];
        }];
        
//        [RTLHelper gotoLoginViewController];
       
        
        
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
    
    NSString *vCode = [codeField.text copy];
    
    if (vCode.length==0) {
        [GHUDAlertUtils toggleMessage:@"请输入验证码"];
        return;
    }
    
    
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
    }
}

- (void)clickNextStepButton
{
    NSString *phoneNumber = [_phoneNumField.text copy];
    NSString *cerCode = [_certifyCodeField.text copy];
    
    
//    [self pushViewControllerWithName:@"FogotPwdStepBController" block:^(FogotPwdStepBController *fogotPwdStepBVC) {
//        fogotPwdStepBVC.phoneNumber = phoneNumber;
//        fogotPwdStepBVC.cerCode = cerCode;
//    }];
    
    
    if ([ZXCheckUtils checkRegPhoneNumber:phoneNumber showInfo:_phoneNumShowInfo] &&
        [ZXCheckUtils checkCertifyCode:cerCode showInfo:_codeShowInfo]) {
        if (_forPurpose == PhoneVerify4ForgetPwd) {
            [self sendRequestToCertifyCode:phoneNumber code:cerCode];
        }
    }
}

@end
