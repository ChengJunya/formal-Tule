//
//  TLInviteGroupUser.h
//  TL
//
//  Created by YONGFU on 7/9/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "BaseDTOModel.h"

@interface TLInviteGroupUser : RequestDTO
@property (nonatomic,strong) NSString *rlGroupId;
@property (nonatomic,strong) NSString *loginIds;
@end


/*
 rlGroupId
 String
 是
 容联群组编号
 loginIds

*/