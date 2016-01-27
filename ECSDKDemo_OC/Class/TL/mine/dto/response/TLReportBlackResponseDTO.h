//
//  TLReportBlackResponseDTO.h
//  TL
//
//  Created by YONGFU on 5/30/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "BaseDTOModel.h"
#import "TLReportBlackResultDTO.h"
@interface TLReportBlackResponseDTO : ResponseDTO
@property (nonatomic,copy) TLReportBlackResultDTO *result;
@end
