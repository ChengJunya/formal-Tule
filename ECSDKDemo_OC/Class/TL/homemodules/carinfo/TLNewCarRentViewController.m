//
//  TLNewCarRentViewController.m
//  TL
//
//  Created by Rainbow on 2/20/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "TLNewCarRentViewController.h"
#import "RIconTextBtn.h"
#import "PhotoCollectionView.h"
#import "RTextIconBtn.h"
//#import "CDateChooserView.h"
#import "RUtiles.h"
#import "CSelectView.h"
#import "TLSaveCarRectRequestDTO.h"
#import "TLModuleDataHelper.h"
#import "ZXTextView.h"
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
#import "TLViewCarRectResultDTO.h"



@interface TLNewCarRentViewController ()<PhotosViewDelegate>{
    //RTextIconBtn *selectDateBtn;
    RTextIconBtn *rentTypeBtn;
    UITextField *titleField;
    UITextField *carTypeField;
    RIconTextBtn *topBtn;
    UITextField *cityField;
    NSString *cityId;
    ZXTextView *contentLabel;
    UITextField *runKmField;
    NSString *rentType;
    UITextField *moneyField;
    UITextField *requireField;
    
    UIView *citySelectView;
    CCitySelectView *select;
    BOOL isCitySelected;
    
}
@property (nonatomic,strong) PhotoCollectionView *photosView;
@property (nonatomic,strong) UIScrollView *addImageBtnView;
@property (nonatomic,strong) CSelectView *userCountSelect;
@property (nonatomic,strong) CSelectView *rentTypeSelect;
@property (nonatomic,strong) NSArray *rentTypeArray;
@property (nonatomic,strong) TLViewCarRectResultDTO *detailDto;

@end

@implementation TLNewCarRentViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.detailDto = self.itemData;
    self.title = @"车辆租赁";
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

