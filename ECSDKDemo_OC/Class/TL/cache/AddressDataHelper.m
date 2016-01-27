//
//  AddressDataHelper.m
//  alijk
//
//  Created by easy on 14-8-8.
//  Copyright (c) 2014年 zhongxin. All rights reserved.
//

#import "AddressDataHelper.h"
#import "UserDataHelper.h"




#import "TLProvinceRequestDTO.h"
#import "TLProvinceResponseDTO.h"
#import "TLCityRequestDTO.h"
#import "TLCityResponseDTO.h"
#import "TLDistrictRequestDTO.h"
#import "TLDistrictResponseDTO.h"


#define TABLE_PAGE_ADDRESS_SIZE 20

@interface AddressDataHelper ()

@property (nonatomic, strong) NSMutableArray *addressList;

@property (nonatomic, assign) BOOL isRequestSucceed; // 请求地址接口成功

@property (nonatomic,strong) NSArray *provinceList;//provinceList
@property (nonatomic,strong) NSMutableDictionary *proviceCityDic;//privinceId  cityList
@property (nonatomic,strong) NSMutableDictionary *cityDistrictDic;//cityId  districtList

@end


@implementation AddressDataHelper

ZX_IMPLEMENT_SINGLETON(AddressDataHelper)

- (id)init
{
    if (self = [super init]) {
        self.addressList = [NSMutableArray array];
        self.proviceCityDic = [[NSMutableDictionary alloc] init];
        self.cityDistrictDic = [[NSMutableDictionary alloc] init];
        
    }
    
    return self;
}







/*
 * 清空内存中的数据
 */
- (void)clearAllMemoryData
{
    [self.addressList removeAllObjects];

    self.isRequestSucceed = NO;
}





///yf

/**
 * 获取省份列表
 */
- (void)getProvinceList:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block{

    if (self.provinceList) {
        if (block) {
            block(self.provinceList, YES);
        }
        return;
    }
    
    TLProvinceRequestDTO* proviceRequstDTO = [[TLProvinceRequestDTO alloc] init];

    
    NSNumber *requestTag = [GDataManager asyncRequestByType:NetAdapter_User_Register_Provice_Getter andObject:proviceRequstDTO success:^(TLProvinceResponseDTO* responseDTO) {
        self.provinceList =  responseDTO.result.data;
        if (block) {
            block(self.provinceList, YES);
        }
    } failure:^(id responseDTO) {
        if (block) {
            block(nil, NO);
        }
    }];
    [requestArr addObject:requestTag];
}

/**
 * 获取地市
 */
- (void)getCityList:(NSString*)provinceId requestArr:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block{
    if ([self.proviceCityDic valueForKey:provinceId]) {
        if (block) {
            block([self.proviceCityDic valueForKey:provinceId], YES);
        }
        return;
    }
    
    TLCityRequestDTO* addrequestDTO = [[TLCityRequestDTO alloc] init];
    addrequestDTO.provinceId = provinceId;
    
    NSNumber *requestTag = [GDataManager asyncRequestByType:NetAdapter_User_Register_City_Getter andObject:addrequestDTO success:^(TLCityResponseDTO* responseDTO) {
        [self.proviceCityDic setValue:responseDTO.result.data forKey:provinceId];
        if (block) {
            block([self.proviceCityDic valueForKey:provinceId], YES);
        }
    } failure:^(id responseDTO) {
        if (block) {
            block(nil, NO);
        }
    }];
    [requestArr addObject:requestTag];
}

//获取地市
- (void)getDistrictList:(NSString*)cityId requestArr:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block{
    if ([self.cityDistrictDic valueForKey:cityId]) {
        if (block) {
            block([self.cityDistrictDic valueForKey:cityId], YES);
        }
        return;
    }
    
    TLDistrictRequestDTO* addrequestDTO = [[TLDistrictRequestDTO alloc] init];
    addrequestDTO.cityId = cityId;
    
    NSNumber *requestTag = [GDataManager asyncRequestByType:NetAdapter_User_Register_District_Getter andObject:addrequestDTO success:^(TLDistrictResponseDTO* responseDTO) {
        [self.cityDistrictDic setValue:responseDTO.result.data forKey:cityId];
        if (block) {
            block([self.cityDistrictDic valueForKey:cityId], YES);
        }
    } failure:^(id responseDTO) {
        if (block) {
            block(nil, NO);
        }
    }];
    [requestArr addObject:requestTag];
}


@end
