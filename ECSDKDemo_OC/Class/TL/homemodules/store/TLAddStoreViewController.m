//
//  TLAddStoreViewController.m
//  TL
//
//  Created by YONGFU on 5/21/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "TLAddStoreViewController.h"
#import "RIconTextBtn.h"
#import "PhotoCollectionView.h"
#import "RTextIconBtn.h"
#import "CDateChooserView.h"
#import "RUtiles.h"
#import "CSelectView.h"
#import "TLCommonCodeRequestDTO.h"
#import "TLModuleDataHelper.h"
#import "TLPersonCountDTO.h"
#import "TLActivitySaveRequestDTO.h"
#import "CCitySelectView.h"
#import "ZXTextView.h"
#import "TLProvinceDTO.h"
#import "TLCityDTO.h"
#import "AddressDataHelper.h"
#import "TLSaveMarchantRequestDTO.h"

@interface TLAddStoreViewController ()<PhotosViewDelegate>{
    
    UITextField *titleField;
    UITextField *addressField;
    UITextField *phoneField;
    UITextField *costField;
    RIconTextBtn *topBtn;
    UITextField *cityField;
    NSString *cityId;
    ZXTextView *contentLabel;
    
    
    RTextIconBtn *selectDateBtn;
    RTextIconBtn *storeTypeBtn;
    
    RTextIconBtn *startTimeBtn;
    RTextIconBtn *endTimeBtn;
    BOOL isStartBtnSelect;
    
    
    UIView *citySelectView;
    CCitySelectView *select;
    BOOL isCitySelected;
    
    NSString *storeType;
    
    UISwitch * switchs;
    
    
}
@property (nonatomic,strong) PhotoCollectionView *photosView;
@property (nonatomic,strong) UIScrollView *addImageBtnView;
@property (nonatomic,strong) CDateChooserView *dateChooserView;
@property (nonatomic,strong) CSelectView *userCountSelect;
@property (nonatomic,strong)    NSArray<TLPersonCountDTO> *personNumArray;
@end

@implementation TLAddStoreViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商家编辑";
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
    [actionBtn setTitle:@"发表" forState:UIControlStateNormal];
    actionBtn.titleLabel.font = FONT_14B;
    //[actionBtn setImage:[UIImage imageNamed:@"more_xiaoxi"] forState:UIControlStateNormal];
    //    [actionBtn setImage:[UIImage imageNamed:@"ico_backon" ] forState:UIControlStateHighlighted];
    [actionBtn addTarget:self action:@selector(publishBtnHandler) forControlEvents:UIControlEventTouchUpInside];
    return actionBtn;
}

