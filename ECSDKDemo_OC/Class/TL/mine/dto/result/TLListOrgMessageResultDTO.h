//
//  TLListOrgMessageResultDTO.h
//  TL
//
//  Created by YONGFU on 5/19/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "JSONModel.h"
#import "TLOrgMessageDTO.h"
@interface TLListOrgMessageResultDTO : JSONModel
@property (nonatomic,copy) NSArray<TLOrgMessageDTO> *data;
@end
