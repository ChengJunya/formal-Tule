//
//  TLSysMEssageListResultDTO.h
//  TL
//
//  Created by YONGFU on 5/31/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "JSONModel.h"
#import "TLSysMessageDTO.h"
@interface TLSysMEssageListResultDTO : JSONModel
@property (nonatomic,strong) NSArray<TLSysMessageDTO> *data;
@end
