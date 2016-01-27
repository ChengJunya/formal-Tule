//
//  DUNavigationController.m
//  alijk
//
//  Created by easy on 14-7-30.
//  Copyright (c) 2014年 zhongxin. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <math.h>
#import "DUNavigationController.h"
#import "SuperViewController.h"
#import "UIBarButtonItem+Badge.h"







#define BackGestureIsOpen 1

@interface DUNavigationController () <UIGestureRecognizerDelegate, UINavigationControllerDelegate>{
    CGPoint startTouch;
    
    UIImageView *lastScreenShotView;
    UIView *blackMask;
}

@property (nonatomic,retain) UIView *backgroundView;
@property (nonatomic,retain) NSMutableArray *screenShotsList;

@property (nonatomic,assign) BOOL isMoving;

@property (nonatomic, strong) UIButton *navTallButton;
@property (nonatomic, strong) NSMutableDictionary *screenShotDict;

@property (nonatomic, copy) NSString *backToVCName;

@property (nonatomic, assign) UIViewController *currentShowVC;
//返回的时候是否有动画效果
@property (nonatomic, assign) BOOL backAnimate;

@end


@implementation DUNavigationController

+ (void)initialize
{
    
    
    
//使用自定义导航栏－－－以下废弃
//    UINavigationBar *navBar = [UINavigationBar appearance];
////    UIImage *navImg = [[UIImage imageNamed:@"title_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
////    [navBar setBackgroundImage:navImg forBarMetrics:UIBarMetricsDefault];
//    
//    NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
//                                               COLOR_NAV_TEXT,NSForegroundColorAttributeName,
//                                               FONT_18, NSFontAttributeName,
//                                               nil];
//
//    [navBar setTitleTextAttributes:navbarTitleTextAttributes];
//    [navBar setBarTintColor:COLOR_NAV_BAR];
//
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
    if (self = [super initWithRootViewController:rootViewController]) {
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        self.screenShotDict = dict;
        self.backAnimate = YES;
        self.interactivePopGestureRecognizer.delegate = self;
        
        self.screenShotsList = [[NSMutableArray alloc]initWithCapacity:2];
        self.canDragBack = YES;
        //不是用导航栏，隐藏掉
        self.navigationBarHidden = YES;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    return self;
}

- (void)dealloc{
    self.screenShotsList = nil;
    [self.backgroundView removeFromSuperview];
    self.backgroundView = nil;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark - method

- (void)showOrHideTallItem:(BOOL)hide
{
    self.navTallButton.hidden  = hide;
}


#pragma mark -
#pragma mark - action





- (void)navBackAction
{
//    [KxMenu dismissMenu:NO];
//    if ([self.topViewController isKindOfClass:[PushConsultViewController class]]) {
//        PushConsultViewController *pushCtrl = (PushConsultViewController *)self.topViewController;
//        [pushCtrl.timer invalidate];
//    }
#if !DELAY_LOGIN_ONE_NAV
    // 如果是点击login页面上的返回按钮，pop出登录nav
    if ([self.topViewController isKindOfClass:[LoginViewController class]]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
#endif
    
    if (self.backToVCName) {
        BOOL findVC = NO;
        for(UIViewController* vc in self.viewControllers){
            if ([vc isKindOfClass:NSClassFromString(self.backToVCName)]) {
                [self popToViewController:vc animated:self.backAnimate];
                findVC = YES;
                break;
            }
        }
        if (!findVC) {
            SuperViewController *pushVC = [[NSClassFromString(self.backToVCName) alloc] init];
            [self.navigationController pushViewController:pushVC animated:YES];
        }
    }
    else {
        [self popViewControllerAnimated:self.backAnimate];
    }
    
    self.backToVCName = nil;
}

- (void)setNavBackToVCName:(NSString*)vcname;
{
    self.backToVCName = vcname;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
#if BackGestureIsOpen
    UIImage *captureImg = [self capture];
    [self.screenShotsList addObject:captureImg];
    [self.screenShotDict setValue:captureImg forKey:NSStringFromClass([self.topViewController class])];
#endif
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
#if BackGestureIsOpen
    [self.screenShotDict removeObjectForKey:NSStringFromClass([self.topViewController class])];
    [self.screenShotsList removeLastObject];
#endif
    
    return [super popViewControllerAnimated:animated];
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
#if BackGestureIsOpen
    for(SuperViewController* vc in [self.viewControllers reverseObjectEnumerator]) {
        if ([NSStringFromClass([vc class]) isEqualToString:NSStringFromClass([viewController class])]) {
            break;
        }
        else {
            [self.screenShotDict removeObjectForKey:NSStringFromClass([viewController class])];
            [self.screenShotsList removeLastObject];
        }
    }
#endif
    
    return [super popToViewController:viewController animated:animated];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
#if BackGestureIsOpen
    UIImageView *shadowImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"leftside_shadow_bg"]];
    shadowImageView.frame = CGRectMake(-10, 0, 10, self.view.frame.size.height);
    [self.view addSubview:shadowImageView];
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self
                                                                                action:@selector(paningGestureReceive:)];
    [recognizer setDelegate:self];
    [recognizer delaysTouchesBegan];
    [self.view addGestureRecognizer:recognizer];
#endif
}

#pragma mark - Utility Methods -

