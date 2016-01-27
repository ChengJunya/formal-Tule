//
//  TLLoginResultDTO.h
//  TL
//
//  Created by Rainbow on 3/8/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "JSONModel.h"
#import "UserInfoDTO.h"
@interface TLLoginResultDTO : JSONModel
@property (nonatomic,copy) UserInfoDTO *userInfo;
@end
