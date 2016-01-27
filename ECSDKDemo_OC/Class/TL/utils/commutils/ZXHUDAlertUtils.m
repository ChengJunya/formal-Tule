//
//  ZXHUDAlertUtils.m
//  alijk
//
//  Created by easy on 14/11/13.
//  Copyright (c) 2014年 zhongxin. All rights reserved.
//

#import "ZXHUDAlertUtils.h"
#import "MBProgressHUD.h"
#import "CRToast.h"

@implementation BlockAlertView

@end


@interface ZXHUDAlertUtils () <UIAlertViewDelegate, MBProgressHUDDelegate>
{
    BOOL _isShowTip;
}

@property (nonatomic, strong) MBProgressHUD* msgHUD;
@property (nonatomic, strong) ZXColorAlert* alert;
@property (nonatomic, assign) CGFloat keyboardOffsetY;

@end

@implementation ZXHUDAlertUtils

+ (ZXHUDAlertUtils*)shareInstance
{
    static ZXHUDAlertUtils *_shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareInstance = [[ZXHUDAlertUtils alloc] init];
    });
    
    return _shareInstance;
}


#pragma mark-
#pragma mark init

- (id)init
{
    if (self = [super init]) {
        _isShowTip = NO;
        [self addNotification];
    }
    
    return self;
}

- (void)dealloc
{
    [self removeNotification];
}


#pragma mark -
#pragma mark - loading hud

/*
 * 显示loading hud
 */
- (void)toggleLoadingInView:(UIView*)view
{
    [MBHUDView hudWithSuperView:view show:YES];
}

/*
 * 隐藏loading hud
 */
- (void)hideLoadingInView:(UIView*)view
{
    if (view) {
        [MBHUDView dismissCurrentHUDWithSuperView:view];
    }
}

/*
 * 程序重后台进入前台时，重启loading view
 */
- (void)resumeHUDWhenAppBecomeActive
{
    [[MBHUDView currentAlert] layoutView];
}

/*
 * 进入新的VC时，将之前所有存在的HUD删除
 */
- (void)dismissAllHUDWhenEnterVC
{
    while ([MBHUDView getDismissQueenCount]) {
        [MBHUDView dismissCurrentHUD];
    }
    
    if ([MBHUDView getRetainQueenCount] > 0) {
        [MBHUDView removeAllRetainQueueObject];
    }
}

#pragma mark -
#pragma mark - message hud

-(void)toggleMessage:(NSString*)message
{
    if ([message isEqualToString:@"未登录"]) {
        return;
    }
    [self toastMessage2:message];
//    [self toggleMessage:message at:TOAST_UNDER_NAV];
}

-(void)toggleMessage:(NSString*)message at:(TOAST_LOC)loc
{
    if (message && !_isShowTip) {
        _isShowTip = YES;
        NSMutableDictionary *options = [@{
                                          kCRToastTextKey : message,
                                          kCRToastFontKey : FONT_16,
                                          kCRToastTextColorKey : COLOR_WHITE_TEXT,
                                          kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionTop),
                                          kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionTop),
                                          kCRToastAnimationInTypeKey : @(CRToastAnimationTypeLinear),
                                          kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeLinear),
                                          kCRToastNotificationPresentationTypeKey : @(CRToastPresentationTypeCover),
                                          kCRToastBackgroundColorKey : [COLOR_BTN_SOLID_ORANGE_SUFACE colorWithAlphaComponent:0.9]
                                          } mutableCopy];
        
        if (loc == TOAST_ON_TOP) {
            [options setValue:@(CRToastTypeNavigationBar) forKey:kCRToastNotificationTypeKey];
            [options setValue:@(YES) forKey:kCRToastUnderStatusBarKey];
        }
        else if (loc == TOAST_UNDER_NAV) {
            [options setValue:@(CRToastTypeCustom) forKey:kCRToastNotificationTypeKey];
            [options setValue:@(40) forKey:kCRToastNotificationPreferredHeightKey];
            [options setValue:@(NO) forKey:kCRToastUnderStatusBarKey];
        }
        
        [CRToastManager showNotificationWithOptions:options completionBlock:^{
            _isShowTip = NO;
        }];
    }
}

