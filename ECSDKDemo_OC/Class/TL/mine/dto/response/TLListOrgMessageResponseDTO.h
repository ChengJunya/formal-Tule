//
//  TLListOrgMessageResponseDTO.h
//  TL
//
//  Created by YONGFU on 5/19/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "BaseDTOModel.h"
#import "TLListOrgMessageResultDTO.h"
@interface TLListOrgMessageResponseDTO : ResponseDTO
@property (nonatomic,copy) TLListOrgMessageResultDTO *result;
@end
