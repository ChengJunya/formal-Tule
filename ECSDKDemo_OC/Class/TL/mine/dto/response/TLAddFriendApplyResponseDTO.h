//
//  TLAddFriendApplyResponseDTO.h
//  TL
//
//  Created by Rainbow on 4/27/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "BaseDTOModel.h"
#import "TLAddFriendApplayResultDTO.h"
@interface TLAddFriendApplyResponseDTO : ResponseDTO
@property (nonatomic,copy) TLAddFriendApplayResultDTO *result;
@end
