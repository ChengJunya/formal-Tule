//
//  TLHomeViewController.m
//  TL
//
//  Created by Rainbow on 2/4/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "TLHomeViewController.h"
#import "ImagePlayerView.h"
#import "UIImageView+WebCache.h"
#import "CMenuView.h"
#import "ZXUIHelper.h"
#import "TLHelper.h"
#import "SBJsonParser.h"
#import "TLHomeHelper.h"
#import "TLHomeImageDTO.h"
#import "TLActivityDTO.h"
#import "UserDataHelper.h"
#import "LoginRequestDTO.h"
#import "TLNewsDetailViewController.h"
#import "TLNewsDataDTO.h"
#import "CycleScrollView.h"

#define ImagePlayerView_Height 260.f
//#define MENU_HEIGHT 180.f
#define HW_VALUE 1.3
@interface TLHomeViewController ()<CMenuViewDelegate>{
    CGFloat _imageViewHeight;
    CGFloat _menuHeight;
    CycleScrollView *_cycleScrollView;
    UIImageView *_emptyImageView;
}
@property (nonatomic,strong) ImagePlayerView *imagePlayerView;
@property (nonatomic,strong) NSArray *imageURLs;
@property (nonatomic,strong) NSMutableArray *bannerImageViewArr;


@end

@implementation TLHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"途乐";
    _imageViewHeight = self.view.width/HW_VALUE;
    _menuHeight = self.view.height-STATUSBAR_HEIGHT-NAVIGATIONBAR_HEIGHT-TABBAR_HEIGHT-_imageViewHeight;
    [self addAllUIResources];
    [self getHomeImageData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navBarHidden = NO;
    self.searchBtnHidden = NO;
    self.listBtnHidden = NO;
    //
    [self resumeAutoScrollAnim];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self stopAutoScrollAnim];
}

#pragma mark - public tools
- (void)resumeAutoScrollAnim {
    [_cycleScrollView resumeAutoScrollAnim];
}

- (void)stopAutoScrollAnim {
    [_cycleScrollView stopAutoScrollAnim];
}

/**
 *  初始化banner视图数组
 *
 *  @param isLocalData 是否是本地图片
 */
- (void)initBannerImageViewArr {
    self.bannerImageViewArr = [NSMutableArray array];
    if (_emptyImageView != nil) {
        [_emptyImageView removeFromSuperview];
    }
    if (self.imageURLs.count == 0) {
        _emptyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.width ,_imageViewHeight)];
        _emptyImageView.userInteractionEnabled = YES;
        _emptyImageView.image = [UIImage imageNamed:@"ico_loading_logo_1x2"];
        _emptyImageView.contentMode =  UIViewContentModeScaleAspectFit;
        [self.bannerImageViewArr addObject:_emptyImageView];
    }else{
        [self.imageURLs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            TLHomeImageDTO *bannerInfo = obj;
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,  self.view.width, _imageViewHeight)];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.userInteractionEnabled = YES; 
            NSString *imageUrl = [NSString stringWithFormat:@"%@%@",TL_SERVER_BASE_URL,bannerInfo.imageUrl];
            [imageView setZXImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil];
            [self.bannerImageViewArr addObject:imageView];
        }];
    }
    [self addImageBanner];
}

/**
 *  通过index获取视图，如果是两个视图就特殊处理，每次都重新创建
 */
-(UIView*)getBannerViewByIndex:(NSInteger)index{
    if (self.imageURLs.count == 2) {
        TLHomeImageDTO *info = self.imageURLs[index];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f,  self.view.width, _imageViewHeight)];
        imageView.userInteractionEnabled = YES;
        NSString *imageUrl = [NSString stringWithFormat:@"%@%@",TL_SERVER_BASE_URL,info.imageUrl];
        [imageView setZXImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        return imageView;
    }else{
        return self.bannerImageViewArr[index];
    }
}


-(void)dealloc{
    _cycleScrollView = nil;
}

