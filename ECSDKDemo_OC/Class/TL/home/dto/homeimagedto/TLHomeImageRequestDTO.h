//
//  TLHomeImageRequestDTO.h
//  TL
//
//  Created by Rainbow on 3/8/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "BaseDTOModel.h"

@interface TLHomeImageRequestDTO : RequestDTO
@property (nonatomic,copy) NSString *width;
@property (nonatomic,copy) NSString *height;

@end
