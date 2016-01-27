//
//  AddressDataHelper.h
//  alijk
//
//  Created by easy on 14-8-8.
//  Copyright (c) 2014年 zhongxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SuperDataHelper.h"

@class AddressDTO;
@interface AddressDataHelper : SuperDataHelper

ZX_DECLARE_SINGLETON(AddressDataHelper)
/*
 * 清空内存中的数据
 */
- (void)clearAllMemoryData;


/**
 * 获取省份列表
*/
- (void)getProvinceList:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block;

/**
 * 获取地市
 */
- (void)getCityList:(NSString*)provinceId requestArr:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block;

- (void)getDistrictList:(NSString*)cityId requestArr:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block;


@end
