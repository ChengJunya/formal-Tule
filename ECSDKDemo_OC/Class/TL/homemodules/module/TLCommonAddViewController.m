//
//  TLCommonAddViewController.m
//  TL
//
//  Created by Rainbow on 2/16/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "TLCommonAddViewController.h"
#import "RIconTextBtn.h"
#import "PhotoCollectionView.h"
#import "ZXTextView.h"
#import "CCitySelectView.h"
#import "TLProvinceDTO.h"
#import "TLCityDTO.h"
#import "AddressDataHelper.h"
@interface TLCommonAddViewController ()<PhotosViewDelegate>{
    UITextField *titleField;
    RIconTextBtn *topBtn;
    UITextField *cityField;
    NSString *cityId;
    ZXTextView *contentLabel;

    
    
    UIView *citySelectView;
    CCitySelectView *select;
    BOOL isCitySelected;
}
@property (nonatomic,strong) PhotoCollectionView *photosView;
@property (nonatomic,strong) UIScrollView *addImageBtnView;

@end

@implementation TLCommonAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.detailDto = self.itemData;
    [self addAllUIResources];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navBarHidden = NO;
    self.navBackItemHidden = NO;
    
    self.navView.actionBtns = @[[self addPublishActionBtn]];
    
    if (self.operateType.integerValue==2) {
        [self updateUI];
    }
}

- (UIButton*)addPublishActionBtn
{
    
    //    UIImage *backImage = [UIImage imageNamed:@"ico_backon"];
    UIButton *actionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    actionBtn.frame = CGRectMake(0.f, 0.f, 44.f, 44.f);
    [actionBtn setTitleColor:COLOR_NAV_TEXT forState:UIControlStateNormal];
    [actionBtn setTitleColor:COLOR_BTN_BOX_GRAY_TEXT forState:UIControlStateHighlighted];
    [actionBtn setTitle:@"发表" forState:UIControlStateNormal];
    actionBtn.titleLabel.font = FONT_14B;
    //[actionBtn setImage:[UIImage imageNamed:@"more_xiaoxi"] forState:UIControlStateNormal];
    //    [actionBtn setImage:[UIImage imageNamed:@"ico_backon" ] forState:UIControlStateHighlighted];
    [actionBtn addTarget:self action:@selector(publishBtnHandler) forControlEvents:UIControlEventTouchUpInside];
    return actionBtn;
}

-(void)publishBtnHandler{
    
}

-(NSDictionary *)getFormData{
    
    /*
     UITextField *titleField;
     RIconTextBtn *topBtn;
     UITextField *cityField;
     NSString *cityId;
     ZXTextView *contentLabel;
     NSArray *images;//UIImage;
     */
    
    
    if (titleField.text.length==0||contentLabel.text.length==0||cityId.length==0) {
        [GHUDAlertUtils toggleMessage:@"请输入发表的相关信息"];
        return nil;
    }
    
    NSString *isTop;
    if (topBtn.selected) {
        isTop = @"1";
    }else{
        isTop = @"0";
    }
    
    NSDictionary *formData = @{@"title":titleField.text,
                               @"isTop":isTop,
                               @"cityId":cityId,
                               @"content":contentLabel.text,
                               @"images":[_photosView getPhotoArray]};
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
    topBtn.selected = NO;
    cityField.text = @"";
    cityId = @"";
    contentLabel.text = @"";
    UIImage *firstImage;
     _photosView = [[PhotoCollectionView alloc] initWithFrame:CGRectMake(UI_LAYOUT_MARGIN, 0.f, DEVICE_WIDTH-UI_LAYOUT_MARGIN*2, 100) andImage:firstImage];
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)updateUI{
    
    titleField.text = self.detailDto.title;
    topBtn.selected = self.detailDto.isTop.integerValue==1?YES:NO;
    cityField.text = self.detailDto.cityName;
    cityId = self.detailDto.cityId;
    contentLabel.text = self.detailDto.content;
    _addImageBtnView.hidden = YES;
}

