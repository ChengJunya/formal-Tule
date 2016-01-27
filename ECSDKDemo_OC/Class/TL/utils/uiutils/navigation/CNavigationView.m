//
//  CNavigationView.m
//  ContractManager
//
//  Created by Rainbow on 12/16/14.
//  Copyright (c) 2014 MST Inc. All rights reserved.
//
////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////// MST INC //////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////
//          ____________      ____________     ________________  ____     _________________________   //
//         /            \    /           /    /    ___________ \/   /    /                        /   //
//        /____          \  /       ____/    |    /           \____/    /   _____       _____    /    //
//            /   /\      \/   /|   |        |    |_______________     /___/    /      /    /___/     //
//           /   /  \         / |   |        |                    \            /      /               //
//          /   /    \       /  |   |         \________________    |          /      /                //
//     ____/   /____  \     /___|   |____     ____             |   |     ____/      /____             //
//    /            /   \   //           /    /    \____________/   |    /               /             //
//   /____________/     \_//___________/    /___/\________________/    /_______________/              //
//                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////// Copyright (c) 2014 MST Inc. All rights reserved. /////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////




#import "CNavigationView.h"
@implementation CNavigationView
@synthesize backBtn=_backBtn,actionBtns=_actionBtns;

-(instancetype)initWithFrameAndProperties:(CGRect)frame title:(NSString*)title font:(UIFont*)font color:(UIColor *)color imageName:(NSString*)imageName backBtn:(UIButton*)backBtn actionBtns:(NSArray *)btns bgColor:(UIColor *)bgColor isShowStatusBar:(BOOL)isShowStatusBar viewController:(UIViewController*)viewController{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:bgColor];
        
        
        if (isShowStatusBar) {
            if (IOS_VERSION_CNavigationView<7.0) {
                self.statusHeight = 0;
                self.navHeight = CGRectGetHeight(frame)-self.statusHeight-CSTATUS_HEIGHT;
                self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height-CSTATUS_HEIGHT);
                
                //设置状态栏的颜色为红色
                 [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
                UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0.0, -43.0, 320, 44)];
                navigationBar.tintColor = bgColor;
                [viewController.view addSubview:navigationBar];
                
            }else{
                self.statusHeight = CSTATUS_HEIGHT;
                self.navHeight = CGRectGetHeight(frame)-self.statusHeight;
            }
            
            
            [self initStatusBar:bgColor];
        }else{
            self.statusHeight = 0.0f;
            self.navHeight = CGRectGetHeight(frame);
            
        }
        
        [self initTitle:title font:font color:color imageName:imageName];
        
        self.backBtn = backBtn;
        [self setActionBtns:btns];
        
        
        CALayer *line = [CALayer layer];
        line.borderColor = [COLOR_NAV_BAR_BOTOOM CGColor];
        line.borderWidth = 1.0f;
        line.frame = CGRectMake(0.f, CGRectGetHeight(frame), CGRectGetWidth(frame), 0.5f);
        [self.layer addSublayer:line];

    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        
    }
    return self;
}

-(void)drawRect:(CGRect)rect{
    
}

-(void)initStatusBar:(UIColor *) bgColor{
    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CSTATUS_HEIGHT)];
    statusBarView.backgroundColor=bgColor;
    [self addSubview:statusBarView];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
}