-(void)publishBtnHandler{
    
    /**
     @property (nonatomic,copy) NSString *title;// 标题
     @property (nonatomic,copy) NSString *cityId;// 城市编号
     @property (nonatomic,copy) NSString *destnation;// 目的地
     @property (nonatomic,copy) NSString *costAverage;//人均费用
     @property (nonatomic,copy) NSString *personNum;// 活动人数 , 1: 0-10人 用码表接口返回   activtyNum
     @property (nonatomic,copy) NSString *desc;// 活动描述
     @property (nonatomic,copy) NSArray *activityImage;//活动图片
     @property (nonatomic,copy) NSString *isTop;//是否置顶  1：置顶，0：不置顶
     */

    NSMutableArray *imageArray = [_photosView getPhotoArray];
    
    NSString *isTop;
    if (topBtn.selected) {
        isTop = @"1";
    }else{
        isTop = @"0";
    }
    
    if (imageArray.count==0) {
        [GHUDAlertUtils toggleMessage:@"请填写活动相关信息"];
        return;
    }
   
    
    TLSaveMarchantRequestDTO *request = [[TLSaveMarchantRequestDTO alloc] init];
    request.merchantName = titleField.text;
    request.merchantType = storeType;
    request.openTime = [NSString stringWithFormat:@"%@-%@",startTimeBtn.titleLabel.text,endTimeBtn.titleLabel.text];
    request.address = addressField.text;
    request.parking = switchs.on?@"1":@"0";
    request.merchantDesc = contentLabel.text;
    request.cityId = cityId;
    request.phone = phoneField.text;
    request.merchantIcon = imageArray[0];
    request.merchantImages = imageArray;
    
    __block NSString *longitude;
    __block NSString *latitude;
    [GUserDataHelper getLocationInfo:^(id currentLongitude, id currentLatitude) {
        longitude = currentLongitude;
        latitude = currentLatitude;
    }];
    request.longtitude = longitude;
    request.latitude = latitude;

    
    if (request.merchantName.length<=0||request.merchantType.length<=0||request.openTime.length<=0||request.address.length<=0||request.parking<=0||request.merchantImages.count==0||request.merchantDesc.length<=0||request.cityId.length<=0||request.phone.length<=0||request.merchantIcon==nil) {
        [GHUDAlertUtils toggleMessage:@"请填写活动相关信息"];
        return;
    }
    
    
    WEAK_SELF(self);
    [GHUDAlertUtils toggleLoadingInView:self.view];
    [GTLModuleDataHelper saveMerchant:request requestArr:self.requestArray block:^(id obj, BOOL ret) {
        
        
        [GHUDAlertUtils hideLoadingInView:self.view];
        ResponseDTO *response = obj;
        if (ret) {
            [GHUDAlertUtils toggleMessage:@"发表成功"];
            [weakSelf resetUI];
        }else{
            [GHUDAlertUtils toggleMessage:response.resultDesc];
            
        }
    }];
}

