//
//  TLMineInfoViewController.m
//  TL
//
//  Created by Rainbow on 2/26/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "TLMineInfoViewController.h"
#import "RImageList.h"
#import "TLUpdateFormItem.h"
#import "TLUserViewResultDTO.h"
#import "PhotoCollectionView.h"
#import "TLUserEditRequestDTO.h"
#import "RTextIconBtn.h"
#import "CSelectView.h"
#import "CDateChooserView.h"
#import "RUtiles.h"
#import "TLModuleDataHelper.h"
#import "TLPersonCountDTO.h"
#import "TLProvinceDTO.h"
#import "TLCityDTO.h"
#import "CCitySelectView.h"
#import "AddressDataHelper.h"

@interface TLMineInfoViewController ()<PhotosViewDelegate>{
    CGFloat yOffSet;
    RTextIconBtn *genderBtn;
    RTextIconBtn *birthBtn;
    
    RTextIconBtn *perfessionBtn;
    
    TLUpdateFormItem *nameFromItem;
     TLUpdateFormItem *cityFormItem;
    TLUpdateFormItem *professionFromItem;
    TLUpdateFormItem *interestFromItem;
    TLUpdateFormItem *signFromItem;
    TLUpdateFormItem *schoolFromItem;
    TLUpdateFormItem *jobFromItem;
    
    UIView *citySelectView;
    CCitySelectView *select;
    BOOL isCitySelected;
    UITextField *cityField;
    NSString *cityId;
    
    NSString *professionId;
}
@property (nonatomic,strong) UIScrollView *contentScrollView;
@property (nonatomic,strong) TLUserViewResultDTO *userInfoDto;
@property (nonatomic,strong) PhotoCollectionView *photosView;
@property (nonatomic,strong) UIScrollView *addImageBtnView;

@property (nonatomic,strong) CSelectView *genderSelect;
@property (nonatomic,strong) NSArray *genderSelectArray;

@property (nonatomic,strong) CDateChooserView *dateChooserView;

@property (nonatomic,strong) CSelectView *perfessionSelect;
@property (nonatomic,strong) NSArray *perfessionArray;

@end

@implementation TLMineInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人资料";
    self.userInfoDto = self.itemData;
    
    yOffSet = 0.f;
    self.contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.f, NAVIGATIONBAR_HEIGHT+STATUSBAR_HEIGHT, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-NAVIGATIONBAR_HEIGHT-STATUSBAR_HEIGHT)];
    [self.view addSubview:self.contentScrollView];
    
    
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
    [actionBtn setTitle:@"保存" forState:UIControlStateNormal];
    actionBtn.titleLabel.font = FONT_14B;
    //[actionBtn setImage:[UIImage imageNamed:@"more_xiaoxi"] forState:UIControlStateNormal];
    //    [actionBtn setImage:[UIImage imageNamed:@"ico_backon" ] forState:UIControlStateHighlighted];
    [actionBtn addTarget:self action:@selector(publishBtnHandler) forControlEvents:UIControlEventTouchUpInside];
    return actionBtn;
}

-(void)publishBtnHandler{
    
//    NSMutableDictionary *dic = _photosView.photosDataInfo;
//    NSMutableArray *imageArray = [[NSMutableArray alloc] init];
//    for (NSString *key in [dic allKeys]) {
//        [imageArray addObject:dic[key]];
//    }
    
    NSMutableArray *imageArray = [_photosView getPhotoArray];
    
    
    TLUserEditRequestDTO *request = [[TLUserEditRequestDTO alloc] init];
    request.userName = [nameFromItem updateValue];
    request.gender = self.userInfoDto.gender;
    request.birthday = self.userInfoDto.birthDay;
    request.profession = professionId;
    request.hobby = [interestFromItem updateValue];
    request.signature = [signFromItem updateValue];
    request.school = [schoolFromItem updateValue];
    request.job = [jobFromItem updateValue];
    request.userIcon = [imageArray objectAtIndex:0];
    [imageArray removeObjectAtIndex:0];
    request.userImg = imageArray;
    request.loginId = self.userInfoDto.loginId;
    request.cityId = cityId.length>0?cityId:@"";
    
    [GHUDAlertUtils toggleLoadingInView:self.view];
    [GTLModuleDataHelper editUserInfo:request requestArr:self.requestArray block:^(id obj, BOOL ret) {
        
        [GHUDAlertUtils hideLoadingInView:self.view];
        ResponseDTO *response = obj;
        if (ret) {
            [GHUDAlertUtils toggleMessage:@"修改成功"];
        }else{
            [GHUDAlertUtils toggleMessage:response.resultDesc];
        }
    }];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addAllUIResources{
    //images
    [self addImages];
    //usename
    [self addInfo];
    //gender
    //borthday
    //profession
    //interest
    //sign
    //school
    //job
    
     self.contentScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.contentScrollView.frame), yOffSet);
}

