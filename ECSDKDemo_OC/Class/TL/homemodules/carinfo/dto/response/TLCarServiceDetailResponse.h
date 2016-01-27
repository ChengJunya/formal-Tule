//
//  TLCarServiceDetailResponse.h
//  TL
//
//  Created by Rainbow on 3/30/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "BaseDTOModel.h"
#import "TLCarServiceResult.h"
@interface TLCarServiceDetailResponse : ResponseDTO
@property (nonatomic,copy)TLCarServiceResult *result;
@end
