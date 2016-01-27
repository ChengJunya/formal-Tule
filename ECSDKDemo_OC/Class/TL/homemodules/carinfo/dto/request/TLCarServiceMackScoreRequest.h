//
//  TLCarServiceMackScoreRequest.h
//  TL
//
//  Created by Rainbow on 3/30/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "BaseDTOModel.h"

@interface TLCarServiceMackScoreRequest : RequestDTO
@property (nonatomic,copy) NSString *serviceId;
@property (nonatomic,copy) NSString *merchantId;
@property (nonatomic,copy) NSString *score;
@end


/*
 serviceId
 String
 是
 服务编号
 score
 String
 是
 评分，取值为1-5
*/