//
//  TLCarEValDetailResponseDTo.h
//  TL
//
//  Created by Rainbow on 3/29/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "BaseDTOModel.h"
#import "TLCarEvalDetailResultDTO.h"
@interface TLCarEValDetailResponseDTo : ResponseDTO
@property (nonatomic,copy) TLCarEvalDetailResultDTO *result;
@end