//
//  TLCitySelectView.m
//  TL
//
//  Created by Rainbow on 2/10/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "TLCitySelectView.h"
#import "BoncDataGridDataSource.h"
#import "AddressDataHelper.h"
#import "TLProvinceDTO.h"
#import "TLCityDTO.h"
@interface TLCitySelectView()
@property (nonatomic,strong) UITableView *provinceTable;
@property (nonatomic,strong) UITableView *cityTable;
@property (nonatomic,strong) BoncDataGridDataSource *provinceTableViewDataSource;
@property (nonatomic,strong) BoncDataGridDataSource *cityTableViewDataSource;
@end
@implementation TLCitySelectView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addProvinceTable];
        [self addCityTable];
        [self getProvince];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(void)addProvinceTable{
    
    NSArray *dataList = @[];
    

    self.provinceTable = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.frame)/2, self.height)];
    [self addSubview:self.provinceTable];
    self.provinceTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.provinceTable.backgroundColor = COLOR_DEF_BG;
    NSDictionary *itemData = @{
                               @"type": @"REPORT",
                               @"gridType": PROVINCE_CELL,
                               @"gridId": PROVINCE_CELL,
                               @"GRID_DATA": @[dataList],
                               @"SECTION_DATA":@[@{@"SECTION_TYPE":@"1",@"CELL_TYPE": PROVINCE_CELL}],
                               @"isShowHeader": @"0",
                               @"headerData": @{}
                               };
    self.provinceTableViewDataSource = [[BoncDataGridDataSource alloc] initWithTableView:self.provinceTable itemData:itemData];
    __weak TLCitySelectView *weakController = self;
    
    self.provinceTableViewDataSource.ItemSelectedBlock = ^(id itemData){
        [weakController provinceItemSelected:itemData];
    };
    
}
-(void)addCityTable{
    

    
    NSArray *dataList = @[];
    
    
    self.cityTable = [[UITableView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)/2, 0.0f, CGRectGetWidth(self.frame)/2, self.height)];
    [self addSubview:self.cityTable];
    self.cityTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.cityTable.backgroundColor = UIColorFromRGB(0xCCCCCC);
    NSDictionary *itemData = @{
                               @"type": @"REPORT",
                               @"gridType": CITY_CELL,
                               @"gridId": CITY_CELL,
                               @"GRID_DATA": @[dataList],
                               @"SECTION_DATA":@[@{@"SECTION_TYPE":@"1",@"CELL_TYPE": CITY_CELL}],
                               @"isShowHeader": @"0",
                               @"headerData": @{}
                               };
    
    self.cityTableViewDataSource = [[BoncDataGridDataSource alloc] initWithTableView:self.cityTable itemData:itemData];
    __weak TLCitySelectView *weakController = self;
    
    self.cityTableViewDataSource.ItemSelectedBlock = ^(id itemData){
        [weakController cityItemSelected:itemData];
    };
    
}

-(void)provinceItemSelected:(TLProvinceDTO *)itemData{
    NSLog(@"%@",itemData.provinceName);
    [self getCityByProvinceId:itemData.provinceId ];
    
    
}

-(void)cityItemSelected:(TLCityDTO *)itemData{
    NSLog(@"%@",itemData.cityName);
    if (self.SelectedCityBlock) {
        self.SelectedCityBlock(itemData);
    }
    
}

//获取省份
-(void)getProvince{
    WEAK_SELF(self);
    [GAddressHelper getProvinceList:nil block:^(id obj, BOOL ret) {
        //验证成功
        if (ret) {
            NSArray *proviceList = obj;
            NSMutableArray *array = [[NSMutableArray alloc] init];
            [array addObject:[NSMutableArray arrayWithArray:proviceList]];
            [weakSelf.provinceTableViewDataSource setGridData:array];
            if (proviceList.count>0) {
                NSIndexPath *first = [NSIndexPath indexPathForRow:0 inSection:0];
                [weakSelf.provinceTable selectRowAtIndexPath:first animated:YES scrollPosition:UITableViewScrollPositionTop];
                TLProvinceDTO *provice = proviceList[0];
                [weakSelf getCityByProvinceId:provice.provinceId];
                
            }
            
        }
        
        
    }];
}

-(void)getCityByProvinceId:(NSString*)provinceId{
    WEAK_SELF(self);
    [GAddressHelper getCityList:provinceId requestArr:nil block:^(id obj, BOOL ret) {
        //验证成功
        if (ret) {
            NSArray *cityList = obj;
            NSMutableArray *array = [[NSMutableArray alloc] init];
            [array addObject:[NSMutableArray arrayWithArray:cityList]];
            [weakSelf.cityTableViewDataSource setGridData:array];
            
            if (cityList.count>0) {
                NSIndexPath *first = [NSIndexPath indexPathForRow:0 inSection:0];
                [self.cityTable selectRowAtIndexPath:first animated:YES scrollPosition:UITableViewScrollPositionTop];
            }
        }
        
        
    }];
}


@end
