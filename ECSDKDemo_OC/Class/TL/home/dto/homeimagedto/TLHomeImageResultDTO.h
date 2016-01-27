//
//  TLHomeImageResultDTO.h
//  TL
//
//  Created by Rainbow on 3/8/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "JSONModel.h"
#import "TLHomeImageDTO.h"
@interface TLHomeImageResultDTO : JSONModel
@property (nonatomic,copy) NSArray<TLHomeImageDTO> *data;
@end
