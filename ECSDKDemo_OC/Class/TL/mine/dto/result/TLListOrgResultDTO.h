//
//  TLListOrgResultDTO.h
//  TL
//
//  Created by Rainbow on 5/3/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "JSONModel.h"
#import "TLOrgDataDTO.h"
@interface TLListOrgResultDTO : JSONModel
@property (nonatomic,copy) NSArray<TLOrgDataDTO> *data;
@end