- (UIImage *)capture
{
    CGSize size = KEY_WINDOW.frame.size;
    
    UIGraphicsBeginImageContextWithOptions(size, KEY_WINDOW.opaque, 0.0);
    [KEY_WINDOW.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    return img;
    
}

- (void)moveViewWithX:(float)x
{
    if (self) {
        
    }
    x = x>320?320:x;
    x = x<0?0:x;
    
    CGRect frame = self.view.frame;
    frame.origin.x = x;
    self.view.frame = frame;
    
    float alpha = 0.4 - (x/800);
    
    blackMask.alpha = alpha;
    
    CGFloat aa = abs(startBackViewX)/kkBackViewWidth;
    CGFloat y = x*aa;
    
//    UIImage *lastScreenShot = [self getLastScreenShot];
    
    CGFloat lastScreenShotViewHeight = self.view.frame.size.height; //lastScreenShot.size.height;
    CGFloat superviewHeight = lastScreenShotView.superview.frame.size.height;
    CGFloat verticalPos = superviewHeight - lastScreenShotViewHeight;
    
    [lastScreenShotView setFrame:CGRectMake(startBackViewX+y,
                                            verticalPos,
                                            kkBackViewWidth,
                                            lastScreenShotViewHeight)];
}



-(BOOL)isBlurryImg:(CGFloat)tmp
{
    return YES;
}

- (UIImage *)getLastScreenShot{
    UIImage *lastScreenShot = nil;
    if (self.backToVCName) {
        lastScreenShot = [self.screenShotDict objectForKey:self.backToVCName];
    }else{
        lastScreenShot = [self.screenShotsList lastObject];
    }
    return lastScreenShot;
}

#pragma mark - Gesture Recognizer -

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    CGPoint touchPoint = [gestureRecognizer locationInView:KEY_WINDOW];
    if(touchPoint.x > 30){
        return NO;
    }
    return YES;
}

//不响应的手势则传递下去
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    NSString *topVC = NSStringFromClass([self.topViewController class]);
    if (self.viewControllers.count <= 1 ||
        !self.canDragBack ||
        [topVC isEqualToString:@"HomeViewController"] ||
        [topVC isEqualToString:@"LoginViewController"])
    {
        return NO;
    }
    
    return YES;
}


- (void)paningGestureReceive:(UIPanGestureRecognizer *)recoginzer
{
    if (self.viewControllers.count <= 1 || !self.canDragBack) return;
    
    CGPoint touchPoint = [recoginzer locationInView:KEY_WINDOW];

    if (recoginzer.state == UIGestureRecognizerStateBegan) {
        
        _isMoving = YES;
        startTouch = touchPoint;
        
        if (!self.backgroundView)
        {
            CGRect frame = self.view.frame;
            
            self.backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
            [self.view.superview insertSubview:self.backgroundView belowSubview:self.view];
            
            blackMask = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
            blackMask.backgroundColor = [UIColor blackColor];
            [self.backgroundView addSubview:blackMask];
        }
        
        self.backgroundView.hidden = NO;
        
        if (lastScreenShotView) [lastScreenShotView removeFromSuperview];
        
        UIImage *lastScreenShot = [self getLastScreenShot];
        
        lastScreenShotView = [[UIImageView alloc]initWithImage:lastScreenShot];
        
        startBackViewX = startX;
        [lastScreenShotView setFrame:CGRectMake(startBackViewX,
                                                lastScreenShotView.frame.origin.y,
                                                lastScreenShotView.frame.size.height,
                                                lastScreenShotView.frame.size.width)];
        
        [self.backgroundView insertSubview:lastScreenShotView belowSubview:blackMask];
        
    }else if (recoginzer.state == UIGestureRecognizerStateEnded){
        
        if (touchPoint.x - startTouch.x > 50)
        {
            [UIView animateWithDuration:0.3 animations:^{
                [self moveViewWithX:320];
            } completion:^(BOOL finished) {
                self.backAnimate = NO;
                
                [self clearImagesWhenBackToHomeVC];
                
                [self navBackAction];
                
                self.backAnimate = YES;
                
                
                CGRect frame = self.view.frame;
                frame.origin.x = 0;
                self.view.frame = frame;
                
                _isMoving = NO;
               
            }];
        }
        else
        {
            [UIView animateWithDuration:0.3 animations:^{
                [self moveViewWithX:0];
            } completion:^(BOOL finished) {
                _isMoving = NO;
                self.backgroundView.hidden = YES;
            }];
        }
        return;
        
    }else if (recoginzer.state == UIGestureRecognizerStateCancelled){
        
        [UIView animateWithDuration:0.3 animations:^{
            [self moveViewWithX:0];
        } completion:^(BOOL finished) {
            _isMoving = NO;
            self.backgroundView.hidden = YES;
        }];
        
        return;
    }
    
    if (_isMoving) {
//        if ([self.topViewController isKindOfClass:[AddressSearchController class]] && !_isResinKeyboard) {
//            AddressSearchController *topVC = (AddressSearchController *)self.topViewController;
//            if (topVC.resultView.searchBar.isFirstResponder) {
//                [topVC.resultView.searchBar resignFirstResponder];
//                _isResinKeyboard = YES;
//            }
//        }
        [self moveViewWithX:touchPoint.x - startTouch.x];
    }
}

- (void)clearImagesWhenBackToHomeVC{
    if([NSStringFromClass([self.topViewController class]) isEqualToString:@"HomeViewController"]){
        UIImage *lastScreenShot = [self.screenShotDict objectForKey:self.backToVCName];
        [self.screenShotsList removeAllObjects];
        [self.screenShotsList addObject:lastScreenShot];
        for (NSString *key in self.screenShotDict) {
            if (![key isEqualToString:@"HomeViewController"]) {
                [self.screenShotDict removeObjectForKey:key];
            }
        }
    }
}

@end
