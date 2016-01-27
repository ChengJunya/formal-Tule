//
//  TLCommentListResultDTO.h
//  TL
//
//  Created by Rainbow on 3/17/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "JSONModel.h"
#import "TLCommentDataDTO.h"
@interface TLCommentListResultDTO : JSONModel
@property(nonatomic,copy) NSArray<TLCommentDataDTO> *data;
@end
