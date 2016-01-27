//
//  TLBindPhoneViewController.m
//  TL
//
//  Created by YONGFU on 5/22/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "TLBindPhoneViewController.h"
#import "RUILabel.h"
#import "ZXTextField.h"
#import "ZXColorButton.h"
#import "UserDataHelper.h"
#import "UserInfoDTO.h"
#import "TLHelper.h"

@interface TLBindPhoneViewController (){
    CGFloat _yOffSet;
    NSString *phone;
    BOOL isBind;
    BOOL isEditing;
    
    RUILabel *unbindLabel;
    //ZXTextField *phoneNumField;
    UIButton *bindBtn;
    UIButton *updateBtn;
}

@end

@implementation TLBindPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _yOffSet = NAVIGATIONBAR_HEIGHT + STATUSBAR_HEIGHT;
    self.title = @"绑定手机";
    
    
    phone = GUserDataHelper.tlUserInfo.phoneNum;
    if (phone.length==0) {
        isBind = NO;
    }else{
        isBind = YES;
    }
    
    
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
    
    WEAK_SELF(self);
    CGFloat infoViewHeight = 50.f;
    CGFloat bindBtnWidth = 80.f;
    CGFloat bindBtnHeight = UI_COMM_BTN_HEIGHT;
    UIView *infoView = [[UIView alloc] initWithFrame:CGRectMake(0.f, _yOffSet, CGRectGetWidth(self.view.frame), infoViewHeight)];
    [infoView setBackgroundColor:UIColorFromRGBA(0xFFFFFF, 1.0f)];
    [self.view addSubview:infoView];
    
    //label
    unbindLabel = [[RUILabel alloc] initWithFrame:CGRectZero str:@"未绑定手机" font:FONT_16 color:COLOR_MAIN_TEXT];
//    [unbindLabel setX:UI_Comm_Margin andY:(infoViewHeight-unbindLabel.height)/2];
    unbindLabel.frame = CGRectMake(UI_Comm_Margin, (infoViewHeight-unbindLabel.height)/2, infoView.width-UI_Comm_Margin*3-bindBtnWidth, unbindLabel.height);
    [infoView addSubview:unbindLabel];
    
    
    //phone
//    CGRect phoneNumRect = CGRectMake(UI_Comm_Margin, (infoViewHeight-UI_COMM_BTN_HEIGHT)/2, infoView.width-bindBtnWidth-UI_Comm_Margin*3, UI_COMM_BTN_HEIGHT);
//    phoneNumField = [[ZXTextField alloc] initWithFrame:phoneNumRect];
//    phoneNumField.placeholder = MultiLanguage(rsavcInputPhone);
//    phoneNumField.font = FONT_16;
//    phoneNumField.textColor = COLOR_MAIN_TEXT;
//    phoneNumField.leftIconName = @"tl_phone";
//    phoneNumField.largeTextLength = 15;
//    phoneNumField.keyboardType = UIKeyboardTypeNumberPad;
//    phoneNumField.autoHideKeyboard = YES;
//    phoneNumField.text = @"+86";
//    [infoView addSubview:phoneNumField];
//    
//    phoneNumField.hidden = YES;

    
    //binbtn/unbind
    bindBtn = [ZXColorButton buttonWithType:EZXBT_BOX_GREEN frame:CGRectMake(infoView.width-bindBtnWidth-UI_Comm_Margin, (infoViewHeight-bindBtnHeight)/2, bindBtnWidth, bindBtnHeight) title:@"绑定" font:FONT_16 block:^{
        [weakSelf bindBtnHadnler];
    }];
    [infoView addSubview:bindBtn];
    
    
    _yOffSet = _yOffSet + infoViewHeight + UI_Comm_Margin;
    
    
    //updatephone
    CGRect updateBtnFrame = CGRectMake(UI_LAYOUT_MARGIN, _yOffSet, UI_COMM_BTN_WIDTH, UI_COMM_BTN_HEIGHT);
    updateBtn = [ZXColorButton buttonWithType:EZXBT_SOLID_GREEN frame:updateBtnFrame title:@"更改手机" font:FONT_18 block:^{
        [weakSelf updateBtnHandler];

    }];
    [self.view addSubview:updateBtn];
    
    [self updateUI];
}

-(void)updateUI{
    
    
    if (isBind) {//绑定 未编辑
        unbindLabel.hidden = NO;
        //phoneNumField.hidden = YES;
        updateBtn.hidden = NO;
        
        
        
        unbindLabel.text = phone;
        //phoneNumField.text = phone;
        [bindBtn setTitle:@"解绑" forState:UIControlStateNormal];
        [updateBtn setTitle:@"更改手机" forState:UIControlStateNormal];
    }else{
        unbindLabel.hidden = NO;
        //        phoneNumField.hidden = YES;
        updateBtn.hidden = YES;
        
        
        
        unbindLabel.text = @"未绑定手机";
        [bindBtn setTitle:@"绑定" forState:UIControlStateNormal];
        //        phoneNumField.text = @"+86";
        [updateBtn setTitle:@"更改手机" forState:UIControlStateNormal];
    }
    
    
//    if (isBind&&!isEditing) {//绑定 未编辑
//        unbindLabel.hidden = NO;
//        //phoneNumField.hidden = YES;
//        updateBtn.hidden = NO;
//        
//        
//        
//        unbindLabel.text = phone;
//        //phoneNumField.text = phone;
//        [bindBtn setTitle:@"解绑" forState:UIControlStateNormal];
//        [updateBtn setTitle:@"更改手机" forState:UIControlStateNormal];
//    }else if(isBind&&isEditing){//绑定 编辑
//        unbindLabel.hidden = YES;
//        //phoneNumField.hidden = NO;
//        updateBtn.hidden = NO;
//        
//        unbindLabel.text = phone;
//        [bindBtn setTitle:@"解绑" forState:UIControlStateNormal];
////        phoneNumField.text = phone;
//        [updateBtn setTitle:@"保存" forState:UIControlStateNormal];
//    }else if(!isBind&&!isEditing){//未绑定 未编辑
//        unbindLabel.hidden = NO;
////        phoneNumField.hidden = YES;
//        updateBtn.hidden = YES;
//        
//        
//        
//        unbindLabel.text = @"未绑定手机";
//        [bindBtn setTitle:@"绑定" forState:UIControlStateNormal];
////        phoneNumField.text = @"+86";
//        [updateBtn setTitle:@"更改手机" forState:UIControlStateNormal];
//    }else if(!isBind&&isEditing){//未绑定 编辑
//        unbindLabel.hidden = YES;
////        phoneNumField.hidden = NO;
//        updateBtn.hidden = NO;
//        
//        
//        
//        unbindLabel.text = @"未绑定手机";
////        phoneNumField.text = @"+86";
//        [bindBtn setTitle:@"绑定" forState:UIControlStateNormal];
//        [updateBtn setTitle:@"保存" forState:UIControlStateNormal];
//    }
}

-(void)updateBtnHandler{
   
   [RTLHelper pushViewControllerWithName:@"TLBindingViewController" block:^(id obj) {
       
   }];

}

-(void)bindBtnHadnler{
    if (isBind) {
        //做解绑处理
    }else{
        [RTLHelper pushViewControllerWithName:@"TLBindingViewController" block:^(id obj) {
            
        }];
    }
    
}
@end