//添加title 文字颜色，字体大小，图片名称，名称
-(void)initTitle:(NSString *)title font:(UIFont*)font color:(UIColor *)color imageName:(NSString*)imageName{
    
    

    CGFloat fromLeftSize = 0.0f;
    CGFloat imageHeight = 0.0f;
    CGFloat imageWidth = 0.0f;
    UIImage *titleImage;
    if (imageName!=nil&&![@"" isEqualToString:imageName]) {
        titleImage = [UIImage imageNamed:imageName];
        //size.height/size.width = frame.height-gap*2/width   width = size.width*(frame.height-gap*2)/size.height
        imageHeight = self.navHeight-CNAVIGATION_V_GAP*2;
        imageWidth = titleImage.size.width*imageHeight/titleImage.size.height;
        fromLeftSize = (CGRectGetWidth(self.frame)-imageWidth)/2;
    }
    
    if (title!=nil&&![@"" isEqualToString:title]) {
       

        NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
        CGSize titleSize  = [title sizeWithAttributes:dic];
        fromLeftSize = (CGRectGetWidth(self.frame)-CNAVIGATION_GAP-imageWidth-titleSize.width)/2;
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(fromLeftSize+imageWidth+CNAVIGATION_GAP, (self.navHeight-titleSize.height)/2+self.statusHeight, titleSize.width, titleSize.height)];
        [titleLabel setFont:font];
        [titleLabel setTextColor:color];
        [titleLabel setText:title];
        [self addSubview:titleLabel];
    }
    
    
    if (titleImage!=nil) {
        
        UIImageView *titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(fromLeftSize,CNAVIGATION_V_GAP+self.statusHeight, imageWidth, imageHeight)];
        [titleImageView setImage:titleImage];
        [self addSubview:titleImageView];
        
        
    }
    
    
    
    
}


-(void)setBackBtn:(UIButton *)backBtn{
    if (_backBtn) {
        [_backBtn removeFromSuperview];
    }
    if (backBtn==nil) {
        return;
    }
    _backBtn = backBtn;
    [_backBtn setFrame:CGRectMake(CNAVIGATION_GAP,(self.navHeight-CGRectGetHeight(_backBtn.frame))/2 +self.statusHeight, CGRectGetWidth(_backBtn.frame), CGRectGetHeight(_backBtn.frame))];
    [self addSubview:_backBtn];
}

//添加返回按钮
//-(void)initBackBtn:(UIButton *)btn{
//    if (btn == nil) {
//        return;
//    }
//    [btn setFrame:CGRectMake(CNAVIGATION_GAP,(self.navHeight-CGRectGetHeight(btn.frame))/2 +self.statusHeight, CGRectGetWidth(btn.frame), CGRectGetHeight(btn.frame))];
//    [self addSubview:btn];
//    
//}



//添加功能按钮
-(void)setActionBtns:(NSArray *)actionBtns{
    for (int i=0; i<_actionBtns.count; i++) {
        UIButton *btn = [_actionBtns objectAtIndex:i];
        if (btn) {
            [btn removeFromSuperview];
        }
    }
    
    if (actionBtns==nil||actionBtns.count==0) {
        return;
    }
    
    _actionBtns = actionBtns;
    CGFloat fromLeft = CGRectGetWidth(self.frame);
    NSUInteger count = [_actionBtns count];
    for (int i=0; i<count; i++) {
        UIButton *btn = [_actionBtns objectAtIndex:i];
        [btn setFrame:CGRectMake(fromLeft-CNAVIGATION_GAP-CGRectGetWidth(btn.frame), (self.navHeight-CGRectGetHeight(btn.frame))/2 +self.statusHeight, CGRectGetWidth(btn.frame), CGRectGetHeight(btn.frame))];
        
        fromLeft = btn.frame.origin.x;
        [self addSubview:btn];
    }

}

///参考知识点----------------------
/*
 
 状态栏颜色设置
 第一种方法:
 
 [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackOpaque;
 
 self.navigationController.navigationBar.tintColor = [UIColor blackColor];
 
 if (is_ios_7_Later) {
 
 self.view.window.frame = CGRectMake(0, 20, self.view.window.frame.size.width, self.view.window.frame.size.height - 20);
 
 [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:NO];
 
 }
 
 第二种方法(这方法比较简单):
 
 UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
 
 statusBarView.backgroundColor=[UIColor blackColor];
 
 [self.view addSubview:statusBarView];
 
 [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
 
 //隐藏状态栏
 [UIApplication sharedApplication] setStatusBarHidden:YES];
 
 以上方式在ios7中无效，ios7中隐藏顶部状态栏的方法为：
 在RootViewController中重写方法prefersStatusBarHidden，增加以下代码：
 
 - (BOOL)prefersStatusBarHidden
 {
 return YES;
 }
 
 */
@end
