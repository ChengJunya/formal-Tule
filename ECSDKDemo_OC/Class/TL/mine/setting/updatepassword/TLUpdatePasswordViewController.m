//
//  TLUpdatePasswordViewController.m
//  TL
//
//  Created by YONGFU on 5/22/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "TLUpdatePasswordViewController.h"
#import "ZXTextField.h"
#import "ZXColorButton.h"
#import "TLModuleDataHelper.h"
#import "TLModifyPasswordRequestDTO.h"
#import "TLResponseDTO.h"
#import "UserDataHelper.h"
#import "UserInfoDTO.h"
@interface TLUpdatePasswordViewController (){
    CGFloat _yOffSet;
    
    ZXTextField *oldPwdField;
    ZXTextField *newPwdField;
    ZXTextField *reNewPwdField;
}

@end

@implementation TLUpdatePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _yOffSet = NAVIGATIONBAR_HEIGHT + STATUSBAR_HEIGHT;
    self.title = @"修改密码";
    [self addAllUIResources];
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

-(void)addAllUIResources{
    _yOffSet = _yOffSet + UI_Comm_Margin;
    
    // input textfield
    CGRect oldPwdRect = CGRectMake(UI_LAYOUT_MARGIN, _yOffSet, UI_COMM_BTN_WIDTH, UI_COMM_BTN_HEIGHT);
    oldPwdField = [[ZXTextField alloc] initWithFrame:oldPwdRect];
    oldPwdField.placeholder = @"旧密码";
    oldPwdField.font = FONT_16;
    oldPwdField.largeTextLength = 20;
    oldPwdField.secureTextEntry = YES;
    oldPwdField.autoHideKeyboard = YES;
    [self.view addSubview:oldPwdField];
    
    _yOffSet = _yOffSet + UI_Comm_Margin + UI_COMM_BTN_HEIGHT;
    
    // input textfield
    CGRect newPwdRect = CGRectMake(UI_LAYOUT_MARGIN, _yOffSet, UI_COMM_BTN_WIDTH, UI_COMM_BTN_HEIGHT);
    newPwdField = [[ZXTextField alloc] initWithFrame:newPwdRect];
    newPwdField.placeholder = @"新密码";
    newPwdField.font = FONT_16;
    newPwdField.largeTextLength = 20;
    newPwdField.secureTextEntry = YES;
    newPwdField.autoHideKeyboard = YES;
    [self.view addSubview:newPwdField];
    // input textfield
    
        _yOffSet = _yOffSet + UI_Comm_Margin+ UI_COMM_BTN_HEIGHT;
    
    CGRect reNewPwdRect = CGRectMake(UI_LAYOUT_MARGIN, _yOffSet, UI_COMM_BTN_WIDTH, UI_COMM_BTN_HEIGHT);
    reNewPwdField = [[ZXTextField alloc] initWithFrame:reNewPwdRect];
    reNewPwdField.placeholder = @"确认新密码";
    reNewPwdField.font = FONT_16;
    reNewPwdField.largeTextLength = 20;
    reNewPwdField.secureTextEntry = YES;
    reNewPwdField.autoHideKeyboard = YES;
    [self.view addSubview:reNewPwdField];
    
    _yOffSet = _yOffSet + UI_Comm_Margin+ UI_COMM_BTN_HEIGHT;
    
    
    WEAK_SELF(self);
    //updatephone
    CGRect updateBtnFrame = CGRectMake(UI_LAYOUT_MARGIN, _yOffSet, UI_COMM_BTN_WIDTH, UI_COMM_BTN_HEIGHT);
    ZXColorButton *updateBtn = [ZXColorButton buttonWithType:EZXBT_SOLID_GREEN frame:updateBtnFrame title:@"修改密码" font:FONT_18 block:^{
        [weakSelf updatePassword];
    }];
    [self.view addSubview:updateBtn];
    
    
}


-(void)updatePassword{
    if (![newPwdField.text isEqualToString:reNewPwdField.text]) {
        [GHUDAlertUtils toggleMessage:@"密码不一致"];
        return;
    }
    
    if (oldPwdField.text.length==0||newPwdField.text.length==0||reNewPwdField.text.length==0) {
        [GHUDAlertUtils toggleMessage:@"请输入密码"];
        return;
    }
    
    TLModifyPasswordRequestDTO *request = [[TLModifyPasswordRequestDTO alloc] init];
    request.userIndex = GUserDataHelper.tlUserInfo.userIndex;
    request.oldPassword = oldPwdField.text;
    request.password = newPwdField.text;
    
    [GHUDAlertUtils toggleLoadingInView:self.view];
    [GTLModuleDataHelper pwdModify:request requestArr:self.requestArray block:^(id obj, BOOL ret) {
        [GHUDAlertUtils hideLoadingInView:self.view];
        
        TLResponseDTO *response = obj;
        [GHUDAlertUtils toggleMessage:response.resultDesc];
        
        
    }];
    
}

-(void)resetUI{
    newPwdField.text = @"";
    oldPwdField.text = @"";
    reNewPwdField.text = @"";
}
@end