-(void)updateUI{
    titleField.text = self.detailDto.title;
    cityField.text = self.detailDto.cityName;
    cityId = self.detailDto.cityId;
    carTypeField.text = self.detailDto.carType;
    [rentTypeBtn setTitle:self.detailDto.rentType forState:UIControlStateNormal];
    runKmField.text = self.detailDto.driveDistance;
    moneyField.text = self.detailDto.rentMoney;
    requireField.text = self.detailDto.require;
    contentLabel.text = self.detailDto.carDesc;
    
    _photosView.hidden = YES;
    
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
    NSMutableDictionary *dic = _photosView.photosDataInfo;
    NSMutableArray *imageArray = [[NSMutableArray alloc] init];
    for (NSString *key in [dic allKeys]) {
        [imageArray addObject:dic[key]];
    }
    
    NSString *isTop;
    if (topBtn.selected) {
        isTop = @"1";
    }else{
        isTop = @"0";
    }
    
    
    /*
     
     @property (nonatomic,copy) NSString *title;
     @property (nonatomic,copy) NSString *carType;
     @property (nonatomic,copy) NSString *rentType;
     @property (nonatomic,copy) NSString *driveDistance;
     @property (nonatomic,copy) NSString *address;
     @property (nonatomic,copy) NSString *carDesc;
     @property (nonatomic,copy) NSString *isTop;
     @property (nonatomic,copy) NSArray<TLImageDTO> *carImage;
     
     */
    
    TLSaveCarRectRequestDTO *request = [[TLSaveCarRectRequestDTO alloc] init];
    request.title = titleField.text;
    request.carType = carTypeField.text;
    request.rentType = rentType;
    request.driveDistance = runKmField.text;
    request.address = cityField.text;
    request.cityId = cityId;
    request.carDesc = contentLabel.text;
    request.isTop = isTop;
    
    request.carImage = imageArray;
    request.carAge = requireField.text;
    request.price = moneyField.text;
    request.operateType = self.operateType;
    request.objId = self.detailDto.rentId.length>0?self.detailDto.rentId:@"";
    
    
    
    
    if (self.operateType.integerValue==1&&request.carImage.count==0) {
        [GHUDAlertUtils toggleMessage:@"请填写活动相关信息"];
        return;
    }
    
    
    if (request.title.length<=0||request.carType.length<=0||request.rentType.length<=0||request.driveDistance.length<=0||request.address.length<=0||request.carDesc.length<=0) {
        [GHUDAlertUtils toggleMessage:@"请填写车辆租赁相关信息"];
        return;
    }
    
    
    WEAK_SELF(self);
    [GHUDAlertUtils toggleLoadingInView:self.view];
    [GTLModuleDataHelper addCarRect:request requestArr:self.requestArray block:^(id obj, BOOL ret) {
        
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
            [self.navigationController popViewControllerAnimated:YES];
}
-(void)addAllUIResources{
    CGFloat hGap = 5.f;
    CGFloat vGap = 5.f;
    CGFloat topWidth = 80.f;
    CGFloat textHeight = 40.f;
    CGFloat addImageBtnHeight = 130.f;
    CGFloat yOffSet = NAVIGATIONBAR_HEIGHT+STATUSBAR_HEIGHT;
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0.f, vGap+yOffSet, CGRectGetWidth(self.view.frame)-hGap-topWidth, textHeight)];
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
    
    yOffSet = yOffSet+CGRectGetHeight(topView.frame)+vGap;
    //---------city-----------
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

    
    yOffSet = yOffSet+CGRectGetHeight(cityView.frame)+vGap;
    
    //-------------cartype---------
    
    UIView *carTypeView = [[UIView alloc] initWithFrame:CGRectMake(0.f, vGap+yOffSet, CGRectGetWidth(self.view.frame), textHeight)];
    [carTypeView setBackgroundColor:UIColorFromRGBA(0xFFFFFF, 1.0f)];
    [self.view addSubview:carTypeView];
    
    carTypeField = [[UITextField alloc] initWithFrame:CGRectMake(hGap, 0.f, CGRectGetWidth(carTypeView.frame)-hGap*2, CGRectHeight(carTypeView.frame))];
    [carTypeView addSubview:carTypeField];
    carTypeField.placeholder = @"写入车型";
    
    yOffSet = yOffSet+CGRectGetHeight(carTypeView.frame)+vGap;
    
    //----------renttype-------------
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:FONT_16,NSFontAttributeName ,nil];
    CGSize size16 = [@"SIZE" sizeWithAttributes:dic];
    
    
    //activity user count
    UIView *rentTypeView = [[UIView alloc] initWithFrame:CGRectMake(0.f, vGap+yOffSet, CGRectGetWidth(self.view.frame), textHeight)];
    [rentTypeView setBackgroundColor:UIColorFromRGBA(0xFFFFFF, 1.0f)];
    [self.view addSubview:rentTypeView];
    UILabel *activityUserLabel = [[UILabel alloc] initWithFrame:CGRectMake(hGap, (textHeight-size16.height)/2, 100.f, size16.height)];
    activityUserLabel.text = @"租赁方式：";
    activityUserLabel.font = FONT_16;
    activityUserLabel.textColor = COLOR_MAIN_TEXT;
    [rentTypeView addSubview:activityUserLabel];
    
    rentTypeBtn = [[RTextIconBtn alloc] initWithFrame:CGRectMake(hGap*2+100.f,  (textHeight-size16.height)/2, 120.f, size16.height)];
    
    [rentTypeBtn setImage:[UIImage imageNamed:@"down2"] forState:UIControlStateNormal];
    [rentTypeBtn setImage:[UIImage imageNamed:@"up2"] forState:UIControlStateSelected];
    
    [rentTypeBtn setTitle:@"日租" forState:UIControlStateNormal];
    [rentTypeBtn setTitleColor:COLOR_MAIN_TEXT forState:UIControlStateNormal];
    rentTypeBtn.titleLabel.font = FONT_16;
    [rentTypeView addSubview:rentTypeBtn];
    [rentTypeBtn addTarget:self action:@selector(selectBtnHandler:) forControlEvents:UIControlEventTouchUpInside];
    
    
     yOffSet = yOffSet+CGRectGetHeight(rentTypeView.frame)+vGap;

    //------------runkm-----------
    UIView *runKmView = [[UIView alloc] initWithFrame:CGRectMake(0.f, vGap+yOffSet, CGRectGetWidth(self.view.frame), textHeight)];
    [runKmView setBackgroundColor:UIColorFromRGBA(0xFFFFFF, 1.0f)];
    [self.view addSubview:runKmView];
    
    runKmField = [[UITextField alloc] initWithFrame:CGRectMake(hGap, 0.f, CGRectGetWidth(runKmView.frame)-hGap*2, CGRectHeight(runKmView.frame))];
    [runKmView addSubview:runKmField];
    runKmField.placeholder = @"写入行驶公里数";
    runKmField.keyboardType =  UIKeyboardTypeNumberPad;
    yOffSet = yOffSet+CGRectGetHeight(runKmView.frame)+vGap;
    
    //------------moneyView-----------
    UIView *moneyView = [[UIView alloc] initWithFrame:CGRectMake(0.f, vGap+yOffSet, CGRectGetWidth(self.view.frame), textHeight)];
    [moneyView setBackgroundColor:UIColorFromRGBA(0xFFFFFF, 1.0f)];
    [self.view addSubview:moneyView];

    moneyField = [[UITextField alloc] initWithFrame:CGRectMake(hGap, 0.f, CGRectGetWidth(moneyView.frame)-hGap*2, CGRectHeight(moneyView.frame))];
    [moneyView addSubview:moneyField];
    moneyField.placeholder = @"租金";
    moneyField.keyboardType =  UIKeyboardTypeNumberPad;
    yOffSet = yOffSet+CGRectGetHeight(moneyField.frame)+vGap;
    
    //------------require-----------
    UIView *require = [[UIView alloc] initWithFrame:CGRectMake(0.f, vGap+yOffSet, CGRectGetWidth(self.view.frame), textHeight)];
    [require setBackgroundColor:UIColorFromRGBA(0xFFFFFF, 1.0f)];
    [self.view addSubview:require];
    
    requireField = [[UITextField alloc] initWithFrame:CGRectMake(hGap, 0.f, CGRectGetWidth(require.frame)-hGap*2, CGRectHeight(require.frame))];
    requireField.keyboardType = UIKeyboardTypeNumberPad;
    [require addSubview:requireField];
    requireField.placeholder = @"车龄";
    yOffSet = yOffSet+CGRectGetHeight(require.frame)+vGap;
    //---------------contentView-----------
    
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0.f, vGap+yOffSet, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-yOffSet-vGap-addImageBtnHeight)];
    [contentView setBackgroundColor:UIColorFromRGBA(0xFFFFFF, 1.0f)];
    [self.view addSubview:contentView];
    
