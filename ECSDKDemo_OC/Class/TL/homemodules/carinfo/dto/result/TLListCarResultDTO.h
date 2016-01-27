//
//  TLListCarResultDTO.h
//  TL
//
//  Created by Rainbow on 3/29/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "JSONModel.h"
#import "TLListCarDTO.h"
@interface TLListCarResultDTO : JSONModel
@property (nonatomic,copy) NSArray<TLListCarDTO> *data;
@end
