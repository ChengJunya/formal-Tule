//
//  TLNewsDetailViewController.m
//  TL
//
//  Created by Rainbow on 5/11/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "TLNewsDetailViewController.h"
#import "TLShareDTO.h"
#import "TLSaveCollectRequestDTO.h"
#import "TLNewsDataDTO.h"
@interface TLNewsDetailViewController ()
@property (nonatomic,strong) TLNewsDataDTO *detailDto;
@end

@implementation TLNewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.detailDto = self.itemData;
    self.navigationButtonsHidden = YES;
    self.navigationController.navigationBarHidden = YES;
    self.title = @"资讯详情";
    
    
    UISwipeGestureRecognizer *recognizer;
    
    
    
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    
    [[self view] addGestureRecognizer:recognizer];
    
    
    
    [self initPage];
}

-(void)handleSwipeFrom:(UISwipeGestureRecognizer*)recognizer{
    [self addComment];
}

-(void)viewWillAppear:(BOOL)animated{
    //[super viewWillAppear:animated];
    self.navBarHidden = NO;
    self.navBackItemHidden = NO;
    [self createActionButtons];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


-(void)initPage{
    self.url = [NSURL URLWithString: [NSString stringWithFormat:@"%@/%@",TL_SERVER_BASE_URL, self.newsUrl]];
    
    // 显示控制栏菜单
    [self.navigationController setToolbarHidden:1 animated:NO];
    
    
    // 是否能拖动页面
    self.webView.scrollView.bounces = NO;
    [self disableBounce];
    [self.webView setFrame:CGRectMake(0.f, NAVIGATIONBAR_HEIGHT+STATUSBAR_HEIGHT, self.webView.width, self.webView.height-NAVIGATIONBAR_HEIGHT-STATUSBAR_HEIGHT)];
    // 重新加载，必须刷新
    [self.webView reload];
}

- (void)disableBounce {
    //    [[[self subviews] lastObject] setScrollingEnabled:NO];
    for (id subview in self.view.subviews){
        if ([[subview class] isSubclassOfClass: [UIScrollView class]]){
            ((UIScrollView *)subview).bounces = NO;
            ((UIScrollView *)subview).scrollEnabled = NO;
        }
    }
}


#pragma mark-
#pragma mark- 操作按钮

- (void)createActionButtons{
    NSArray *actionButtons = @[[self createComunicateBtn],[self createShareButton]];
    self.navView.actionBtns = actionButtons;
}

- (UIButton*)createShareButton
{
    
    //    UIImage *backImage = [UIImage imageNamed:@"ico_backon"];
    UIButton *actionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    actionBtn.frame = CGRectMake(0.f, 0.f, 44.f, 44.f);
    [actionBtn setImage:[UIImage imageNamed:@"nav_share"] forState:UIControlStateNormal];
    //    [actionBtn setImage:[UIImage imageNamed:@"ico_backon" ] forState:UIControlStateHighlighted];
    [actionBtn addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    return actionBtn;
}

- (UIButton*)createCollectButton
{
    
    //    UIImage *backImage = [UIImage imageNamed:@"ico_backon"];
    UIButton *actionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    actionBtn.frame = CGRectMake(0.f, 0.f, 44.f, 44.f);
    [actionBtn setImage:[UIImage imageNamed:@"nav_collect"] forState:UIControlStateNormal];
    //    [actionBtn setImage:[UIImage imageNamed:@"ico_backon" ] forState:UIControlStateHighlighted];
    [actionBtn addTarget:self action:@selector(collectAction) forControlEvents:UIControlEventTouchUpInside];
    return actionBtn;
}

- (UIButton*)createDownloadButton
{
    
    //    UIImage *backImage = [UIImage imageNamed:@"ico_backon"];
    UIButton *actionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    actionBtn.frame = CGRectMake(0.f, 0.f, 44.f, 44.f);
    [actionBtn setImage:[UIImage imageNamed:@"nav_download"] forState:UIControlStateNormal];
    //    [actionBtn setImage:[UIImage imageNamed:@"ico_backon" ] forState:UIControlStateHighlighted];
    [actionBtn addTarget:self action:@selector(downloadAction) forControlEvents:UIControlEventTouchUpInside];
    return actionBtn;
}

- (UIButton*)createComunicateBtn
{
    
    //    UIImage *backImage = [UIImage imageNamed:@"ico_backon"];
    UIButton *actionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    actionBtn.frame = CGRectMake(0.f, 0.f, 44.f, 44.f);
    [actionBtn setImage:[UIImage imageNamed:@"nav_comment"] forState:UIControlStateNormal];
    //    [actionBtn setImage:[UIImage imageNamed:@"ico_backon" ] forState:UIControlStateHighlighted];
    [actionBtn addTarget:self action:@selector(communicateAction) forControlEvents:UIControlEventTouchUpInside];
    return actionBtn;
}



#pragma mark-
#pragma mark-actions
/**
 *  下载
 */
-(void)downloadAction{
    
}
/**
 *  收藏
 */
-(void)collectAction{

}
/**
 *  评论
 */
-(void)communicateAction{
    [self addComment];
}


/**
 *  分享
 */
-(void)shareAction{
    
    
    NSString *imageUrl = [NSString stringWithFormat:@"%@%@",TL_SERVER_BASE_URL,self.detailDto.newsPic];
    
    TLShareDTO *shareDto = [[TLShareDTO alloc] init];
    shareDto.shareUrl = UMSOCIAL_WXAPP_URL;//obj.shareUrl;
    shareDto.shareDesc = self.detailDto.newsDesc.length>50?[self.detailDto.newsDesc substringToIndex:49]:self.detailDto.newsDesc;//self.detailDto.newsDesc;//obj.shareDesc;
    shareDto.shareTitle = self.detailDto.newsTitle;//obj.title;
    shareDto.shareImageUrl = imageUrl;//obj.imageUrl;
    shareDto.patAwardId = @"";//obj.patAwardId;
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SHARE object:shareDto];
}





-(void)addComment{
    
    NSDictionary *itemData = @{@"travelId":self.detailDto.newsId,@"type":MODULE_NEWS_TYPE};
    
    [self pushViewControllerWithName:@"TLCommentViewController" itemData:itemData block:^(id obj) {
        
    }];
}



@end