-(void)resetUI{

    titleField.text = @"";
    addressField.text = @"";
    phoneField.text = @"";
    costField.text = @"";
    cityField.text = @"";
    cityId = @"";
    contentLabel.text = @"";
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)addAllUIResources{

    CGFloat hGap = 5.f;
    CGFloat vGap = 5.f;
    CGFloat textHeight = 40.f;
    CGFloat addImageBtnHeight = 130.f;
    
    CGFloat yOffSet = vGap+NAVIGATIONBAR_HEIGHT+STATUSBAR_HEIGHT;
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0.f, yOffSet, CGRectGetWidth(self.view.frame), textHeight)];
    [titleView setBackgroundColor:UIColorFromRGBA(0xFFFFFF, 1.0f)];
    [self.view addSubview:titleView];
    
    titleField = [[UITextField alloc] initWithFrame:CGRectMake(hGap, 0.f, CGRectGetWidth(titleView.frame)-hGap*2, CGRectHeight(titleView.frame))];
    [titleView addSubview:titleField];
    titleField.placeholder = @"商家名称";
    
    yOffSet = yOffSet + titleView.height + vGap;
    
    
    CGFloat selectCityBtnWidth = 80.f;
    UIView *cityView = [[UIView alloc] initWithFrame:CGRectMake(0.f, yOffSet, CGRectGetWidth(self.view.frame), textHeight)];
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
    
    
     yOffSet = yOffSet + cityView.height + vGap;
    
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:FONT_16,NSFontAttributeName ,nil];
    CGSize size16 = [@"SIZE" sizeWithAttributes:dic];
    
    UIView *storeTypeView = [[UIView alloc] initWithFrame:CGRectMake(0.f, yOffSet, CGRectGetWidth(self.view.frame), textHeight)];
    [storeTypeView setBackgroundColor:UIColorFromRGBA(0xFFFFFF, 1.0f)];
    [self.view addSubview:storeTypeView];
    UILabel *storeTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(hGap, (textHeight-size16.height)/2, 100.f, size16.height)];
    
    storeTypeLabel.text = @"商家类型";
    storeTypeLabel.font = FONT_16;
    storeTypeLabel.textColor = COLOR_MAIN_TEXT;
    [storeTypeView addSubview:storeTypeLabel];
    
    storeTypeBtn = [[RTextIconBtn alloc] initWithFrame:CGRectMake(hGap*2+100.f,  (textHeight-size16.height)/2, 120.f, size16.height)];
    
    [storeTypeBtn setImage:[UIImage imageNamed:@"down2"] forState:UIControlStateNormal];
    [storeTypeBtn setImage:[UIImage imageNamed:@"up2"] forState:UIControlStateSelected];
    
    
    [storeTypeBtn setTitle:@"餐饮" forState:UIControlStateNormal];
    [storeTypeBtn setTitleColor:COLOR_MAIN_TEXT forState:UIControlStateNormal];
    storeTypeBtn.titleLabel.font = FONT_16;
    [storeTypeView addSubview:storeTypeBtn];
    [storeTypeBtn addTarget:self action:@selector(selectBtnHandler:) forControlEvents:UIControlEventTouchUpInside];
    
    yOffSet = yOffSet + storeTypeView.height + vGap;
    
    //地址
    UIView *addressView = [[UIView alloc] initWithFrame:CGRectMake(0.f, yOffSet, CGRectGetWidth(self.view.frame), textHeight)];
    [addressView setBackgroundColor:UIColorFromRGBA(0xFFFFFF, 1.0f)];
    [self.view addSubview:addressView];
    
    addressField = [[UITextField alloc] initWithFrame:CGRectMake(hGap, 0.f, CGRectGetWidth(addressView.frame)-hGap*2, CGRectHeight(addressView.frame))];
    [addressView addSubview:addressField];
    addressField.placeholder = @"地址";
    
    yOffSet = yOffSet + addressView.height + vGap;
    
    //电话
    UIView *phoneView = [[UIView alloc] initWithFrame:CGRectMake(0.f, yOffSet, CGRectGetWidth(self.view.frame), textHeight)];
    [phoneView setBackgroundColor:UIColorFromRGBA(0xFFFFFF, 1.0f)];
    [self.view addSubview:phoneView];
    
    phoneField = [[UITextField alloc] initWithFrame:CGRectMake(hGap, 0.f, CGRectGetWidth(phoneView.frame)-hGap*2, CGRectHeight(phoneView.frame))];
    [phoneView addSubview:phoneField];
    phoneField.placeholder = @"电话";
    phoneField.keyboardType = UIKeyboardTypeNumberPad;
    
    yOffSet = yOffSet + phoneView.height + vGap;
    //营业时间
    UIView *openTimeView = [[UIView alloc] initWithFrame:CGRectMake(0.f, yOffSet, CGRectGetWidth(self.view.frame), textHeight)];
    [openTimeView setBackgroundColor:UIColorFromRGBA(0xFFFFFF, 1.0f)];
    [self.view addSubview:openTimeView];
    
    UILabel *openTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(hGap, (textHeight-size16.height)/2, 100.f, size16.height)];
    
    openTimeLabel.text = @"营业时间";
    openTimeLabel.font = FONT_16;
    openTimeLabel.textColor = COLOR_MAIN_TEXT;
    [openTimeView addSubview:openTimeLabel];
    
    CGFloat seBtnWidth = (self.view.width-100-60)/2;
    
    startTimeBtn = [[RTextIconBtn alloc] initWithFrame:CGRectMake(hGap*2+100.f,  (textHeight-size16.height)/2, seBtnWidth, size16.height)];
    
    [startTimeBtn setImage:[UIImage imageNamed:@"down2"] forState:UIControlStateNormal];
    [startTimeBtn setImage:[UIImage imageNamed:@"up2"] forState:UIControlStateSelected];
    
    
    [startTimeBtn setTitle:@"06:00" forState:UIControlStateNormal];
    [startTimeBtn setTitleColor:COLOR_MAIN_TEXT forState:UIControlStateNormal];
    startTimeBtn.titleLabel.font = FONT_16;
    [openTimeView addSubview:startTimeBtn];
    [startTimeBtn addTarget:self action:@selector(selectStartTimeBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *toLabel = [[UILabel alloc] initWithFrame:CGRectMake(startTimeBtn.maxX, (textHeight-size16.height)/2, 20, size16.height)];
    
    toLabel.text = @"至";
    toLabel.font = FONT_16;
    toLabel.textColor = COLOR_MAIN_TEXT;
    [openTimeView addSubview:toLabel];

    
    endTimeBtn = [[RTextIconBtn alloc] initWithFrame:CGRectMake(toLabel.maxX,  (textHeight-size16.height)/2, seBtnWidth, size16.height)];
    
    [endTimeBtn setImage:[UIImage imageNamed:@"down2"] forState:UIControlStateNormal];
    [endTimeBtn setImage:[UIImage imageNamed:@"up2"] forState:UIControlStateSelected];
    
    
    [endTimeBtn setTitle:@"22:00" forState:UIControlStateNormal];
    [endTimeBtn setTitleColor:COLOR_MAIN_TEXT forState:UIControlStateNormal];
    endTimeBtn.titleLabel.font = FONT_16;
    [openTimeView addSubview:endTimeBtn];
    [endTimeBtn addTarget:self action:@selector(selectEndTimeBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    yOffSet = yOffSet + openTimeView.height + vGap;
    //停车场
    UIView *hasPrakView = [[UIView alloc] initWithFrame:CGRectMake(0.f, yOffSet, CGRectGetWidth(self.view.frame), textHeight)];
    [hasPrakView setBackgroundColor:UIColorFromRGBA(0xFFFFFF, 1.0f)];
    [self.view addSubview:hasPrakView];
    
    UILabel *hasParkLabel = [[UILabel alloc] initWithFrame:CGRectMake(hGap, (textHeight-size16.height)/2, 100.f, size16.height)];
    
    hasParkLabel.text = @"停车场:";
    hasParkLabel.font = FONT_16;
    hasParkLabel.textColor = COLOR_MAIN_TEXT;
    [hasPrakView addSubview:hasParkLabel];
    
    switchs = [[UISwitch alloc]initWithFrame:CGRectMake(hasPrakView.width-hGap-50, 5.f, 50, 40)];
    
    
    
    
    [switchs setOn:YES];
//    [switchs setAlternateColors:COLOR_ORANGE_TEXT];
    [switchs setTintColor:COLOR_ORANGE_TEXT];
    [switchs setOnTintColor:COLOR_ORANGE_TEXT];
    //[switchs addTarget:self action:@selector(switchsChanged:) forControlEvents:UIControlEventValueChanged];
    [hasPrakView addSubview:switchs];

    yOffSet = yOffSet + hasPrakView.height + vGap;
    
    //
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0.f, yOffSet, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-yOffSet-addImageBtnHeight)];
    [contentView setBackgroundColor:UIColorFromRGBA(0xFFFFFF, 1.0f)];
    [self.view addSubview:contentView];
    
    //    UITextView *contentTextView = [[UITextView alloc] initWithFrame:contentView.bounds];
    //    [contentView addSubview:contentTextView];
    
    contentLabel = [[ZXTextView alloc] initWithFrame:contentView.bounds];
    contentLabel.font = FONT_16;
    contentLabel.textColor = COLOR_MAIN_TEXT;
//    contentLabel.largeTextLength = 200;
    contentLabel.placeholder = @"商家特色";
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
    
    [self addDateChooser];
    //[self addDataChooser];
    [self getUserCountData];
    
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


//----------------------


-(void)getUserCountData{
    WEAK_SELF(self);
    TLCommonCodeRequestDTO *request = [[TLCommonCodeRequestDTO alloc] init];
    request.type = @"merchantType";
    
    [GHUDAlertUtils toggleLoadingInView:self.view];
    
    [GTLModuleDataHelper commonCode:request requestArray:self.requestArray block:^(id obj, BOOL ret) {
        
        
        [GHUDAlertUtils hideLoadingInView:self.view];
        
        if (ret) {
            weakSelf.personNumArray = obj;
            [weakSelf addUserCountSelect];
        }else{
            
        }
    }];
    
}

-(void)addUserCountSelect{
    if (self.userCountSelect) {
        
        //        [UIView animateWithDuration:0.5f animations:^{
        //            [self.dateChooserView setAlpha:0];
        //        } completion:^(BOOL finished) {
        [self.userCountSelect removeFromSuperview];
        //        }];
    }
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    [self.personNumArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        TLPersonCountDTO *dto = obj;
        NSDictionary *item = @{@"id":dto.codeValue,@"name":dto.codeName};
        [dataArray addObject:item];
    }];
    
    TLPersonCountDTO *first = self.personNumArray[0];
    storeType = first.codeValue;
    self.userCountSelect = [[CSelectView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame), 250.0f) itemData:@{@"id":first.codeValue,@"type":@"select",@"selectedId":first.codeValue,@"selectedName":first.codeName,@"data":dataArray,@"paramKey":@"personNum"}];
    WEAK_SELF(self);
    self.userCountSelect.OkBlock = ^(NSDictionary*data){
        [weakSelf selectChangeHandler:data];
    };
    [self.view addSubview:self.userCountSelect];
    [self.userCountSelect setSelectedData:@{@"SELECT_INDEX":@"0"}];
    
    
}

