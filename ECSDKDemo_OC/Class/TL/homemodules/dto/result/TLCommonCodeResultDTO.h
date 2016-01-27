//
//  TLCommonCodeResultDTO.h
//  TL
//
//  Created by Rainbow on 3/20/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "JSONModel.h"
#import "TLPersonCountDTO.h"
@interface TLCommonCodeResultDTO : JSONModel
@property (nonatomic,copy) NSArray<TLPersonCountDTO> *data;
@end