-(void)addImages{
    
    _addImageBtnView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.f, yOffSet, CGRectGetWidth(self.view.frame), 130.f) ];
    [_addImageBtnView setBackgroundColor:UIColorFromRGBA(0xFFFFFF, 1.0f)];
    [self.contentScrollView addSubview:_addImageBtnView];
    
    UIImage *firstImage;
    _photosView = [[PhotoCollectionView alloc] initWithFrame:CGRectMake(UI_LAYOUT_MARGIN, 0.f, DEVICE_WIDTH-UI_LAYOUT_MARGIN*2, 100.f) andImage:firstImage];
    _photosView.parentController = self;
    _photosView.delegate = self;
    _photosView.backgroundColor = [UIColor clearColor];
    [_addImageBtnView addSubview:_photosView];
    CGFloat contentHeight = self.userInfoDto.userImages.count>1?CGRectGetHeight(_photosView.frame)+100.f:CGRectGetHeight(_photosView.frame);
    [_photosView setH:contentHeight];
    _addImageBtnView.contentSize = CGSizeMake(_addImageBtnView.contentSize.width, contentHeight);
    WEAK_SELF(self);
    NSString *userIconUrl = [NSString stringWithFormat:@"%@%@",TL_SERVER_BASE_URL,self.userInfoDto.userIcon];
    //    CGFloat imageHeight = self.cellContentView.height;
    //    CGFloat imageWidth = self.cellContentView.width;
    if (userIconUrl) {
        UIImageView *tmp = [[UIImageView alloc] initWithFrame:CGRectZero];

        [tmp sd_setImageWithURL:[NSURL URLWithString:userIconUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [_photosView addShowImage:image];
            [weakSelf addUserImages];
        }];

    }else{
        [self addUserImages];
    }
    
    
//    NSArray *userImages = [self.userInfoDto userImages];
//    RImageList *imageList = [[RImageList alloc] initWithFrame:CGRectMake(0.f, yOffSet, CGRectGetWidth(self.view.frame), 80.0f) itemData:@{@"IMAGE_LIST":userImages} isShowImageName:NO];
//    [self.contentScrollView addSubview:imageList];
    
    yOffSet = yOffSet + CGRectGetHeight(_addImageBtnView.frame);
    
}

-(void)addUserImages{
    
    [self.userInfoDto.userImages enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        TLImageDTO *dto = obj;
        NSString *imageUrl = [NSString stringWithFormat:@"%@%@",TL_SERVER_BASE_URL,dto.imageUrl];
        //    CGFloat imageHeight = self.cellContentView.height;
        //    CGFloat imageWidth = self.cellContentView.width;
        if (imageUrl) {
            UIImageView *tmp = [[UIImageView alloc] initWithFrame:CGRectZero];
            
            [tmp sd_setImageWithURL:[NSURL URLWithString:imageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                [_photosView addShowImage:image];
                
                
            }];
            
        }
        
    }];
    
    
    
}

//PhotosViewDelegate
-(void)photosViewFrameDidChanged:(CGFloat)height
{
    CGRect photoFrame = _photosView.frame;
    photoFrame.size.height = height;
    _photosView.frame = photoFrame;
    
    _addImageBtnView.contentSize = CGSizeMake(_addImageBtnView.contentSize.width, CGRectGetHeight(_photosView.frame));
}