#pragma mark -
#pragma mark - 获取数据
-(void)getHomeImageData{
    //改变首页图片的分辨率
    NSString *imageHeight = [NSString stringWithFormat:@"%f",_imageViewHeight * 3];
    NSString *imageWidth = [NSString stringWithFormat:@"%f",self.view.width * 3];

    WEAK_SELF(self);
    [GTLHomeHelper getHomeImageList:imageHeight width:imageWidth requestArr:self.requestArray block:^(id obj, BOOL ret) {
        if (ret) {
            NSArray *list = obj;
            self.imageURLs = list;
            [weakSelf initBannerImageViewArr];
        }else{
            ResponseDTO *response = obj;
            [GHUDAlertUtils toggleMessage:response.resultDesc];
        }
    }];
}

#pragma mark -
#pragma mark - ui

- (void)addAllUIResources
{
    [self addMenuView];
}


/**
 *  添加图片导航
 */
-(void)addImageBanner{
    if (_cycleScrollView!=nil) {
        [_cycleScrollView removeFromSuperview];
    }
    _cycleScrollView = [[CycleScrollView alloc] initWithFrame:CGRectMake(0.f ,NAVIGATIONBAR_HEIGHT+STATUSBAR_HEIGHT,CGRectGetWidth(self.view.frame) , _imageViewHeight) animationDuration:4.f];
    [self.view addSubview:_cycleScrollView];
    
    WEAK_SELF(self);
    _cycleScrollView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
        return [weakSelf getBannerViewByIndex:pageIndex];
    };
    _cycleScrollView.totalPagesCount = ^NSInteger(void){
        return [weakSelf.bannerImageViewArr count];
    };
    _cycleScrollView.TapActionBlock = ^(NSInteger pageIndex){
        [weakSelf imageTapAction:pageIndex];
    };
}


/**
 *  添加首页菜单
 */
-(void)addMenuView{
    CMenuView *menuView = [[CMenuView alloc] initWithFrame:CGRectMake(0.0, NAVIGATIONBAR_HEIGHT+STATUSBAR_HEIGHT+_imageViewHeight, CGRectGetWidth(self.view.frame),_menuHeight)];
    menuView.delegate = self;
    menuView.alpha = 1;
    [self.view addSubview:menuView];
    NSString *loginId = @"";//GUserDataHelper.loginInfo.loginId;
    [menuView randerViewWithData:
               @[@{@"ID":@"1",@"NAME":@"攻略",@"IMG":@"menu1_homepage",@"VCNAME":@"TLStrategyListViewController",@"TYPE":@"1",@"DATATYPE":@"1",@"LOGINID":loginId},
               @{@"ID":@"2",@"NAME":@"路书",@"IMG":@"menu2_homepage",@"VCNAME":@"TLWayBookListViewController",@"TYPE":@"2",@"DATATYPE":@"1",@"LOGINID":loginId},
               @{@"ID":@"3",@"NAME":@"游记",@"IMG":@"menu3_homepage",@"VCNAME":@"TLTripNoteListViewController",@"TYPE":@"3",@"DATATYPE":@"1",@"LOGINID":loginId},
               @{@"ID":@"4",@"NAME":@"活动",@"IMG":@"menu4_homepage",@"VCNAME":@"TLGroupActivityListViewController",@"TYPE":@"4",@"DATATYPE":@"1",@"LOGINID":loginId},
               @{@"ID":@"5",@"NAME":@"车讯",@"IMG":@"menu5_homepage",@"VCNAME":@"TLCarMainListViewController",@"TYPE":@"5",@"DATATYPE":@"1",@"LOGINID":loginId},
               @{@"ID":@"6",@"NAME":@"跳蚤",@"IMG":@"menu6_homepage",@"VCNAME":@"TLSecondPlatformViewController",@"TYPE":@"6",@"DATATYPE":@"1",@"LOGINID":loginId},
               @{@"ID":@"8",@"NAME":@"商家",@"IMG":@"menu8_homepage",@"VCNAME":@"TLStoreListViewController",@"TYPE":@"8",@"DATATYPE":@"1",@"LOGINID":loginId},
               @{@"ID":@"7",@"NAME":@"应急救援",@"IMG":@"menu7_homepage",@"VCNAME":@"TLEmergencyViewController",@"TYPE":@"7",@"DATATYPE":@"1",@"LOGINID":loginId}]];

}

