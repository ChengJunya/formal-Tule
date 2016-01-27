//
//  TLWaitingImageResponseDTO.h
//  TL
//
//  Created by YONGFU on 6/2/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "BaseDTOModel.h"
#import "TLWaitingData.h"
@interface TLWaitingImageResponseDTO : ResponseDTO
@property (nonatomic,copy) TLWaitingData*result;
@end
