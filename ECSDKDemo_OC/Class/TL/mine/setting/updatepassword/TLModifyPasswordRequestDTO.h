//
//  TLModifyPasswordRequestDTO.h
//  TL
//
//  Created by YONGFU on 5/22/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "BaseDTOModel.h"

@interface TLModifyPasswordRequestDTO : RequestDTO
@property (nonatomic,copy) NSString *userIndex;
@property (nonatomic,copy) NSString *oldPassword;
@property (nonatomic,copy) NSString *password;

@end


/**

 userIndex
 String
 是
 用户编号
 newPwd
 String
 是
 新密码

*/