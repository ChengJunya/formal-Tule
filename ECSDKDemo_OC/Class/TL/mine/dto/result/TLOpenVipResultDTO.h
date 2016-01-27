//
//  TLOpenVipResultDTO.h
//  TL
//
//  Created by Rainbow on 4/27/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "JSONModel.h"

@interface TLOpenVipResultDTO : JSONModel
@property (nonatomic,copy) NSString *buyInfo;
@property (nonatomic,copy) NSString *endDate;
@end

/**


 buyInfo":" "               --购买信息（vipType=1返回）
 "endDate":"2016-02-01 00:00:00"             --会员截止日期（vip=2返回）
*/