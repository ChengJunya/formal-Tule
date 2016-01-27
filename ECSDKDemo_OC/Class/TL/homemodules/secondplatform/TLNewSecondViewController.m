//
//  TLNewSecondViewController.m
//  TL
//
//  Created by Rainbow on 2/20/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "TLNewSecondViewController.h"

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
#import "TLSecondGoodsResult.h"


@interface TLNewSecondViewController ()<PhotosViewDelegate>{
    //RTextIconBtn *selectDateBtn;
    RTextIconBtn *rentTypeBtn;
    UITextField *titleField;
    UITextField *carTypeField;
    RIconTextBtn *topBtn;
    UITextField *cityField;
    NSString *cityId;
    ZXTextView *contentLabel;
    UITextField *runKmField;
    UITextField *proNameField;
    NSString *rentType;
    UITextField *newPercentField;
    UITextField *priceField;
    
    
    UIView *citySelectView;
    CCitySelectView *select;
    BOOL isCitySelected;

    
    RTextIconBtn *goodsTypeBtn;
    NSString *goodsTypeId;
}
@property (nonatomic,strong) PhotoCollectionView *photosView;
@property (nonatomic,strong) UIScrollView *addImageBtnView;
//@property (nonatomic,strong) CDateChooserView *dateChooserView;
//@property (nonatomic,strong) CSelectView *rentTypeSelect;

@property (nonatomic,strong) CSelectView *userCountSelect;
@property (nonatomic,strong) CSelectView *rentTypeSelect;
@property (nonatomic,strong) NSArray *goodsTypeArray;

@property (nonatomic,strong) TLSecondGoodsResult *detailDto;
@end

@implementation TLNewSecondViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.detailDto = self.itemData;
    self.title = @"二手宝贝";
    [self addAllUIResources];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navBarHidden = NO;
    self.navBackItemHidden = NO;
    
    self.navView.actionBtns = @[[self addPublishActionBtn]];
    if (self.operationType.integerValue==2) {
        [self updateUI];
    }
}

