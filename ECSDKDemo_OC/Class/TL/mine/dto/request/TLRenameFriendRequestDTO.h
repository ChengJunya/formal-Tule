//
//  TLRenameFriendRequestDTO.h
//  TL
//
//  Created by YONGFU on 5/22/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "BaseDTOModel.h"

@interface TLRenameFriendRequestDTO : RequestDTO
@property (nonatomic,copy) NSString *friendLoginId;
@property (nonatomic,copy) NSString *friendNote;
@end


/*

 
 参数名称
 参数类型(String,json Object)
 是否必填（是，否）
 备注
 friendLoginId
 String
 是
 好友loginId
 friendNote
 String
 是
 好友备注
*/