-(void)addAllUIResources{
    CGFloat hGap = 5.f;
    CGFloat vGap = 5.f;
    CGFloat topWidth = 80.f;
    CGFloat textHeight = 40.f;
    CGFloat addImageBtnHeight = 130.f;
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0.f, vGap+NAVIGATIONBAR_HEIGHT+STATUSBAR_HEIGHT, CGRectGetWidth(self.view.frame)-hGap-topWidth, textHeight)];
    [titleView setBackgroundColor:UIColorFromRGBA(0xFFFFFF, 1.0f)];
    [self.view addSubview:titleView];
    
    titleField = [[UITextField alloc] initWithFrame:CGRectMake(hGap, 0.f, CGRectGetWidth(titleView.frame)-hGap*2, CGRectHeight(titleView.frame))];
    [titleView addSubview:titleField];
    titleField.placeholder = @"写标题";
    
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleView.frame)+hGap, vGap+NAVIGATIONBAR_HEIGHT+STATUSBAR_HEIGHT, topWidth, textHeight)];
    [topView setBackgroundColor:UIColorFromRGBA(0xFFFFFF, 1.0f)];
    [self.view addSubview:topView];
    
    topBtn = [[RIconTextBtn alloc] initWithFrame:CGRectMake(hGap, 0.f, CGRectGetWidth(topView.frame)-hGap*2, CGRectHeight(topView.frame))];
    [topBtn setImage:[UIImage imageNamed:@"tl_choice2"] forState:UIControlStateNormal];
    [topBtn setImage:[UIImage imageNamed:@"tl_choice1"] forState:UIControlStateSelected];
    [topBtn setTitle:@"置顶" forState:UIControlStateNormal];
    [topBtn setTitleColor:COLOR_MAIN_TEXT forState:UIControlStateNormal];
    [topBtn addTarget:self action:@selector(topBtnHandler:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:topBtn];
    
    CGFloat selectCityBtnWidth = 80.f;
    UIView *cityView = [[UIView alloc] initWithFrame:CGRectMake(0.f, vGap*2+NAVIGATIONBAR_HEIGHT+STATUSBAR_HEIGHT+textHeight, CGRectGetWidth(self.view.frame), textHeight)];
    [cityView setBackgroundColor:UIColorFromRGBA(0xFFFFFF, 1.0f)];
    [self.view addSubview:cityView];
    
    cityField = [[UITextField alloc] initWithFrame:CGRectMake(hGap, 0.f, CGRectGetWidth(cityView.frame)-hGap*3-selectCityBtnWidth, CGRectHeight(cityView.frame))];
    [cityView addSubview:cityField];
    [cityField setEnabled:NO];
    cityField.placeholder = @"请选择城市";
    
    UIButton *selectCityBtn = [[UIButton alloc] initWithFrame:CGRectMake(cityField.maxX+hGap, vGap, selectCityBtnWidth, cityView.height-vGap*2)];
    [selectCityBtn setBackgroundImage:[UIImage imageNamed:@"select_city"] forState:UIControlStateNormal];
    [cityView addSubview:selectCityBtn];
    [selectCityBtn addTarget:self action:@selector(cityBtnHandler:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0.f, vGap*3+NAVIGATIONBAR_HEIGHT+STATUSBAR_HEIGHT+textHeight*2, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-NAVIGATIONBAR_HEIGHT-STATUSBAR_HEIGHT-vGap*5-textHeight*2-addImageBtnHeight)];
    [contentView setBackgroundColor:UIColorFromRGBA(0xFFFFFF, 1.0f)];
    [self.view addSubview:contentView];
    
//    UITextView *contentTextView = [[UITextView alloc] initWithFrame:contentView.bounds];
//    [contentView addSubview:contentTextView];
    
    contentLabel = [[ZXTextView alloc] initWithFrame:contentView.bounds];
    contentLabel.font = FONT_16;
    contentLabel.textColor = COLOR_MAIN_TEXT;
//    contentLabel.largeTextLength = 200;
    contentLabel.placeholder = @"写正文";
    contentLabel.keyboardType = UIKeyboardTypeDefault;
    //    detailAddressLabel.delegate = self;//不能再设代理了,代理走的是helper
    contentLabel.autoHideKeyboard = YES;
    contentLabel.scrollEnabled = YES;
    [contentView addSubview:contentLabel];
    contentLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    
    
    
    _addImageBtnView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.f, CGRectGetHeight(self.view.frame)-vGap-addImageBtnHeight, CGRectGetWidth(self.view.frame), addImageBtnHeight)];
    [_addImageBtnView setBackgroundColor:UIColorFromRGBA(0xFFFFFF, 1.0f)];
    [self.view addSubview:_addImageBtnView];
    
    //    UIButton *addImageBtn = [[UIButton alloc] initWithFrame:CGRectMake(hGap, vGap, addImageBtnHeight-vGap*2, addImageBtnHeight-vGap*2)];
    //    [addImageBtn setTitle:@"+" forState:UIControlStateNormal];
    //    [addImageBtn setTitleColor:COLOR_TAB_TEXT_P forState:UIControlStateNormal];
    //    addImageBtn.titleLabel.font = FONT_30B;
    //    addImageBtn.backgroundColor = UIColorFromRGBA(0xEEEEEE, 0.5f);
    //    [addImageBtnView addSubview:addImageBtn];
    
    
    UIImage *firstImage;
    //添加照片
    _photosView = [[PhotoCollectionView alloc] initWithFrame:CGRectMake(UI_LAYOUT_MARGIN, 0.f, DEVICE_WIDTH-UI_LAYOUT_MARGIN*2, 100) andImage:firstImage];
    _photosView.maxPhotoNum = 8;
    _photosView.parentController = self;
    _photosView.delegate = self;
    _photosView.backgroundColor = [UIColor clearColor];
    [_addImageBtnView addSubview:_photosView];
    _addImageBtnView.contentSize = CGSizeMake(_addImageBtnView.contentSize.width, CGRectGetHeight(_photosView.frame));
    
    //第一次添加照片时，显示拍照实例页面
    //    if ([self isFirstShowKey:FirstChooseImage]) {
    //        self.imgTipBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, _photosView.width*0.33, _photosView.height)];
    //        _imgTipBtn.backgroundColor = [UIColor clearColor];
    //        [_imgTipBtn addTarget:self action:@selector(firstShowImageInstance:) forControlEvents:UIControlEventTouchUpInside];
    //        [_photosView addSubview:_imgTipBtn];
    //    }
    //
    //    [_imageContainer setHeight:CGRectGetMaxY(_photosView.frame)];
    
    
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


