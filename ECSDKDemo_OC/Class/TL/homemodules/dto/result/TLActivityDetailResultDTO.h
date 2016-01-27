//
//  TLActivityDetailResultDTO.h
//  TL
//
//  Created by Rainbow on 3/20/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "JSONModel.h"
#import "TLActivityDetailDTO.h"

@interface TLActivityDetailResultDTO : JSONModel
@property (nonatomic,copy) TLActivityDetailDTO *data;
@end
