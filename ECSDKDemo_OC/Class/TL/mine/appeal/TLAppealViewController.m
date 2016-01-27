//
//  TLAppealViewController.m
//  TL
//
//  Created by Rainbow on 4/16/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "TLAppealViewController.h"
#import "RIconTextBtn.h"
#import "PhotoCollectionView.h"
#import "ZXTextView.h"
#import "CCitySelectView.h"
#import "TLProvinceDTO.h"
#import "TLCityDTO.h"
#import "AddressDataHelper.h"
#import "TLModuleDataHelper.h"
#import "TLAppealRequestDTO.h"
@interface TLAppealViewController ()<PhotosViewDelegate>{
    UITextField *titleField;
    UITextField *phoneField;
    UITextField *emailField;



    ZXTextView *contentLabel;
    
    
    
    UIView *citySelectView;
    CCitySelectView *select;
    BOOL isCitySelected;
}
@property (nonatomic,strong) PhotoCollectionView *photosView;
@property (nonatomic,strong) UIScrollView *addImageBtnView;

@end

@implementation TLAppealViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addAllUIResources];
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
    
    if (titleField.text.length==0||contentLabel.text.length==0||phoneField.text.length==0||emailField.text.length==0||imageArray.count==0) {
        [GHUDAlertUtils toggleMessage:@"请输入发表的相关信息"];
        return;
    }
    
    
    TLAppealRequestDTO *request = [[TLAppealRequestDTO alloc] init];
    request.title = titleField.text;
    request.phone = phoneField.text;
    request.email = emailField.text;
    request.content = contentLabel.text;
    request.images = imageArray;
    
    WEAK_SELF(self);
    [GHUDAlertUtils toggleLoadingInView:self.view];
    [GTLModuleDataHelper saveAppeal:request requestArr:self.requestArray block:^(id obj, BOOL ret) {
        
        
        [GHUDAlertUtils hideLoadingInView:self.view];
        ResponseDTO *response = obj;
        if (ret) {
            [GHUDAlertUtils toggleMessage:@"申诉成功"];
            [weakSelf resetUI];
        }else{
            [GHUDAlertUtils toggleMessage:response.resultDesc];
        }
    }];
    
}

-(NSDictionary *)getFormData{
    
   
    

    NSMutableArray *imageArray = [_photosView getPhotoArray];
    
    if (titleField.text.length==0||contentLabel.text.length==0||phoneField.text.length==0||emailField.text.length==0||imageArray.count==0) {
        [GHUDAlertUtils toggleMessage:@"请输入申诉相关信息"];
        return nil;
    }
    
    
    NSDictionary *formData = @{@"title":titleField.text,
                               @"phone":phoneField.text,
                               @"email":emailField.text,
                               @"content":contentLabel.text,
                               @"images":imageArray};
    return  formData;
}


//重置
-(void)resetUI{
    /*
     UITextField *titleField;
     RIconTextBtn *topBtn;
     UITextField *cityField;
     NSString *cityId;
     ZXTextView *contentLabel;
     NSArray *images;//UIImage;
     */
    
    titleField.text = @"";
    phoneField.text = @"";
    emailField.text = @"";
    contentLabel.text = @"";
    UIImage *firstImage;
    _photosView = [[PhotoCollectionView alloc] initWithFrame:CGRectMake(UI_LAYOUT_MARGIN, 0.f, DEVICE_WIDTH-UI_LAYOUT_MARGIN*2, 100) andImage:firstImage];
    
}

-(void)addAllUIResources{
    CGFloat hGap = 5.f;
    CGFloat vGap = 5.f;

    CGFloat textHeight = 40.f;
    CGFloat addImageBtnHeight = 130.f;
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0.f, vGap+NAVIGATIONBAR_HEIGHT+STATUSBAR_HEIGHT, CGRectGetWidth(self.view.frame), textHeight)];
    [titleView setBackgroundColor:UIColorFromRGBA(0xFFFFFF, 1.0f)];
    [self.view addSubview:titleView];
    
    titleField = [[UITextField alloc] initWithFrame:CGRectMake(hGap, 0.f, CGRectGetWidth(titleView.frame)-hGap*2, CGRectHeight(titleView.frame))];
    [titleView addSubview:titleField];
    titleField.placeholder = @"题目";
    
    UIView *phoneView = [[UIView alloc] initWithFrame:CGRectMake(0.f, vGap+titleView.maxY, CGRectGetWidth(self.view.frame), textHeight)];
    [phoneView setBackgroundColor:UIColorFromRGBA(0xFFFFFF, 1.0f)];
    [self.view addSubview:phoneView];
    
    phoneField = [[UITextField alloc] initWithFrame:CGRectMake(hGap, 0.f, CGRectGetWidth(phoneView.frame)-hGap*2, CGRectHeight(phoneView.frame))];
    phoneField.keyboardType = UIKeyboardTypeNumberPad;
    [phoneView addSubview:phoneField];
    phoneField.placeholder = @"申诉人电话";
    
    UIView *emailView = [[UIView alloc] initWithFrame:CGRectMake(0.f, vGap+phoneView.maxY, CGRectGetWidth(self.view.frame), textHeight)];
    [emailView setBackgroundColor:UIColorFromRGBA(0xFFFFFF, 1.0f)];
    [self.view addSubview:emailView];
    
    emailField = [[UITextField alloc] initWithFrame:CGRectMake(hGap, 0.f, CGRectGetWidth(emailView.frame)-hGap*2, CGRectHeight(emailView.frame))];
    emailField.keyboardType = UIKeyboardTypeEmailAddress;
    [emailView addSubview:emailField];
    emailField.placeholder = @"申诉人邮箱";
    
    
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0.f, vGap+emailView.maxY, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-emailView.maxY-addImageBtnHeight-vGap*2)];
    [contentView setBackgroundColor:UIColorFromRGBA(0xFFFFFF, 1.0f)];
    [self.view addSubview:contentView];
    
    //    UITextView *contentTextView = [[UITextView alloc] initWithFrame:contentView.bounds];
    //    [contentView addSubview:contentTextView];
    
    contentLabel = [[ZXTextView alloc] initWithFrame:contentView.bounds];
    contentLabel.font = FONT_16;
    contentLabel.textColor = COLOR_MAIN_TEXT;
//    contentLabel.largeTextLength = 200;
    contentLabel.placeholder = @"申诉内容";
    contentLabel.keyboardType = UIKeyboardTypeDefault;
    //    detailAddressLabel.delegate = self;//不能再设代理了,代理走的是helper
    contentLabel.autoHideKeyboard = YES;
    contentLabel.scrollEnabled = YES;
    [contentView addSubview:contentLabel];
    contentLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    
    
    
    _addImageBtnView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.f, CGRectGetHeight(self.view.frame)-vGap-addImageBtnHeight, CGRectGetWidth(self.view.frame), addImageBtnHeight)];
    [_addImageBtnView setBackgroundColor:UIColorFromRGBA(0xFFFFFF, 1.0f)];
    [self.view addSubview:_addImageBtnView];
    
   
    
    UIImage *firstImage;
    //添加照片
    _photosView = [[PhotoCollectionView alloc] initWithFrame:CGRectMake(UI_LAYOUT_MARGIN, 0.f, DEVICE_WIDTH-UI_LAYOUT_MARGIN*2, 100) andImage:firstImage];
    _photosView.maxPhotoNum = 8;
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

-(void)topBtnHandler:(UIButton*)btn{
    if (btn.selected) {
        btn.selected = NO;
    }else{
        btn.selected = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
