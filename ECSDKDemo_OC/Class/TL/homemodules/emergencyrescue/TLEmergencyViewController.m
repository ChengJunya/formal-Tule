//
//  TLEmergencyViewController.m
//  TL
//
//  Created by Rainbow on 2/20/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "TLEmergencyViewController.h"
#import "ZXColorButton.h"
#import "TLModuleDataHelper.h"
@interface TLEmergencyViewController (){
    CGFloat yOffSet;
    UIButton *sendEmegencyBtn;
}

@end

@implementation TLEmergencyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"应急救援";
    [self addAllUIResources];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navBarHidden = NO;
    self.navBackItemHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addAllUIResources{
    yOffSet = NAVIGATIONBAR_HEIGHT+STATUSBAR_HEIGHT;
    CGFloat vGap = 10.f;
    CGFloat hGap = 10.f;
    CGFloat vContentGap = 20.f;
    CGFloat hContentGap = 20.f;
    CGFloat imageWidth = 50.f;
    UIView *infoView = [[UIView alloc] initWithFrame:CGRectMake(0.f, yOffSet+vGap, CGRectGetWidth(self.view.frame), 180.f)];
    [self.view addSubview:infoView];
    infoView.backgroundColor = UIColorFromRGBA(0xFFFFFF, 0.5);
    NSString *title = @"应急救援";
    NSDictionary *dic18 = [NSDictionary dictionaryWithObjectsAndKeys:FONT_18B,NSFontAttributeName, nil];
    NSDictionary *dic16 = [NSDictionary dictionaryWithObjectsAndKeys:FONT_16,NSFontAttributeName, nil];
    CGSize titleSize = [title sizeWithAttributes:dic18];
    
    CGFloat paddingLeft = (CGRectGetWidth(infoView.frame)-titleSize.width-imageWidth-hGap)/2;
    UIImageView *emergencyIcon = [[UIImageView alloc] initWithFrame:CGRectMake(paddingLeft, vContentGap, imageWidth, imageWidth)];
    emergencyIcon.image = [UIImage imageNamed:@"SOS"];
    [infoView addSubview:emergencyIcon];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(paddingLeft+hGap+imageWidth, vContentGap+(imageWidth-titleSize.height)/2, titleSize.width, titleSize.height)];
    titleLabel.text = title;
    titleLabel.font = FONT_18B;
    titleLabel.textColor = UIColorFromRGBA(0xb699f2, 1.f);
    [infoView addSubview:titleLabel];
    

    
    NSString *info = @"在遇到意外需要救援的情况下使用，工作人员收到您的信号会马上联系您。备注：只有认证用户才可发起救援，未认证请到首页-个人中心认证，途乐免责。";
    CGRect infoFrame =  [info boundingRectWithSize:CGSizeMake(CGRectGetWidth(infoView.frame)-hContentGap*2,1000) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin) attributes:dic16 context:nil];
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(hContentGap, vContentGap*2+imageWidth,CGRectGetWidth(infoView.frame)-hContentGap*2, CGRectGetHeight(infoFrame))];
    infoLabel.text = info;
    infoLabel.font = FONT_16;
    infoLabel.textColor = COLOR_MAIN_TEXT;
    infoLabel.numberOfLines = 0;
    [infoView addSubview:infoLabel];

    yOffSet = yOffSet + CGRectGetHeight(infoView.frame) + vGap;
    
    WEAK_SELF(self);
    sendEmegencyBtn = [ZXColorButton buttonWithType:EZXBT_SOLID_GREEN frame:CGRectMake(hGap, yOffSet+vGap, CGRectGetWidth(self.view.frame)-hGap*2, 40.f) title:@"发出急救信号" font:FONT_18 block:^{
        [weakSelf sendSOS];
    }];
    
    [self.view addSubview:sendEmegencyBtn];
    
    
    //认证用户才可发
    if (![GUserDataHelper isUserAuth]) {
        sendEmegencyBtn.enabled = NO;
    }
    
    
}

-(void)sendSOS{
    [GHUDAlertUtils toggleLoadingInView:self.view];
    [GTLModuleDataHelper makeSos:self.requestArray block:^(ResponseDTO *obj, BOOL ret) {
        [GHUDAlertUtils hideLoadingInView:self.view];
        if (ret) {
            
            [GHUDAlertUtils toggleMessage:obj.resultDesc];
            sendEmegencyBtn.enabled = NO;
            
        }else{
            [GHUDAlertUtils toggleMessage:obj.resultDesc];
        }
    }];
}
@end
