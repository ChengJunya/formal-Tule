//
//  TLComfirmAddFrinedRequestDTO.h
//  TL
//
//  Created by Rainbow on 4/27/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "BaseDTOModel.h"

@interface TLComfirmAddFrinedRequestDTO : RequestDTO
@property (nonatomic,copy) NSString *applyId;
@property (nonatomic,copy) NSString *decision;



@end


/*
 applyId
 String
 是
 好友申请编号
 decision
 String
 是
 1：同意添加好友，2：不同意添加好友
*/