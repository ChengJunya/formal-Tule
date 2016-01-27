//
//  TLNewsListResultDTO.h
//  TL
//
//  Created by Rainbow on 4/27/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "JSONModel.h"
#import "TLNewsDataDTO.h"
@interface TLNewsListResultDTO : JSONModel
@property (nonatomic,copy) NSArray<TLNewsDataDTO> *data;
@end
