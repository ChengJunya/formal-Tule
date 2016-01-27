//
//  TLTlbChargeResultDTO.h
//  TL
//
//  Created by YONGFU on 8/12/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "JSONModel.h"

@interface TLTlbChargeResultDTO : JSONModel
@property (nonatomic,copy) NSString *tlb;
@property (nonatomic,copy) NSString *orderId;
@property (nonatomic,copy) NSString *chargeAmount;
@property (nonatomic,copy) NSString *chargePrice;
@end


/*

 "tlb":200                               --充值后途乐币数
 "orderId":""                          --订单号
 "chargeAmount":100          --充值途乐币数
 "chargePrice":10                  --充值金额（单位元 ）
*/