//
//  TLCarServiceMackScoreResponse.h
//  TL
//
//  Created by Rainbow on 3/30/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "BaseDTOModel.h"
#import "TLCarServiceMackScoreResult.h"
@interface TLCarServiceMackScoreResponse : ResponseDTO
@property (nonatomic,copy)TLCarServiceMackScoreResult *result;
@end
