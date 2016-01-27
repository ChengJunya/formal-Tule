//
//  DUShareViewController.m
//  alijk
//
//  Created by lipeng on 14/12/19.
//  Copyright (c) 2014年 zhongxin. All rights reserved.
//

#import "DUShareViewController.h"
#import "UMSocial.h"

#define ShareViewHeight 120

@interface DUShareViewController ()
{
    UIView *shareBtnView;
    UIView *bgView;
}

@end

@implementation DUShareViewController

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addAllUIResources];
    //[self initShareSec];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [UIView animateWithDuration:0.2 animations:^{
        [shareBtnView setY:self.view.height-ShareViewHeight];
        bgView.alpha = 0.5;
    }];
}

- (void)addAllUIResources
{
    self.view.backgroundColor = [UIColor clearColor];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sharePageDone)];
    
    bgView = [[UIView alloc] initWithFrame:self.view.bounds];
    [bgView addGestureRecognizer:gesture];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0.0;
    [self.view addSubview:bgView];
    
    shareBtnView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height, self.view.width, ShareViewHeight)];
    shareBtnView.backgroundColor = COLOR_DEF_BG;
    [self.view addSubview:shareBtnView];
    
    UIImage *pyqImage = [UIImage imageNamed:@"ico_pyq"];
    UIImage *wxhyImage = [UIImage imageNamed:@"ico_wxhy"];
    UIImage *sinaImage = [UIImage imageNamed:@"sina"];
    UIImage *qqImage = [UIImage imageNamed:@"qq"];
    
    CGFloat textHeight = 30;
    CGFloat imagePadding = (shareBtnView.width-pyqImage.width*4) /5;
    
    CGFloat btnY =  (shareBtnView.height-pyqImage.height-textHeight)*0.5;
    //微信朋友圈
    UIButton *pyqBtn = [[UIButton alloc] initWithFrame:CGRectMake(imagePadding,btnY, pyqImage.width, pyqImage.height)];
    [pyqBtn setBackgroundImage:pyqImage forState:UIControlStateNormal];
    [pyqBtn addTarget:self action:@selector(shareToPyq) forControlEvents:UIControlEventTouchUpInside];
    [shareBtnView addSubview:pyqBtn];
    
    UILabel *pyqLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(pyqBtn.frame), pyqBtn.width+imagePadding*2, textHeight)];
    pyqLabel.text = @"微信朋友圈";
    pyqLabel.textAlignment = NSTextAlignmentCenter;
    pyqLabel.font = FONT_14;
    pyqLabel.textColor = COLOR_MAIN_TEXT;
    [shareBtnView addSubview:pyqLabel];
    UIApplication *app = [UIApplication sharedApplication];
    if (![app canOpenURL:[NSURL URLWithString:@"weixin://"]]) {
        pyqBtn.frame = CGRectMake(0, 0, 0, 0);
        pyqLabel.frame = CGRectMake(0, 0, 0, 0);
    }
    
    //微信好友
    UIButton *wxhyBtn = [[UIButton alloc] initWithFrame:CGRectMake(pyqBtn.maxX+imagePadding, btnY, pyqImage.width, pyqImage.height)];
    [wxhyBtn setBackgroundImage:wxhyImage forState:UIControlStateNormal];
    [wxhyBtn addTarget:self action:@selector(shareToWxhy) forControlEvents:UIControlEventTouchUpInside];
    [shareBtnView addSubview:wxhyBtn];
    
    UILabel *wxhyLabel = [[UILabel alloc] initWithFrame:CGRectMake(wxhyBtn.x-imagePadding, CGRectGetMaxY(wxhyBtn.frame), wxhyBtn.width+imagePadding*2, textHeight)];
    wxhyLabel.text = @"微信";
    wxhyLabel.textAlignment = NSTextAlignmentCenter;
    wxhyLabel.font = FONT_14;
    wxhyLabel.textColor = COLOR_MAIN_TEXT;
    [shareBtnView addSubview:wxhyLabel];
    if (![app canOpenURL:[NSURL URLWithString:@"weixin://"]]) {
        wxhyBtn.frame = CGRectMake(0, 0, 0, 0);
        wxhyLabel.frame = CGRectMake(0, 0, 0, 0);
    }
    
    
    UIButton *sinaBtn = [[UIButton alloc] initWithFrame:CGRectMake(wxhyBtn.maxX+imagePadding, btnY, pyqImage.width, pyqImage.height)];
    [sinaBtn setBackgroundImage:sinaImage forState:UIControlStateNormal];
    [sinaBtn addTarget:self action:@selector(shareToSina) forControlEvents:UIControlEventTouchUpInside];
    [shareBtnView addSubview:sinaBtn];
    
    UILabel *sinaLabel = [[UILabel alloc] initWithFrame:CGRectMake(sinaBtn.x-imagePadding, CGRectGetMaxY(sinaBtn.frame), sinaBtn.width+imagePadding*2, textHeight)];
    sinaLabel.text = @"新浪微博";
    sinaLabel.textAlignment = NSTextAlignmentCenter;
    sinaLabel.font = FONT_14;
    sinaLabel.textColor = COLOR_MAIN_TEXT;
    [shareBtnView addSubview:sinaLabel];

    
    
    UIButton *qqBtn = [[UIButton alloc] initWithFrame:CGRectMake(sinaBtn.maxX+imagePadding, btnY, pyqImage.width, pyqImage.height)];
    [qqBtn setBackgroundImage:qqImage forState:UIControlStateNormal];
    [qqBtn addTarget:self action:@selector(shareToQQZone) forControlEvents:UIControlEventTouchUpInside];
    [shareBtnView addSubview:qqBtn];
    
    UILabel *qqLabel = [[UILabel alloc] initWithFrame:CGRectMake(qqBtn.x-imagePadding, CGRectGetMaxY(qqBtn.frame), qqBtn.width+imagePadding*2, textHeight)];
    qqLabel.text = @"QQ空间";
    qqLabel.textAlignment = NSTextAlignmentCenter;
    qqLabel.font = FONT_14;
    qqLabel.textColor = COLOR_MAIN_TEXT;
    [shareBtnView addSubview:qqLabel];
    if (![app canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
        qqBtn.frame = CGRectMake(0, 0, 0, 0);
        qqLabel.frame = CGRectMake(0, 0, 0, 0);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - share
// 发送微信分享信息
- (void)shareType:(NSString *)type
            title:(NSString *)title
          content:(NSString *)content
            image:(NSString *)imageUrl
              url:(NSString *)url
{
    if ([type isEqualToString:UMShareToWechatTimeline]) {
        [UMSocialData defaultData].extConfig.wechatTimelineData.title = content;
        [UMSocialData defaultData].extConfig.wechatTimelineData.wxMessageType = UMSocialWXMessageTypeWeb;
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = url;
    }
    else if ([type isEqualToString:UMShareToWechatSession]) {
        [UMSocialData defaultData].extConfig.wechatSessionData.title = title;
        [UMSocialData defaultData].extConfig.wechatSessionData.wxMessageType = UMSocialWXMessageTypeWeb;
        [UMSocialData defaultData].extConfig.wechatSessionData.url = url;
    }
    else if ([type isEqualToString:UMShareToSina]){
        [UMSocialData defaultData].extConfig.sinaData.shareText = content;
        [UMSocialData defaultData].extConfig.sinaData.snsName = title;
        [UMSocialData defaultData].extConfig.sinaData.urlResource.url = url;
        
    }else if ([type isEqualToString:UMShareToQzone]){
        [UMSocialData defaultData].extConfig.qzoneData.shareText = content;
        [UMSocialData defaultData].extConfig.qzoneData.title = title;
        [UMSocialData defaultData].extConfig.qzoneData.url = url;
    }
    
    UMSocialUrlResource *imageResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:imageUrl];
    
    [[UMSocialDataService defaultDataService] postSNSWithTypes:@[type]
                                                        content:content
                                                          image:nil
                                                       location:nil
                                                    urlResource:imageResource
                                            presentedController:nil
                                                     completion:^(UMSocialResponseEntity *response) {
                                                         if (response.responseCode == UMSResponseCodeSuccess) {
                                                             //[GCouponHelper sharePatAwardReply:self.patAwardId request:self.requestArray block:nil];
                                                             if (response.responseCode==200) {
                                                                 [GHUDAlertUtils toggleMessage:@"分享成功"];
                                                             }
                                                         }
                                                     }];
}

-(void)initShareSec{
    
    if (![UMSocialAccountManager isOauthAndTokenNotExpired:UMShareToSina]) {
        //进入授权页面
        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                //获取微博用户名、uid、token等
                UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
                [UMSocialAccountManager setSnsAccount:snsAccount];
                [GHUDAlertUtils toggleMessage:@"授权成功"];
                NSLog(@"username is %@, uid is %@, token is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken);
                //进入你的分享内容编辑页面
            }
        });
    };
   
    
    
    