//    UITextView *contentTextView = [[UITextView alloc] initWithFrame:contentView.bounds];
//    [contentView addSubview:contentTextView];
//    

    contentLabel = [[ZXTextView alloc] initWithFrame:contentView.bounds];
    contentLabel.font = FONT_16;
    contentLabel.textColor = COLOR_MAIN_TEXT;
//    contentLabel.largeTextLength = 200;
    contentLabel.placeholder = @"租赁描述";
    contentLabel.keyboardType = UIKeyboardTypeDefault;
    //    detailAddressLabel.delegate = self;//不能再设代理了,代理走的是helper
    contentLabel.autoHideKeyboard = YES;
    contentLabel.scrollEnabled = YES;
    [contentView addSubview:contentLabel];
    contentLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    
    
    
    //--------imagebtn---------------------
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
    
//    [self addDataChooser];
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


////----------------------
//-(void)addDataChooser{
//    if (self.dateChooserView) {
//        
//        //        [UIView animateWithDuration:0.5f animations:^{
//        //            [self.dateChooserView setAlpha:0];
//        //        } completion:^(BOOL finished) {
//        [self.dateChooserView removeFromSuperview];
//        //        }];
//    }
//    
//    self.dateChooserView = [[CDateChooserView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame), 250.0f)];
//    __weak TLNewCarRentViewController *controller  = self;
//    self.dateChooserView.OkBlock = ^(NSDictionary*data){
//        [controller dataChangeHandler:data];
//    };
//    [self.view addSubview:self.dateChooserView];
//    [self.dateChooserView setSelectedDate:[NSDate new]];
//    
//    
//}
//
//-(void)dataChangeHandler:(NSDictionary*)data{
//    NSString *dateStr = [data valueForKey:@"name"];
//    //dateStr =[RUtiles stringFromDateWithFormat:[RUtiles dateFromString:dateStr format:@"yyyy年MM月dd日"] format:@"yyyy-MM-dd"];
//    [selectDateBtn setTitle:dateStr forState:UIControlStateNormal];
//    //[[RAPPLICATION currentUser] setAccDay:[RUtiles stringFromDateWithFormat:[RUtiles dateFromString:dateStr format:@"yyyy-MM-dd"] format:@"yyyyMMdd"]];
//    //[self reloadViews];
//}
//
//
//-(void)dateBtnHandler:(UIButton*)btn{
//    
//    [self.dateChooserView showContentView];
//}
//----------------------------

