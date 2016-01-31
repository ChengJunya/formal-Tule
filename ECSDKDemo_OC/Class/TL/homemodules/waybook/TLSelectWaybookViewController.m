//
//  TLSelectWaybookViewController.m
//  TL
//
//  Created by Rainbow on 2/16/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "TLSelectWaybookViewController.h"
#import "RDataButton.h"
#import "TLModuleDataHelper.h"
#import "TLTripListRequestDTO.h"
#import "TLTripDataDTO.h"
#import "RUtiles.h"
@interface TLSelectWaybookViewController (){
    NSArray *mywaybookArray;
}
@property (nonatomic,strong)    UIView *selectWaybookView;

@end

@implementation TLSelectWaybookViewController


-(instancetype)initWIthType:(NSString*)type{
    self = [super init];
    if (self) {
        self.type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getMyWayBook];
}


-(void)addSelectView{
    
    CGFloat vGap = 30.f;
    CGFloat paddingTop = 200.f;
    
    //1-续写  2-新增 3-取消 4-修改
    NSArray *selectArray = @[@{@"ID":@"01",@"TYPE":@"2",@"TITLE":@"新建"},
                             @{@"ID":@"01",@"TYPE":@"3",@"TITLE":@"取消"}];
    
    _selectWaybookView = [[UIView alloc] initWithFrame:CGRectMake(vGap, paddingTop, CGRectGetWidth(self.view.frame)-vGap*2, (selectArray.count+mywaybookArray.count)*40.f)];
    [self.view addSubview:_selectWaybookView];
    _selectWaybookView.backgroundColor = COLOR_DEF_BG;
    
    
    __block CGFloat maxY = 0.f;
    [mywaybookArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        TLTripDataDTO *dto = obj;
        
        CGRect buttonFrame = CGRectMake(0.f, 40*idx, CGRectGetWidth(_selectWaybookView.frame), 40.f);
        RDataButton *btn = [[RDataButton alloc] initWithFrame:buttonFrame];
        btn.itemData = obj;
        [btn setTitle:[NSString stringWithFormat:@"《%@》", dto.title] forState:UIControlStateNormal];
        btn.titleLabel.textColor = COLOR_MAIN_TEXT;
        [btn addTarget:self action:@selector(wayBookBtnHandler:) forControlEvents:UIControlEventTouchUpInside];
        [_selectWaybookView addSubview:btn];
        maxY = btn.maxY;
        
    }];
    
    [selectArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CGRect buttonFrame = CGRectMake(0.f, 40*idx + maxY , CGRectGetWidth(_selectWaybookView.frame), 40.f);
        RDataButton *btn = [[RDataButton alloc] initWithFrame:buttonFrame];
        //[btn setValue:obj forKey:@"ITEM_DATA"];
        btn.itemData = obj;
        [btn setTitle:[obj valueForKey:@"TITLE"] forState:UIControlStateNormal];
        btn.titleLabel.textColor = COLOR_MAIN_TEXT;
        [btn addTarget:self action:@selector(btnHandler:) forControlEvents:UIControlEventTouchUpInside];
        [_selectWaybookView addSubview:btn];
    }];

}



-(void)getMyWayBook{
    
    TLTripListRequestDTO *request = [[TLTripListRequestDTO alloc] init];
    
    request.currentPage = [NSString stringWithFormat:@"%d",1];
    request.pageSize = [NSString stringWithFormat:@"%d",1];
    request.orderByTime = @"1";
    request.orderByViewCount = @"0";
    request.cityId = @"0";
    request.type = self.type;
    request.dataType = @"1";
    request.currentTime = [RUtiles stringFromDateWithFormat:[NSDate new] format:@"yyyyMMddHHmmss"];
    request.orderBy = @"0";
    request.loginId = GUserDataHelper.tlUserInfo.loginId;
    NSMutableArray *requestArray = [[NSMutableArray alloc] init];
    [GHUDAlertUtils toggleLoadingInView:self.view];
    [GTLModuleDataHelper getTripList:request requestArr:requestArray block:^(id obj, BOOL ret, int pageNumber) {
        [GHUDAlertUtils hideLoadingInView:self.view];
        
        if (ret) {
            mywaybookArray = obj;
            [self addSelectView];
        }else{
           
        }
    }];
}


-(void)wayBookBtnHandler:(RDataButton *)btn{
    
    TLTripDataDTO *itemData = btn.itemData;
    if (self.ItemSelectedBlock) {
        self.ItemSelectedBlock(itemData);
    }
}


-(void)btnHandler:(RDataButton *)btn{
    id itemData = btn.itemData;
    
    if (self.NewItemSelectedBlock) {
        self.NewItemSelectedBlock(itemData);
    }
    
}

@end