//    UMSocialAccountEntity *weiboAccount = [[UMSocialAccountEntity alloc] initWithPlatformName:UMShareToSina];
//    weiboAccount.usid = @"1770404432";
//    weiboAccount.accessToken = @"2.00ME8ovB0ZBht54e079864457L72ZD";
//    //    weiboAccount.openId = @"tencent weibo openId";          //腾讯微博账户必需设置openId
//    //同步用户信息
//    [UMSocialAccountManager postSnsAccount:weiboAccount completion:^(UMSocialResponseEntity *response){
//        if (response.responseCode == UMSResponseCodeSuccess) {
//            //在本地缓存设置得到的账户信息
//            [UMSocialAccountManager setSnsAccount:weiboAccount];
//            //进入你自定义的分享内容编辑页面或者使用我们的内容编辑页面
//        }}];
    
    
}

-(void)shareToQQZone{
        [self shareType:UMShareToQzone
                  title:self.shareTitle
                content:self.shareDesc
                  image:self.shareImageUrl
                    url:self.shareUrl
         ];
        [self sharePageDone];
//    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:@"分享文字" image:nil location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
//        if (response.responseCode == UMSResponseCodeSuccess) {
//            NSLog(@"分享成功！");
//        }
//    }];
}

- (void)shareToSina{
    [self initShareSec];
//    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:self.shareDesc image:nil location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
//        if (response.responseCode == UMSResponseCodeSuccess) {
//            NSLog(@"分享成功！");
//        }
//    }];
    
    
    [self shareType:UMShareToSina
              title:self.shareTitle
            content:self.shareDesc
              image:self.shareImageUrl  
                url:self.shareUrl
     ];
    [self sharePageDone];
}

// 分享到微信朋友圈
- (void)shareToPyq
{
    [self shareType:UMShareToWechatTimeline
              title:self.shareTitle
            content:self.shareDesc
              image:self.shareImageUrl
                url:self.shareUrl
    ];
    [self sharePageDone];
}

// 分享给微信好友
- (void)shareToWxhy
{
    [self shareType:UMShareToWechatSession
              title:self.shareTitle
            content:self.shareDesc
              image:self.shareImageUrl
                url:self.shareUrl
     ];
    [self sharePageDone];
}

// 取消分享
- (void)sharePageDone
{
    [UIView animateWithDuration:0.2 animations:^{
        [shareBtnView setY:self.view.height];
        bgView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
    }];
}

@end