-(void)updateUI{
    titleField.text = self.detailDto.title;
    cityField.text = self.detailDto.cityName;
    cityId = self.detailDto.cityId;
    proNameField.text = self.detailDto.goodsName;
    newPercentField.text = self.detailDto.oldDesc;
    priceField.text = self.detailDto.price;
    contentLabel.text = self.detailDto.goodsDesc;
    [goodsTypeBtn setTitle:self.detailDto.goodsType forState:UIControlStateNormal];
    
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
    
    
    if (self.operationType.integerValue==1&&imageArray.count==0) {
        [GHUDAlertUtils toggleMessage:@"请填写宝贝相关信息"];
        return;
    }
    
    
    /*
     
     @property (nonatomic,copy) NSString *title;
     @property (nonatomic,copy) NSString *goodsName;
     @property (nonatomic,copy) NSString *oldDesc;
     @property (nonatomic,copy) NSString *price;-
     @property (nonatomic,copy) NSString *address;-
     @property (nonatomic,copy) NSString *goodsDesc;-
     @property (nonatomic,copy) NSArray *goodsImage;-
     @property (nonatomic,copy) NSString *isTop;-
     */
    
    TLSaveSecondGoodsRequest *request = [[TLSaveSecondGoodsRequest alloc] init];
    request.title = titleField.text;
    request.goodsName = proNameField.text;
    request.oldDesc = newPercentField.text;
    request.price = priceField.text;
    request.address = cityId;
    request.goodsDesc = contentLabel.text;
    request.isTop = isTop;
    request.goodsImage = imageArray;
    request.operateType = self.operationType;
    request.objId = self.detailDto.goodsId.length>0?self.detailDto.goodsId:@"";
    request.goodsType = goodsTypeId;
    
    
    if (request.title.length<=0||request.goodsName.length<=0||request.oldDesc.length<=0||request.price.length<=0||request.address.length<=0||request.oldDesc.length<=0) {
        [GHUDAlertUtils toggleMessage:@"请填写宝贝相关信息"];
        return;
    }
    
    
    WEAK_SELF(self);
    [GHUDAlertUtils toggleLoadingInView:self.view];
    [GTLModuleDataHelper addSecondGoods:request requestArr:self.requestArray block:^(id obj, BOOL ret) {
        
        
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
    
    //-------------babyname---------
    
    UIView *proNameView = [[UIView alloc] initWithFrame:CGRectMake(0.f, vGap+yOffSet, CGRectGetWidth(self.view.frame), textHeight)];
    [proNameView setBackgroundColor:UIColorFromRGBA(0xFFFFFF, 1.0f)];
    [self.view addSubview:proNameView];
    
    proNameField = [[UITextField alloc] initWithFrame:CGRectMake(hGap, 0.f, CGRectGetWidth(proNameView.frame)-hGap*2, CGRectHeight(proNameView.frame))];
    [proNameView addSubview:proNameField];
    proNameField.placeholder = @"写入宝贝名称";
    
    yOffSet = yOffSet+CGRectGetHeight(proNameView.frame)+vGap;
    
    //----------new percent-------------
    UIView *newPercentView = [[UIView alloc] initWithFrame:CGRectMake(0.f, vGap+yOffSet, CGRectGetWidth(self.view.frame), textHeight)];
    [newPercentView setBackgroundColor:UIColorFromRGBA(0xFFFFFF, 1.0f)];
    [self.view addSubview:newPercentView];
    
    newPercentField = [[UITextField alloc] initWithFrame:CGRectMake(hGap, 0.f, CGRectGetWidth(newPercentView.frame)-hGap*2, CGRectHeight(newPercentView.frame))];
    [newPercentView addSubview:newPercentField];
    newPercentField.placeholder = @"写入成色，宝贝有多新";
    
    yOffSet = yOffSet+CGRectGetHeight(newPercentView.frame)+vGap;
    
    //------------price-----------
    UIView *priceView = [[UIView alloc] initWithFrame:CGRectMake(0.f, vGap+yOffSet, CGRectGetWidth(self.view.frame), textHeight)];
    [priceView setBackgroundColor:UIColorFromRGBA(0xFFFFFF, 1.0f)];
    [self.view addSubview:priceView];
    
    priceField = [[UITextField alloc] initWithFrame:CGRectMake(hGap, 0.f, CGRectGetWidth(priceView.frame)-hGap*2, CGRectHeight(priceView.frame))];
    [priceView addSubview:priceField];
    priceField.placeholder = @"写入价钱";
    priceField.keyboardType = UIKeyboardTypeNumberPad;
    yOffSet = yOffSet+CGRectGetHeight(priceView.frame)+vGap;
    //---------------contentView-----------
    
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:FONT_16,NSFontAttributeName ,nil];
    CGSize size16 = [@"SIZE" sizeWithAttributes:dic];
    UIView *goodsTypeView = [[UIView alloc] initWithFrame:CGRectMake(0.f, vGap+yOffSet, CGRectGetWidth(self.view.frame), textHeight)];
    [goodsTypeView setBackgroundColor:UIColorFromRGBA(0xFFFFFF, 1.0f)];
    [self.view addSubview:goodsTypeView];
    UILabel *goodsTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(hGap, (textHeight-size16.height)/2, 100.f, size16.height)];
    goodsTypeLabel.text = @"宝贝分类：";
    goodsTypeLabel.font = FONT_16;
    goodsTypeLabel.textColor = COLOR_MAIN_TEXT;
    [goodsTypeView addSubview:goodsTypeLabel];
    
    goodsTypeBtn = [[RTextIconBtn alloc] initWithFrame:CGRectMake(hGap*2+100.f,  (textHeight-size16.height)/2, 120.f, size16.height)];
    
    [goodsTypeBtn setImage:[UIImage imageNamed:@"down2"] forState:UIControlStateNormal];
    [goodsTypeBtn setImage:[UIImage imageNamed:@"up2"] forState:UIControlStateSelected];
    
    
    [goodsTypeBtn setTitle:@"" forState:UIControlStateNormal];
    [goodsTypeBtn setTitleColor:COLOR_MAIN_TEXT forState:UIControlStateNormal];
    goodsTypeBtn.titleLabel.font = FONT_16;
    [goodsTypeView addSubview:goodsTypeBtn];
    [goodsTypeBtn addTarget:self action:@selector(selectBtnHandler:) forControlEvents:UIControlEventTouchUpInside];
    
    
        yOffSet = yOffSet+CGRectGetHeight(goodsTypeView.frame)+vGap;
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0.f, vGap+yOffSet, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-yOffSet-vGap-addImageBtnHeight)];
    [contentView setBackgroundColor:UIColorFromRGBA(0xFFFFFF, 1.0f)];
    [self.view addSubview:contentView];
    