-(void)toastMessage2:(NSString*)message
{
    if (nil == message || [message isEqualToString:@""]) {
        return;
    }
    
    if (nil != self.msgHUD) {
        return;
    }
    
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    MBProgressHUD* msgHUD = [MBProgressHUD showHUDAddedTo:keyWindow animated:YES];
    msgHUD.mode = MBProgressHUDModeText;
    msgHUD.detailsLabelFont = FONT_16;
    msgHUD.detailsLabelText = message;
    msgHUD.yOffset = CGRectGetHeight(keyWindow.frame) / 2.f - 60.f - self.keyboardOffsetY;
    msgHUD.removeFromSuperViewOnHide = YES;
    msgHUD.delegate = self;
    [msgHUD hide:YES afterDelay:1.5];
    
    self.msgHUD = msgHUD;
}

-(void)hudWasHidden:(MBProgressHUD *)hud
{
    if (self.msgHUD) {
        [self.msgHUD removeFromSuperview];
        self.msgHUD = nil;
    }
}


#pragma mark -
#pragma mark - alert

/*
 * 显示自定义的提示框
 * 如果只想要一个确定键，那么就给cancletitle 传入 nil；
 */
-(void)showZXColorAlert:(NSString*)title subTitle:(NSString*)subtitle cancleButton:(NSString*)cancleTitle sureButtonTitle:(NSString*)sureTitle COLORButtonType:(COLORBUTTONTYPE)type buttonHeight:(CGFloat)height clickedBlock:(ZXAlertBlock)block
{
    NSArray* btnTitleArr;
    if (cancleTitle == nil || cancleTitle.length == 0) {
        btnTitleArr = [NSArray arrayWithObjects:sureTitle, nil];
    }
    else {
        btnTitleArr = [NSArray arrayWithObjects:cancleTitle,sureTitle, nil];
    }
    
    if (self.alert) {
        [self.alert removeFromSuperview];
        self.alert= nil;
    }
    
    ZXColorAlert *alert = [[ZXColorAlert alloc] initWithButtonTitles:btnTitleArr alertTitle:title subTitle:subtitle buttonHeight:height];
    
    NSString *nImage = @"btn_green_n";
    NSString *pImage = @"btn_green_p";
    if (type == RED_BUTTON_TYPE) {
        nImage = @"btn_red_n";
        pImage = @"btn_red_p";
    }else if (type==SAME_BUTTON_TYPE){
        nImage = @"btn_red_n";
        pImage = @"btn_red_n";
    }
    [alert setButtonBackGroundImage:[UIImage resizedImage:nImage leftScale:0.2 topScale:0.2] forState:(UIControlStateNormal)];
    [alert setButtonBackGroundImage:[UIImage resizedImage:pImage leftScale:0.2 topScale:0.2] forState:(UIControlStateHighlighted)];
    
    [alert showAlertInView:[[UIApplication sharedApplication] keyWindow]];
    [alert alertSelectBlock:^(ZXColorAlert *aler, NSUInteger index) {
        if (block) {
            block(alert,index);
        }
    }];
    
    self.alert = alert;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    BlockAlertView* bAlert = (BlockAlertView*)alertView;
    if (bAlert.block) {
        bAlert.block(bAlert,buttonIndex);
    }
}

/*
 * 使zxcolorAler消失
 */
-(void)hideAlert
{
    if (self.alert) {
        self.alert.hidden = YES;
        [self.alert removeFromSuperview];
        self.alert = nil;
    }
}


#pragma mark -
#pragma mark - notification

- (void)addNotification
{
    [GNotifyCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [GNotifyCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)removeNotification
{
    [GNotifyCenter removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [GNotifyCenter removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    self.keyboardOffsetY = keyboardRect.size.height;
    
}
- (void)keyboardWillHide:(NSNotification *)notification
{
    self.keyboardOffsetY = 0;
}
    
@end
