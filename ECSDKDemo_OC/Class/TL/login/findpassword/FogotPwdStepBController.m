//
//  FogotPwdStepBController.m
//  alijk
//
//  Created by easy on 14-7-30.
//  Copyright (c) 2014年 zhongxin. All rights reserved.
//

#import "FogotPwdStepBController.h"

#import "TLHomeViewController.h"
#import "ZXTextField.h"
#import "ZXUIHelper.h"
#import "ZXCheckUtils.h"
#import "ZXColorButton.h"
#import "TLHelper.h"

@interface FogotPwdStepBController ()
{
    ZXTextField *_newPwdField;
    ZXTextField *_pwdAgainField;
    UIImageView *_successImageView;
    UILabel *_newPwdShowInfo;
    UILabel *_pwdAgainShowInfo;
}

@end


@implementation FogotPwdStepBController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.frame = [[UIScreen mainScreen] bounds];
    self.view.backgroundColor = COLOR_DEF_BG;
    
    self.title = MultiLanguage(fpbvcTitle);
   
    [self addAllUIResources];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navBarHidden = NO;
    self.navBackItemHidden = NO;
    [self addNotification];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removeNotification];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)dealloc
{
    [self removeNotification];
    self.phoneNumber = nil;
    self.cerCode = nil;
    self.passwordNew = nil;
}

#pragma mark -
#pragma mark - ui

- (void)addAllUIResources
{
    CGFloat yOffSet = NAVIGATIONBAR_HEIGHT+STATUSBAR_HEIGHT;
    __weak FogotPwdStepBController *weakSelf = self;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:scrollView];
    
    // input textfield
    CGRect phoneNumRect = CGRectMake(UI_LAYOUT_MARGIN, 12.f+yOffSet, UI_COMM_BTN_WIDTH, UI_COMM_BTN_HEIGHT);
    ZXTextField *newPwdField = [[ZXTextField alloc] initWithFrame:phoneNumRect];
    newPwdField.placeholder = MultiLanguage(fpbvcNewPwd);
    newPwdField.font = FONT_16;
    newPwdField.largeTextLength = 20;
    newPwdField.secureTextEntry = YES;
    newPwdField.autoHideKeyboard = YES;
    [scrollView addSubview:newPwdField];
    _newPwdField = newPwdField;
    _newPwdShowInfo = [ZXCheckUtils addShowInfoByTextField:newPwdField spuerView:scrollView];
    
    CGRect adjustCodeRect = CGRectMake(UI_LAYOUT_MARGIN, 72.f+yOffSet, UI_COMM_BTN_WIDTH, UI_COMM_BTN_HEIGHT);
    ZXTextField *pwdAgainField = [[ZXTextField alloc] initWithFrame:adjustCodeRect];
    pwdAgainField.placeholder = MultiLanguage(fpbvcPwdAgain);
    pwdAgainField.font = FONT_16;
    pwdAgainField.largeTextLength = 20;
    pwdAgainField.secureTextEntry = YES;
    pwdAgainField.autoHideKeyboard = YES;
    [scrollView addSubview:pwdAgainField];
    _pwdAgainField = pwdAgainField;
    _pwdAgainShowInfo = [ZXCheckUtils addShowInfoByTextField:pwdAgainField spuerView:scrollView];
    
    // correct image
    UIImage *successImage = [UIImage imageNamed:@"ico_success.png"];
    _successImageView = [ZXUIHelper addUIImageViewWithImage:successImage size:CGSizeMake(18.f, 18.f) center:CGPointMake(290.f, 92.f) anchorPoint:CGPointMake(0.5f, 0.5f) toTarget:scrollView];
    _successImageView.hidden = YES;

    // save button
    CGRect saveBtnFrame = CGRectMake(UI_LAYOUT_MARGIN, 132.f+yOffSet, UI_COMM_BTN_WIDTH, UI_COMM_BTN_HEIGHT);
    UIButton *saveBtn = [ZXColorButton buttonWithType:EZXBT_SOLID_GREEN frame:saveBtnFrame title:MultiLanguage(fpbvcNextStep) font:FONT_18 block:^{
        [weakSelf clickSaveButton];
    }];
    [scrollView addSubview:saveBtn];
}

- (void)removeAllUIResources
{
    //
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark - notification

- (void)addNotification
{
    [GNotifyCenter addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)removeNotification
{
    [GNotifyCenter removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

-(void)textFieldTextDidChange:(UITextField*)textField
{
    if (_pwdAgainField == textField) {
        NSString *pwdNew = [_newPwdField.text copy];
        NSString *pwdAgain = [_pwdAgainField.text copy];
        if (![pwdAgain isEqualToString:@""] && [pwdAgain isEqualToString:pwdNew]) {
            _successImageView.hidden = NO;
        }
    }
}


#pragma mark -
#pragma mark - net request

- (void)sendRequestToUpdatePassword:(NSString*)passwordNew
{
//    [GHUDAlertUtils toggleLoadingInView:self.view];
//    [GUserDataHelper updatePasswordWithUserName:self.phoneNumber password:passwordNew block:^(BOOL value) {
//        [GHUDAlertUtils hideLoadingInView:self.view];
//        if (value) {
//            [self sendRequestToLogin];
//        }
//        else {
//            [GHUDAlertUtils toggleMessage:MultiLanguage(fpbvcUpdatePwdFailure)];
//        }
//    }];
}

- (void)sendRequestToLogin
{
//    [GHUDAlertUtils toggleLoadingInView:self.view];
//    [GUserDataHelper loginWithUsername:self.phoneNumber password:self.passwordNew block:^(ResponseDTO *obj, BOOL ret) {
//        [GHUDAlertUtils hideLoadingInView:self.view];
//        if (ret) {
//            [self gotoNextVCWhenLoginSucceed:YES];
//        }
//        else {
//            [GHUDAlertUtils toggleMessage:obj.retMessage];
//        }
//    }];
}


#pragma mark -
#pragma mark - action

- (void)clickSaveButton
{
    NSString *pwdNew = [_newPwdField.text copy];
    NSString *pwdAgain = [_pwdAgainField.text copy];
//    if ([ZXCheckUtils checkPassword:pwdNew showInfo:_newPwdShowInfo] &&
//        [ZXCheckUtils checkPassword:pwdAgain showInfo:_pwdAgainShowInfo] &&
//        [ZXCheckUtils checkPassword:pwdNew pwdAgain:pwdAgain showInfo:_pwdAgainShowInfo]) {
//        self.passwordNew = pwdNew;
//        [self sendRequestToUpdatePassword:pwdNew];
//    }
    
    [GUserDefault setObject:@{@"userId":@"userId"} forKey:UserDefault_LoginUser];
    
    [RTLHelper gotoRootViewController];
}

@end
