//
//  TLSendOrgMessageResponseDTO.h
//  TL
//
//  Created by YONGFU on 5/19/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "BaseDTOModel.h"
#import "TLSendOrgMessageResultDTO.h"
@interface TLSendOrgMessageResponseDTO : ResponseDTO
@property (nonatomic,copy) TLSendOrgMessageResultDTO *result;
@end
