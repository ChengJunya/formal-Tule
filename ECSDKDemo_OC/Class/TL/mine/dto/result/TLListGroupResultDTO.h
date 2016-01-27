//
//  TLListGroupResultDTO.h
//  TL
//
//  Created by Rainbow on 5/3/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "JSONModel.h"
#import "TLGroupDataDTO.h"
@interface TLListGroupResultDTO : JSONModel
@property (nonatomic,copy) NSArray<TLGroupDataDTO> *data;
@end
