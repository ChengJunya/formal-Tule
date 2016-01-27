//
//  TLTripListRequestDTO.h
//  TL
//
//  Created by Rainbow on 3/17/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "BaseDTOModel.h"

@interface TLTripListRequestDTO : RequestDTO
@property (nonatomic,copy) NSString *pageSize;//条数
@property (nonatomic,copy) NSString *currentPage;//当前页
@property (nonatomic,copy) NSString *orderByTime;//0 1
@property (nonatomic,copy) NSString *orderByViewCount;//0 1 人气排名
@property (nonatomic,copy) NSString *currentTime;

@property (nonatomic,copy) NSString *cityId;//
@property (nonatomic,copy) NSString *type;//1-攻略 2*-路数 3*-游记

@property (nonatomic, assign) NSInteger totalPages; //总页数 首次为空
@property (nonatomic, assign) NSInteger totalRecords; //总条数 首次为空

@property (nonatomic,copy) NSString *dataType;//1-网络请求全部 2-本地保存 3-我的
@property (nonatomic,copy) NSString *loginId;//1-网络请求全部 2-本地保存 3-我的
@property (nonatomic,copy) NSString *searchText;//搜索关键词

@property (nonatomic,copy) NSString *orderBy;//排序编码
@end
