//
//  TLCommonResult.h
//  TL
//
//  Created by Rainbow on 4/8/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "JSONModel.h"
#import "TLUserViewResultDTO.h"
@interface TLCommonResult : JSONModel
@property (nonatomic,copy) TLUserViewResultDTO *result;
@end
