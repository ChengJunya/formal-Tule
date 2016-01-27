//
//  TLBuyTLBResultDTO.h
//  TL
//
//  Created by Rainbow on 4/27/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "JSONModel.h"

@interface TLBuyTLBResultDTO : JSONModel
@property (nonatomic,copy) NSString *tlbCount;
@property (nonatomic,copy) NSString *orderId;
@property (nonatomic,copy) NSString *orderMoney;
@property (nonatomic,copy) NSString<Optional> *androidAlipaycreateOrderUrl;
@property (nonatomic,copy) NSString<Optional> *iosAlipaycreateOrderUrl;




@property (nonatomic,copy) NSString *alipayNotifyUrl;

@property (nonatomic,copy) NSString *productName;
@property (nonatomic,copy) NSString *productDesc;
@end


/*

 "tlbCount":20               --返回当前金额能够购买的tlb数
 "orderId":"tl2014050419000000"   --返回当前交易的订单编号（支付交易中需要使用）
 "orderMoney":2           --交易金额(元)
 "alipayBackNotifyUrl":""        --支付方扣款成功后台通知地址
 "weichatBackNotifyUrl":""     --微信支付扣款成功后台通知地址
 
 "productName":""                   --商品名称
 "productDesc":""
*/