/**
 *  添加导航 --  废弃
 */
-(void)addBanner{
    
    self.imagePlayerView = [[ImagePlayerView alloc] initWithFrame:CGRectMake(0.f ,NAVIGATIONBAR_HEIGHT+STATUSBAR_HEIGHT,CGRectGetWidth(self.view.frame) , _imageViewHeight)];
    [self.view addSubview:self.imagePlayerView];
    
    
}

#pragma mark - ImagePlayerViewDelegate
/**
 *  imagepayer的代理 -- 废弃
 */
- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView loadImageForImageView:(UIImageView *)imageView index:(NSInteger)index
{
    TLHomeImageDTO *homeImageDto = [self.imageURLs objectAtIndex:index];
    NSString *imageUrl = [NSString stringWithFormat:@"%@%@",TL_SERVER_BASE_URL,homeImageDto.imageUrl];
    [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"ico_loading_logo"]];
}


#pragma mark-
#pragma mark-事件
/**
 *  搜索按钮事件
 */
-(void)searchAction{
    [RTLHelper pushViewControllerWithName:@"TLSearchViewController" block:^(id obj) {
        
    }];
}


/**
 *  系统收到消息的时候
 */
- (void)messageFromServer{
    [GHUDAlertUtils showZXColorAlert:@"系统信息" subTitle:@"您收到新的系统信息，请点击查看" cancleButton:@"知道了" sureButtonTitle:@"查看" COLORButtonType:0 buttonHeight:40 clickedBlock:^(ZXColorAlert *alert, NSUInteger index) {
        if (index == 1) {
            [RTLHelper pushViewControllerWithName:@"TLNoticifacationMessageViewController" block:^(id obj) {
                
            }];
        }
    }];
}

/**
 *  通过图片点击的索引跳转到对应的页面
 *
 *  @param index 图片索引 0开始
 */
-(void)imageTapAction:(NSInteger)index{
    if (self.imageURLs.count==0) {
        return;
    }
    TLHomeImageDTO *homeImageDto = [self.imageURLs objectAtIndex:index];
    
    NSString *type = homeImageDto.objType;
    if (type.integerValue==0) {
        NSString *url = [NSString stringWithFormat:@"action/viewNews?newsId=%@",homeImageDto.objId];
        
        TLNewsDataDTO *newsDto = [[TLNewsDataDTO alloc] init];
        newsDto.url = url;
        newsDto.newsId = homeImageDto.objId;
        newsDto.newsDesc = @"";
        newsDto.newsDate = @"";
        newsDto.newsTitle = @"";
        [RTLHelper pushViewControllerWithName:@"TLNewsDetailViewController" itemData:newsDto block:^(TLNewsDetailViewController* obj) {
            obj.newsUrl = url;
        }];
    }else{
        
        [RTLHelper pushViewControllerWithName:@"TLNewsViewController" itemData:homeImageDto block:^(id obj) {
            
        }];
    }
    
}

/**
 *  imageplayer点击事件 ---  废弃20150611
 */
- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView didTapAtIndex:(NSInteger)index
{
    [self imageTapAction:index];
}

#pragma mark-
#pragma mark-菜单代理
/**
 *  点击菜单事件
 *
 *  @param itemData 菜单数据
 */
-(void)itemClick:(NSDictionary *)itemData{
    NSLog(@"%@",[itemData valueForKey:@"VCNAME"]);
    //NSString *menuId = [itemData valueForKey:@"menuId"];
    [RTLHelper pushViewControllerWithName:[itemData valueForKey:@"VCNAME"] itemData:itemData block:^(id obj) {
        
    }];
    
}

@end
