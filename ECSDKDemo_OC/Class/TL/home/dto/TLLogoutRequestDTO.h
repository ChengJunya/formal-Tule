//
//  TLLogoutRequestDTO.h
//  TL
//
//  Created by YONGFU on 5/20/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "BaseDTOModel.h"

@interface TLLogoutRequestDTO : RequestDTO
@property (nonatomic,copy) NSString* deviceType;
@end
