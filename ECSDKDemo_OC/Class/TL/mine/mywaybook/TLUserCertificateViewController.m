//
//  TLUserCertificateViewController.m
//  TL
//
//  Created by YONGFU on 5/22/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "TLUserCertificateViewController.h"
#import "PhotoCollectionView.h"
#import "TLModuleDataHelper.h"
#import "TLAuthorityRequestDTO.h"
@interface TLUserCertificateViewController ()<PhotosViewDelegate>
@property (nonatomic,strong) PhotoCollectionView *photosView;
@property (nonatomic,strong) UIScrollView *addImageBtnView;
@end

@implementation TLUserCertificateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"用户认证";
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
    
    
    TLAuthorityRequestDTO *request = [[TLAuthorityRequestDTO alloc] init];
    
    request.authImage = imageArray;
    
    WEAK_SELF(self);
    [GHUDAlertUtils toggleLoadingInView:self.view];
    [GTLModuleDataHelper authority:request requestArr:self.requestArray block:^(id obj, BOOL ret) {
        
        
        [GHUDAlertUtils hideLoadingInView:self.view];
        ResponseDTO *response = obj;
        if (ret) {
            [GHUDAlertUtils toggleMessage:response.resultDesc];
            [weakSelf gobackAction];
        }else{
            [GHUDAlertUtils toggleMessage:response.resultDesc];
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
    infoView.text = @"上传身份证正反面照片和公司证明照片，认证后获得大V标识";
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
