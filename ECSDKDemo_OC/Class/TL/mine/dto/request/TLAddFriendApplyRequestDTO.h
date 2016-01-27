//
//  TLAddFriendApplyRequestDTO.h
//  TL
//
//  Created by Rainbow on 4/27/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "BaseDTOModel.h"

@interface TLAddFriendApplyRequestDTO : RequestDTO
@property (nonatomic,copy) NSString *loginId;
@property (nonatomic,copy) NSString *type;
@end
