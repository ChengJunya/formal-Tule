//
//  TLTripTravelDTO.h
//  TL
//
//  Created by Rainbow on 3/17/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "JSONModel.h"

//列表路数节点信息
@protocol TLTripTravelDTO


@end

@interface TLTripTravelDTO : JSONModel
@property (nonatomic,copy) NSString *lsNodeId;
@property (nonatomic,copy) NSString *travelId;
@property (nonatomic,copy) NSString *cityId;
@property (nonatomic,copy) NSString *cityName;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *createTime;
@property (nonatomic,copy) NSString *createUser;
@property (nonatomic,copy) NSString *modifyTime;


@end


/**
 --路书节点
 {
 "lsNodeId":1       ---路书节点编码
 "travelId":1,         ---路书编码
 "cityId":11,          ---地市编码
 "cityName":"沧州"  ---地市名称
 "content":"迎着清晨的第一缕阳光。。"
 "createTime":"2015-03-01 00:00:00"
 -----创建时间
 "createUser":"101010"   ---用户登陆ID
 "modifyTime":"2015-03-01 00:00:00"
 -----修改时间
 }
*/