-(void)selectChangeHandler:(NSDictionary*)data{
    NSString *str = [data valueForKey:@"name"];
    //dateStr =[RUtiles stringFromDateWithFormat:[RUtiles dateFromString:dateStr format:@"yyyy年MM月dd日"] format:@"yyyy-MM-dd"];
    [storeTypeBtn setTitle:str forState:UIControlStateNormal];
    //[[RAPPLICATION currentUser] setAccDay:[RUtiles stringFromDateWithFormat:[RUtiles dateFromString:dateStr format:@"yyyy-MM-dd"] format:@"yyyyMMdd"]];
    //[self reloadViews];
    storeType = [data valueForKey:@"id"];
}


-(void)selectBtnHandler:(UIButton*)btn{
    
    [self.userCountSelect showContentView];
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


///////////start end date select///////////////
-(void)selectStartTimeBtn:(UIButton*)btn{
            isStartBtnSelect = YES;

    [self.dateChooserView setSelectedDate:[RUtiles dateFromString:startTimeBtn.titleLabel.text format:@"hh:mm"]];
    [self.dateChooserView showContentView];
}
-(void)selectEndTimeBtn:(UIButton*)btn{
    isStartBtnSelect = NO;
    
    [self.dateChooserView setSelectedDate:[RUtiles dateFromString:endTimeBtn.titleLabel.text format:@"hh:mm"]];
    [self.dateChooserView showContentView];
}
-(void)addDateChooser{
    self.dateChooserView = [[CDateChooserView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame), 250.0f) dateFormat:@"hh:mm" dateChoserType:1];
    
//    if (self.userInfoDto.birthDay.length>0) {
//        [self.dateChooserView setSelectedDate:[RUtiles dateFromString:self.userInfoDto.birthDay format:@"yyyy-MM-dd"]];
//    }
    
    
    WEAK_SELF(self);
    self.dateChooserView.OkBlock = ^(NSDictionary*data){
        [weakSelf setBirthStr: [data valueForKey:@"name"]];
        
    };
    self.dateChooserView.CancelBlock = ^(NSDictionary*data){
        
        [weakSelf.dateChooserView showHideContentView];
    };
    
    [self.view addSubview:self.dateChooserView];
    
}

-(void)selectBirthBtnHandler:(UIButton*)btn{
    
    [self.dateChooserView showContentView];
}

-(void)setBirthStr:(NSString *)str{
    if (isStartBtnSelect) {
        [startTimeBtn setTitle:str forState:UIControlStateNormal];
        [startTimeBtn setTitle:str forState:UIControlStateSelected];
    }else{
        [endTimeBtn setTitle:str forState:UIControlStateNormal];
        [endTimeBtn setTitle:str forState:UIControlStateSelected];
    }
    

}



@end
