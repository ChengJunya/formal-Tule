//
//  TLOpenVipRequestDTO.h
//  TL
//
//  Created by Rainbow on 4/27/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "BaseDTOModel.h"

@interface TLOpenVipRequestDTO : RequestDTO
@property (nonatomic,copy) NSString *vipType;
@property (nonatomic,copy) NSString *operateType;
@end


/*
 vipType
 String
 是
 开通的vip类型
 1：月会员
 2：年会员
 
 operateType
 String
 是
 操作类型
 1：提交前查询服务器端返回的信息，例如：包月会员需要消耗您30途乐币，请问您是否继续？
 2：开通会员


*/