-(void)addInfo{
    CGFloat vGap = 3.f;
    CGFloat vSpace = 10.f;
    nameFromItem = [[TLUpdateFormItem alloc] initWithFrame:CGRectMake(0.f, yOffSet, CGRectGetWidth(self.view.frame), 40.f) itemData:@{@"LABEL_NAME":@"昵称：",@"LABEL_VALUE":self.userInfoDto.userName ,@"PLACE_HOLDER":@"写入昵称"}];
    [self.contentScrollView addSubview:nameFromItem];
    yOffSet = yOffSet + CGRectGetHeight(nameFromItem.frame) + vGap;
    
    TLUpdateFormItem *genderFromItem = [[TLUpdateFormItem alloc] initWithFrame:CGRectMake(0.f, yOffSet, CGRectGetWidth(self.view.frame), 40.f) itemData:@{@"LABEL_NAME":@"性别：",@"LABEL_VALUE":self.userInfoDto.gender,@"PLACE_HOLDER":@"写入性别"}];
    
    genderBtn = [[RTextIconBtn alloc] initWithFrame:CGRectMake(0.f,  0.f, 120.f, 30.f)];
    
    [genderBtn setImage:[UIImage imageNamed:@"down2"] forState:UIControlStateNormal];
    [genderBtn setImage:[UIImage imageNamed:@"up2"] forState:UIControlStateSelected];
    
    [genderBtn setTitle:self.userInfoDto.gender.integerValue==1?@"男":@"女" forState:UIControlStateNormal];
    [genderBtn setTitleColor:COLOR_MAIN_TEXT forState:UIControlStateNormal];
    genderBtn.titleLabel.font = FONT_16;
    [genderFromItem.rightView removeSubviews];
    [genderFromItem.rightView addSubview:genderBtn];
    [genderBtn addTarget:self action:@selector(selectBtnHandler:) forControlEvents:UIControlEventTouchUpInside];
    

    
    
    [self.contentScrollView addSubview:genderFromItem];
    yOffSet = yOffSet + CGRectGetHeight(genderFromItem.frame) + vGap;
    
    TLUpdateFormItem *borthdayFromItem = [[TLUpdateFormItem alloc] initWithFrame:CGRectMake(0.f, yOffSet, CGRectGetWidth(self.view.frame), 40.f) itemData:@{@"LABEL_NAME":@"出生日期：",@"LABEL_VALUE":self.userInfoDto.birthDay,@"PLACE_HOLDER":@"写入生日"}];
    [self.contentScrollView addSubview:borthdayFromItem];
    
    birthBtn = [[RTextIconBtn alloc] initWithFrame:CGRectMake(0.f,  0.f, 120.f, 30.f)];
    
    
    [birthBtn setTitle:self.userInfoDto.birthDay.length>0?self.userInfoDto.birthDay:@"请选择生日" forState:UIControlStateNormal];
    [birthBtn setTitleColor:COLOR_MAIN_TEXT forState:UIControlStateNormal];
    birthBtn.titleLabel.font = FONT_16;
    [borthdayFromItem.rightView removeSubviews];
    [borthdayFromItem.rightView addSubview:birthBtn];
    [birthBtn addTarget:self action:@selector(selectBirthBtnHandler:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    

    
    
    
    yOffSet = yOffSet + CGRectGetHeight(borthdayFromItem.frame) + vGap;
    
    
    
    
    cityFormItem = [[TLUpdateFormItem alloc] initWithFrame:CGRectMake(0.f, yOffSet, CGRectGetWidth(self.view.frame), 40.f) itemData:@{@"LABEL_NAME":@"城市：",@"LABEL_VALUE":self.userInfoDto.profession,@"PLACE_HOLDER":@"写入职业"}];
    [self.contentScrollView addSubview:cityFormItem];
    
    
    CGFloat selectCityBtnWidth = 80.f;
    UIView *cityView = [[UIView alloc] initWithFrame:CGRectMake(0.f,  -5.f, cityFormItem.rightView.width, 30.f)];


    
    cityField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0.f, cityView.width-selectCityBtnWidth, cityView.height)];
    [cityView addSubview:cityField];
    [cityField setEnabled:NO];
    cityField.font = FONT_14;
    cityField.textColor = COLOR_MAIN_TEXT;
    cityField.placeholder = @"请选择城市";
    
    if (self.userInfoDto.cityId.length>0) {
        cityId = self.userInfoDto.cityId;
        cityField.text = self.userInfoDto.cityName;
    }
    
    
    UIButton *selectCityBtn = [[UIButton alloc] initWithFrame:CGRectMake(cityField.maxX, 0, selectCityBtnWidth, cityView.height)];
    [selectCityBtn setBackgroundImage:[UIImage imageNamed:@"select_city"] forState:UIControlStateNormal];
    [cityView addSubview:selectCityBtn];
    

    
    
    [cityFormItem.rightView removeSubviews];
    [cityFormItem.rightView addSubview:cityView];
    [selectCityBtn addTarget:self action:@selector(cityBtnHandler:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    
    yOffSet = yOffSet + CGRectGetHeight(cityFormItem.frame) + vSpace;
    

    
    
    professionFromItem = [[TLUpdateFormItem alloc] initWithFrame:CGRectMake(0.f, yOffSet, CGRectGetWidth(self.view.frame), 40.f) itemData:@{@"LABEL_NAME":@"职业：",@"LABEL_VALUE":self.userInfoDto.profession,@"PLACE_HOLDER":@"写入职业"}];
    [self.contentScrollView addSubview:professionFromItem];
    
    
    perfessionBtn = [[RTextIconBtn alloc] initWithFrame:CGRectMake(0.f,  0.f, professionFromItem.rightView.width, 30.f)];
    
    [perfessionBtn setImage:[UIImage imageNamed:@"down2"] forState:UIControlStateNormal];
    [perfessionBtn setImage:[UIImage imageNamed:@"up2"] forState:UIControlStateSelected];
    
    //[perfessionBtn setTitle:self.userInfoDto.gender.integerValue==1?@"男":@"女" forState:UIControlStateNormal];
    [perfessionBtn setTitleColor:COLOR_MAIN_TEXT forState:UIControlStateNormal];
    perfessionBtn.titleLabel.font = FONT_16;
    [professionFromItem.rightView removeSubviews];
    [professionFromItem.rightView addSubview:perfessionBtn];
    [perfessionBtn addTarget:self action:@selector(selectPerssionBtnHandler:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    
    yOffSet = yOffSet + CGRectGetHeight(professionFromItem.frame) + vSpace;
    
    interestFromItem = [[TLUpdateFormItem alloc] initWithFrame:CGRectMake(0.f, yOffSet, CGRectGetWidth(self.view.frame), 40.f) itemData:@{@"LABEL_NAME":@"兴趣爱好：",@"LABEL_VALUE":self.userInfoDto.hobbies,@"PLACE_HOLDER":@"写入兴趣爱好，逗号分割"}];
    [self.contentScrollView addSubview:interestFromItem];
    yOffSet = yOffSet + CGRectGetHeight(interestFromItem.frame) + vGap;
    
    signFromItem = [[TLUpdateFormItem alloc] initWithFrame:CGRectMake(0.f, yOffSet, CGRectGetWidth(self.view.frame), 40.f) itemData:@{@"LABEL_NAME":@"个人签名：",@"LABEL_VALUE":self.userInfoDto.signature,@"PLACE_HOLDER":@"写入个人签名"}];
    [self.contentScrollView addSubview:signFromItem];
    yOffSet = yOffSet + CGRectGetHeight(signFromItem.frame) + vSpace;
    
    schoolFromItem = [[TLUpdateFormItem alloc] initWithFrame:CGRectMake(0.f, yOffSet, CGRectGetWidth(self.view.frame), 40.f) itemData:@{@"LABEL_NAME":@"毕业学校：",@"LABEL_VALUE":self.userInfoDto.school,@"PLACE_HOLDER":@"写入毕业学校名称"}];
    [self.contentScrollView addSubview:schoolFromItem];
    yOffSet = yOffSet + CGRectGetHeight(schoolFromItem.frame) + vGap;
    
    jobFromItem = [[TLUpdateFormItem alloc] initWithFrame:CGRectMake(0.f, yOffSet, CGRectGetWidth(self.view.frame), 40.f) itemData:@{@"LABEL_NAME":@"就职公司：",@"LABEL_VALUE":self.userInfoDto.job,@"PLACE_HOLDER":@"写入就职公司名称"}];
    [self.contentScrollView addSubview:jobFromItem];
    yOffSet = yOffSet + CGRectGetHeight(jobFromItem.frame) + vGap;
    
    

    [self addGenderSelect];
    [self addDateChooser];
    [self getPerfessionData];
    
}



-(void)addGenderSelect{
    if (self.genderSelect) {
        
        //        [UIView animateWithDuration:0.5f animations:^{
        //            [self.dateChooserView setAlpha:0];
        //        } completion:^(BOOL finished) {
        [self.genderSelect removeFromSuperview];
        //        }];
    }
    
    
    
    
    self.genderSelectArray = @[@{@"id":@"1",@"name":@"男"},@{@"id":@"0",@"name":@"女"}];
    
    //NSDictionary *selectedItem = @{@"id":self.userInfoDto.gender,@"name":self.userInfoDto.gender.integerValue==0?@"女":@"男"};
    
    __block NSInteger selectedIndex = 0;
    [self.genderSelectArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([[obj valueForKey:@"id"] isEqualToString:self.userInfoDto.gender]) {
            selectedIndex = idx;
        }
    }];
    
    
    
    
    self.genderSelect = [[CSelectView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame), 250.0f) itemData:@{@"id":self.userInfoDto.gender,@"type":@"select",@"selectedId":self.userInfoDto.gender,@"selectedName":self.userInfoDto.gender.integerValue==0?@"女":@"男",@"data":self.genderSelectArray,@"paramKey":@"gender"}];
    WEAK_SELF(self);
    self.genderSelect.OkBlock = ^(NSDictionary*data){
        [weakSelf selectChangeHandler:data];
    };
    [self.view addSubview:self.genderSelect];

     [self.genderSelect setSelectedData:@{@"SELECT_INDEX":[NSString stringWithFormat:@"%d",selectedIndex]}];
    
    
}

-(void)selectChangeHandler:(NSDictionary*)data{
    NSString *str = [data valueForKey:@"name"];
    //dateStr =[RUtiles stringFromDateWithFormat:[RUtiles dateFromString:dateStr format:@"yyyy年MM月dd日"] format:@"yyyy-MM-dd"];
    [genderBtn setTitle:str forState:UIControlStateNormal];
    [genderBtn setTitle:str forState:UIControlStateSelected];
    self.userInfoDto.gender = [data valueForKey:@"id"];
    
}


-(void)selectBtnHandler:(UIButton*)btn{
    
    [self.genderSelect showContentView];
}


-(void)addDateChooser{
    self.dateChooserView = [[CDateChooserView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame), 250.0f) dateFormat:@"yyyy-MM-dd" dateChoserType:2];
   
    if (self.userInfoDto.birthDay.length>0) {
        [self.dateChooserView setSelectedDate:[RUtiles dateFromString:self.userInfoDto.birthDay format:@"yyyy-MM-dd"]];
    }

    
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
    [birthBtn setTitle:str forState:UIControlStateNormal];
    [birthBtn setTitle:str forState:UIControlStateSelected];
    self.userInfoDto.birthDay = str;
}


-(void)getPerfessionData{
    WEAK_SELF(self);
    TLCommonCodeRequestDTO *request = [[TLCommonCodeRequestDTO alloc] init];
    request.type = @"profession";
    
    [GHUDAlertUtils toggleLoadingInView:self.view];
    
    [GTLModuleDataHelper commonCode:request requestArray:self.requestArray block:^(id obj, BOOL ret) {
        
        
        [GHUDAlertUtils hideLoadingInView:self.view];
        
        if (ret) {
            weakSelf.perfessionArray = obj;
            [weakSelf addPerfessionSelect];
        }else{
            
        }
    }];
    
}



-(void)addPerfessionSelect{
    if (self.perfessionArray.count==0) {
        return;
    }
    if (self.perfessionSelect) {
        
        //        [UIView animateWithDuration:0.5f animations:^{
        //            [self.dateChooserView setAlpha:0];
        //        } completion:^(BOOL finished) {
        [self.perfessionSelect removeFromSuperview];
        //        }];
    }
    
   __block  TLPersonCountDTO *first = self.perfessionArray[0];
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    [self.perfessionArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        TLPersonCountDTO *dto = obj;
        NSDictionary *item = @{@"id":dto.codeValue,@"name":dto.codeName};
        if ([dto.codeName isEqualToString:self.userInfoDto.profession]) {
            first = dto;
        }
        [dataArray addObject:item];
    }];
    
    
    
    [perfessionBtn setTitle:first.codeName forState:UIControlStateNormal];
    [perfessionBtn setTitle:first.codeName forState:UIControlStateSelected];
    professionId = first.codeValue;
    
    
    self.perfessionSelect = [[CSelectView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame), 250.0f) itemData:@{@"id":first.codeValue,@"type":@"select",@"selectedId":first.codeValue,@"selectedName":first.codeName,@"data":dataArray,@"paramKey":@"profession"}];
    WEAK_SELF(self);
    self.perfessionSelect.OkBlock = ^(NSDictionary*data){
        [weakSelf selectPerssionChangeHandler:data];
    };
    [self.view addSubview:self.perfessionSelect];
    [self.perfessionSelect setSelectedData:@{@"SELECT_INDEX":@"0"}];
    
    
    
}

-(void)selectPerssionChangeHandler:(NSDictionary*)data{
    NSString *str = [data valueForKey:@"name"];
    
    [perfessionBtn setTitle:str forState:UIControlStateNormal];
    [perfessionBtn setTitle:str forState:UIControlStateSelected];
    professionId = [data valueForKey:@"id"];
    
}


-(void)selectPerssionBtnHandler:(UIButton*)btn{
    
    [self.perfessionSelect showContentView];
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