//    UITextView *contentTextView = [[UITextView alloc] initWithFrame:contentView.bounds];
//    [contentView addSubview:contentTextView];

    contentLabel = [[ZXTextView alloc] initWithFrame:contentView.bounds];
    contentLabel.font = FONT_16;
    contentLabel.textColor = COLOR_MAIN_TEXT;
//    contentLabel.largeTextLength = 200;
    contentLabel.placeholder = @"宝贝描述";
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
    [self getGoodsTypeData];
    
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
//-(void)addRentTypeSelect{
//    if (self.rentTypeSelect) {
//        
//        //        [UIView animateWithDuration:0.5f animations:^{
//        //            [self.dateChooserView setAlpha:0];
//        //        } completion:^(BOOL finished) {
//        [self.rentTypeSelect removeFromSuperview];
//        //        }];
//    }
//    
//    self.rentTypeSelect = [[CSelectView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame), 250.0f) itemData:@{@"id":@"1",@"type":@"select",@"selectedId":@"1",@"selectedName":@"日租",@"data":@[@{@"id":@"1",@"name":@"日租"},@{@"id":@"2",@"name":@"月租"},@{@"id":@"3",@"name":@"年租"}],@"paramKey":@"accDay"}];
//    __weak TLNewSecondViewController *controller  = self;
//    self.rentTypeSelect.OkBlock = ^(NSDictionary*data){
//        [controller selectChangeHandler:data];
//    };
//    [self.view addSubview:self.rentTypeSelect];
//    [self.rentTypeSelect setSelectedData:@{@"SELECT_INDEX":@"0"}];
//    
//    
//}

//-(void)selectChangeHandler:(NSDictionary*)data{
//    NSString *str = [data valueForKey:@"name"];
//    //dateStr =[RUtiles stringFromDateWithFormat:[RUtiles dateFromString:dateStr format:@"yyyy年MM月dd日"] format:@"yyyy-MM-dd"];
//    [rentTypeBtn setTitle:str forState:UIControlStateNormal];
//    //[[RAPPLICATION currentUser] setAccDay:[RUtiles stringFromDateWithFormat:[RUtiles dateFromString:dateStr format:@"yyyy-MM-dd"] format:@"yyyyMMdd"]];
//    //[self reloadViews];
//}


//-(void)selectBtnHandler:(UIButton*)btn{
//    
//    [self.rentTypeSelect showContentView];
//}


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



////////goodstype/////
//----------------------


-(void)getGoodsTypeData{
    WEAK_SELF(self);
    TLCommonCodeRequestDTO *request = [[TLCommonCodeRequestDTO alloc] init];
    request.type = @"goodsType";
    
    [GHUDAlertUtils toggleLoadingInView:self.view];
    
    [GTLModuleDataHelper commonCode:request requestArray:self.requestArray block:^(id obj, BOOL ret) {
        
        
        [GHUDAlertUtils hideLoadingInView:self.view];
        
        if (ret) {
            weakSelf.goodsTypeArray = obj;
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
    __block TLPersonCountDTO *first = self.goodsTypeArray[0];
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    [self.goodsTypeArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        TLPersonCountDTO *dto = obj;
        NSDictionary *item = @{@"id":dto.codeValue,@"name":dto.codeName};
        if ([dto.codeName isEqualToString:goodsTypeBtn.titleLabel.text]) {
            first = dto;
           
        }
        [dataArray addObject:item];
    }];
    
    goodsTypeId = first.codeValue;
    [goodsTypeBtn setTitle:first.codeName forState:UIControlStateNormal];
    
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
    [goodsTypeBtn setTitle:str forState:UIControlStateNormal];
    //[[RAPPLICATION currentUser] setAccDay:[RUtiles stringFromDateWithFormat:[RUtiles dateFromString:dateStr format:@"yyyy-MM-dd"] format:@"yyyyMMdd"]];
    //[self reloadViews];
    goodsTypeId = [data valueForKey:@"id"];
}


-(void)selectBtnHandler:(UIButton*)btn{
    
    [self.userCountSelect showContentView];
}



@end
