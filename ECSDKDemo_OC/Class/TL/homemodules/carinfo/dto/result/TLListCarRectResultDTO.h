//
//  TLListCarRectResultDTO.h
//  TL
//
//  Created by Rainbow on 3/29/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "JSONModel.h"
#import "TLCarRectDTO.h"
@interface TLListCarRectResultDTO : JSONModel
@property (nonatomic,copy) NSArray<TLCarRectDTO> *data;
@end