//----------------------

//----------------------


-(void)getUserCountData{
    WEAK_SELF(self);
    TLCommonCodeRequestDTO *request = [[TLCommonCodeRequestDTO alloc] init];
    request.type = @"rentType";
    
    [GHUDAlertUtils toggleLoadingInView:self.view];
    
    [GTLModuleDataHelper commonCode:request requestArray:self.requestArray block:^(id obj, BOOL ret) {
        
        
        [GHUDAlertUtils hideLoadingInView:self.view];
        
        if (ret) {
            weakSelf.rentTypeArray = obj;
            [weakSelf addRentTypeSelect];
        }else{
            
        }
    }];
    
}



-(void)addRentTypeSelect{
    if (self.rentTypeSelect) {
        
        //        [UIView animateWithDuration:0.5f animations:^{
        //            [self.dateChooserView setAlpha:0];
        //        } completion:^(BOOL finished) {
        [self.rentTypeSelect removeFromSuperview];
        //        }];
    }
    __block TLPersonCountDTO *first = self.rentTypeArray[0];
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    [self.rentTypeArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        TLPersonCountDTO *dto = obj;
        NSDictionary *item = @{@"id":dto.codeValue,@"name":dto.codeName};
        if ([self.detailDto.rentType isEqualToString:dto.codeName]) {
            first = dto;
        }
        [dataArray addObject:item];
    }];
    
    rentType = first.codeValue;
    [rentTypeBtn setTitle:first.codeName forState:UIControlStateNormal];
    

    

    
    self.rentTypeSelect = [[CSelectView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame), 250.0f) itemData:@{@"id":first.codeValue,@"type":@"select",@"selectedId":first.codeValue,@"selectedName":first.codeName,@"data":dataArray,@"paramKey":@"personNum"}];
    WEAK_SELF(self);
    self.rentTypeSelect.OkBlock = ^(NSDictionary*data){
        [weakSelf selectChangeHandler:data];
    };
    [self.view addSubview:self.rentTypeSelect];
    [self.rentTypeSelect setSelectedData:@{@"SELECT_INDEX":@"0"}];
    
    
    
}

-(void)selectChangeHandler:(NSDictionary*)data{
    NSString *str = [data valueForKey:@"name"];
    //dateStr =[RUtiles stringFromDateWithFormat:[RUtiles dateFromString:dateStr format:@"yyyy年MM月dd日"] format:@"yyyy-MM-dd"];
    [rentTypeBtn setTitle:str forState:UIControlStateNormal];
    rentType = [data valueForKey:@"id"];
    //[[RAPPLICATION currentUser] setAccDay:[RUtiles stringFromDateWithFormat:[RUtiles dateFromString:dateStr format:@"yyyy-MM-dd"] format:@"yyyyMMdd"]];
    //[self reloadViews];
}


-(void)selectBtnHandler:(UIButton*)btn{
    
    [self.rentTypeSelect showContentView];
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

@end
