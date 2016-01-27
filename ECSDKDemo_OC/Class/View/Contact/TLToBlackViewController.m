//
//  TLToBlackViewController.m
//  TL
//
//  Created by YONGFU on 6/8/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "TLToBlackViewController.h"
#import "PhotoCollectionView.h"
#import "TLModuleDataHelper.h"
#import "TLAuthorityRequestDTO.h"
@interface TLToBlackViewController ()<PhotosViewDelegate>
@property (nonatomic,strong) PhotoCollectionView *photosView;
@property (nonatomic,strong) UIScrollView *addImageBtnView;
@end

@implementation TLToBlackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"拉黑举报";
    [self addAllUIResources];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navBarHidden = NO;
    self.navBackItemHidden = NO;
    self.navView.actionBtns = @[[self addPublishActionBtn]];
}

- (UIButton*)addPublishActionBtn
{
    
    //    UIImage *backImage = [UIImage imageNamed:@"ico_backon"];
    UIButton *actionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    actionBtn.frame = CGRectMake(0.f, 0.f, 44.f, 44.f);
    [actionBtn setTitleColor:COLOR_NAV_TEXT forState:UIControlStateNormal];
    [actionBtn setTitleColor:COLOR_BTN_BOX_GRAY_TEXT forState:UIControlStateHighlighted];
    [actionBtn setTitle:@"提交" forState:UIControlStateNormal];
    actionBtn.titleLabel.font = FONT_14B;
    //[actionBtn setImage:[UIImage imageNamed:@"more_xiaoxi"] forState:UIControlStateNormal];
    //    [actionBtn setImage:[UIImage imageNamed:@"ico_backon" ] forState:UIControlStateHighlighted];
    [actionBtn addTarget:self action:@selector(publishBtnHandler) forControlEvents:UIControlEventTouchUpInside];
    return actionBtn;
}


-(void)publishBtnHandler{
    
    NSMutableArray *imageArray = [_photosView getPhotoArray];
    
    if (imageArray.count==0) {
        [GHUDAlertUtils toggleMessage:@"请上传图片"];
        return;
    }
    
    
    WEAK_SELF(self);
    TLReportBlackRequestDTO *request = [[TLReportBlackRequestDTO alloc] init];
    request.blackUser = self.userInfoDto.loginId;
    request.reportFiles = imageArray;
    [GHUDAlertUtils toggleLoadingInView:self.view];
    [GTLModuleDataHelper reportBlack:request requestArr:self.requestArray block:^(id obj, BOOL ret) {
        [GHUDAlertUtils hideLoadingInView:self.view];
        if (ret) {
            [GHUDAlertUtils toggleMessage:@"拉黑成功"];
            [weakSelf gobackAction];
        }else{
            ResponseDTO *resDTO = obj;
            [GHUDAlertUtils toggleMessage:resDTO.resultDesc];
        }
    }];
    
}

-(void)gobackAction{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)addAllUIResources{
    CGFloat yOffSet = NAVIGATIONBAR_HEIGHT + STATUSBAR_HEIGHT;
    UITextView *infoView = [[UITextView alloc] initWithFrame:CGRectMake(0.f, yOffSet, self.view.width, 60.f)];
    infoView.backgroundColor = COLOR_WHITE_BG;
    infoView.editable = NO;
    infoView.font = FONT_14;
    infoView.textColor = COLOR_MAIN_TEXT;
    infoView.text = @"提交后将收不到对方的信息，并由后台审核，如核实该用户发布非法信息，将会被封号！";
    [self.view addSubview:infoView];
    
    
    yOffSet = yOffSet + 60.f;
    
    
    _addImageBtnView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.f, yOffSet, CGRectGetWidth(self.view.frame), self.view.height-yOffSet)];
    [_addImageBtnView setBackgroundColor:UIColorFromRGBA(0xFFFFFF, 1.0f)];
    [self.view addSubview:_addImageBtnView];
    
    
    
    UIImage *firstImage;
    //添加照片
    _photosView = [[PhotoCollectionView alloc] initWithFrame:CGRectMake(UI_LAYOUT_MARGIN, 0.f, DEVICE_WIDTH-UI_LAYOUT_MARGIN*2, 100) andImage:firstImage];
    _photosView.parentController = self;
    _photosView.delegate = self;
    _photosView.backgroundColor = [UIColor clearColor];
    [_addImageBtnView addSubview:_photosView];
    _addImageBtnView.contentSize = CGSizeMake(_addImageBtnView.contentSize.width, CGRectGetHeight(_photosView.frame));
    
    
    
    
}

//PhotosViewDelegate
-(void)photosViewFrameDidChanged:(CGFloat)height
{
    CGRect photoFrame = _photosView.frame;
    photoFrame.size.height = height;
    _photosView.frame = photoFrame;
    
    _addImageBtnView.contentSize = CGSizeMake(_addImageBtnView.contentSize.width, CGRectGetHeight(_photosView.frame));
}

@end
