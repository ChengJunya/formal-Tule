//
//  TLActivityListResultDTO.h
//  TL
//
//  Created by Rainbow on 3/20/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "JSONModel.h"
#import "TLActivityDTO.h"
@interface TLActivityListResultDTO : JSONModel
@property (nonatomic,copy) NSArray<TLActivityDTO> *data;
@end