/////////city
-(void)cityBtnHandler:(id *)btn{
    [self.view endEditing:YES];
    if(citySelectView==nil){
        
        citySelectView = [[UIView alloc] initWithFrame:self.view.bounds];
        citySelectView.backgroundColor = UIColorFromRGBA(0x000000, 0.5f);
        [self.view addSubview:citySelectView];
        
        CGFloat _yOffSet = 100.f;
        CGFloat hGap = 20.f;
        CGFloat frameWidth = CGRectWidth(citySelectView.frame)-hGap*2;
        
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(hGap, _yOffSet, frameWidth, 40.f)];
        titleView.layer.borderWidth = 0.5f;
        titleView.layer.borderColor = [UIColor colorWithWhite:0.1 alpha:0.2].CGColor;
        titleView.backgroundColor = COLOR_DEF_BG;
        [citySelectView addSubview:titleView];
        
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.f, 0.f, frameWidth, 40.f)];
        titleLabel.text = @"现居地";
        titleLabel.textColor = COLOR_MAIN_TEXT;
        titleLabel.font = FONT_16B;
        titleLabel.textAlignment = NSTextAlignmentLeft;
        [titleView addSubview:titleLabel];
        
        _yOffSet = _yOffSet + CGRectHeight(titleLabel.frame);
        
        select = [[CCitySelectView alloc] initWithFrame:CGRectMake(hGap, _yOffSet, CGRectWidth(citySelectView.frame)-40.f, 160.f)];
        select.layer.borderWidth = 0.5f;
        select.layer.borderColor = [UIColor colorWithWhite:0.1 alpha:0.2].CGColor;
        select.backgroundColor = COLOR_DEF_BG;
        select.firstCoponentNameKey = @"provinceName";
        select.subCoponentNameKey = @"cityName";
        //select.thirdCoponentNameKey = @"districtName";
        
        WEAK_SELF(self);
        [citySelectView addSubview:select];
        select.PickerSelectBlock = ^(id selectedItem,CCitySelectView* selectView){
            TLProvinceDTO *province = selectedItem;
            [GAddressHelper getCityList:province.provinceId requestArr:weakSelf.requestArray block:^(id obj, BOOL ret) {
                //验证成功
                if (ret) {
                    NSArray *cityList = obj;
                    [selectView setSubPickerArray:cityList];
                }
                
                
            }];
            
        };
        
        //    select.PickerSubSelectBlock =^(id selectedItem,CCitySelectView* selectView){
        //        TLCityDTO *city = selectedItem;
        //        [GHUDAlertUtils toggleLoadingInView:weakSealf.view];
        //        [GAddressHelper getDistrictList:city.cityId requestArr:weakSealf.requestArray block:^(id obj, BOOL ret) {
        //            [GHUDAlertUtils hideLoadingInView:weakSealf.view];
        //            //验证成功
        //            if (ret) {
        //                NSArray *districtList = obj;
        //                [selectView setThirdPickerArray:districtList];
        //            }
        //
        //
        //        }];
        //
        //    };
        
        
        [GAddressHelper getProvinceList:self.requestArray block:^(id obj, BOOL ret) {
            //验证成功
            if (ret) {
                NSArray *proviceList = obj;
                [select setPickerArray:proviceList];
            }
            
            
        }];
        
        
        _yOffSet = _yOffSet + CGRectHeight(select);
        
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(hGap, _yOffSet, CGRectGetWidth(citySelectView.frame)/2-hGap, 40.f)];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:COLOR_MAIN_TEXT forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        cancelBtn.titleLabel.font = FONT_16B;
        
        [cancelBtn addTarget:self action:@selector(cancelBtnHandler:) forControlEvents:UIControlEventTouchUpInside];
        
        cancelBtn.layer.borderWidth = 0.5f;
        cancelBtn.layer.borderColor = [UIColor colorWithWhite:0.1 alpha:0.2].CGColor;
        cancelBtn.backgroundColor = COLOR_DEF_BG;
        [citySelectView addSubview:cancelBtn];
        
        UIButton *okBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(citySelectView.frame)/2, _yOffSet, CGRectGetWidth(citySelectView.frame)/2-hGap, 40.f)];
        [okBtn setTitle:@"确定" forState:UIControlStateNormal];
        okBtn.titleLabel.font = FONT_16B;
        
        [okBtn addTarget:self action:@selector(okBtnHandler:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [okBtn setTitleColor:COLOR_ORANGE_TEXT forState:UIControlStateNormal];
        [okBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        okBtn.layer.borderWidth = 0.5f;
        okBtn.layer.borderColor = [UIColor colorWithWhite:0.1 alpha:0.2].CGColor;
        okBtn.backgroundColor = COLOR_DEF_BG;
        [citySelectView addSubview:okBtn];
        
        
    }else{
        [self.view addSubview:citySelectView];
    }
    
}

-(void)cancelBtnHandler:(id)btn{
    [citySelectView removeFromSuperview];
    
}

-(void)okBtnHandler:(id)btn{
    [citySelectView removeFromSuperview];
    
    TLProvinceDTO *province = select.firstCoponentSelectedItem;
    TLCityDTO *city = select.subCoponentSelectedItem;
    
    cityField.text = [NSString stringWithFormat:@"%@    %@",province.provinceName,city.cityName];
    cityId = city.cityId;
    isCitySelected = YES;
}


-(void)setUIByDto:(TLTripDataDTO*)tripDto{
    titleField.text = tripDto.title;
    
}

@end
