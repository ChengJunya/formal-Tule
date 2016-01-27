//
//  TLUpdateUserNickNameViewController.m
//  TL
//
//  Created by YONGFU on 6/8/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "TLUpdateUserNickNameViewController.h"
#import "ZXTextField.h"
#import "TLRenameFriendRequestDTO.h"
#import "TLModuleDataHelper.h"
#import "TLResponseDTO.h"

@interface TLUpdateUserNickNameViewController (){
    CGFloat _yOffSet;
    ZXTextField *inputField;
}

@end

@implementation TLUpdateUserNickNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改好友备注";
    _yOffSet = NAVIGATIONBAR_HEIGHT+STATUSBAR_HEIGHT;
    [self addAllUIResources];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navBarHidden = NO;
    self.navBackItemHidden = NO;
    self.navView.actionBtns = @[[self addCreateActionBtn]];
    
}


- (UIButton*)addCreateActionBtn
{
    
    //    UIImage *backImage = [UIImage imageNamed:@"ico_backon"];
    UIButton *actionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    actionBtn.frame = CGRectMake(0.f, 0.f, 44.f, 44.f);
    [actionBtn setTitleColor:COLOR_NAV_TEXT forState:UIControlStateNormal];
    [actionBtn setTitleColor:COLOR_BTN_BOX_GRAY_TEXT forState:UIControlStateHighlighted];
    [actionBtn setTitle:@"修改" forState:UIControlStateNormal];
    actionBtn.titleLabel.font = FONT_14B;
    //[actionBtn setImage:[UIImage imageNamed:@"more_xiaoxi"] forState:UIControlStateNormal];
    //    [actionBtn setImage:[UIImage imageNamed:@"ico_backon" ] forState:UIControlStateHighlighted];
    [actionBtn addTarget:self action:@selector(addBtnHandler) forControlEvents:UIControlEventTouchUpInside];
    return actionBtn;
}


-(void)addAllUIResources{
    [self addSearchInputView];
}


-(void)addSearchInputView{
    //电话
    CGFloat fieldHeight = 45.f;
    
    
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(0.f, _yOffSet, CGRectGetWidth(self.view.frame), fieldHeight)];
    [searchView setBackgroundColor:UIColorFromRGBA(0xFFFFFF, 1.0f)];
    [self.view addSubview:searchView];
    
    
    
    
    
    inputField = [[ZXTextField alloc] initWithFrame:CGRectMake(UI_Comm_Margin,0.f,searchView.width-UI_Comm_Margin*2,fieldHeight)];
    inputField.placeholder = @"请输入好友备注";
    inputField.largeTextLength = 20;
    inputField.text = @"";
    inputField.font = FONT_16;
    inputField.autoHideKeyboard = YES;
    inputField.zxBorderWidth = 0.f;
    inputField.textColor = COLOR_MAIN_TEXT;
    inputField.tintColor = COLOR_GREEN_TEXT;
    [searchView addSubview:inputField];
    
    
    
    
}

#pragma mark-
#pragma mark- 操作事件
-(void)addBtnHandler{
    [self.view endEditing:YES];
    
    
    if (inputField.text.length==0) {
        [GHUDAlertUtils toggleMessage:@"请输入备注名称"];
        return;
    }

    
    TLRenameFriendRequestDTO *request = [[TLRenameFriendRequestDTO alloc] init];
    request.friendLoginId = self.userInfoDto.loginId;
    request.friendNote = inputField.text;
    
    [GHUDAlertUtils toggleLoadingInView:self.view];
    WEAK_SELF(self);
    [GTLModuleDataHelper reNameFriend:request requestArr:self.requestArray block:^(id obj, BOOL ret) {
        [GHUDAlertUtils hideLoadingInView:self.view];
        TLResponseDTO *response = obj;
        [GHUDAlertUtils toggleMessage:response.resultDesc];
        [weakSelf goBackAction];
    }];

}

-(void)goBackAction{
    [self.navigationController popViewControllerAnimated:YES];
}





#pragma mark-
#pragma mark-隐藏键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [inputField resignFirstResponder];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
