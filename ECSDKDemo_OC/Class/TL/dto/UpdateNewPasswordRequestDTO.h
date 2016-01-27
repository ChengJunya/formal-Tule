//
//  UpdateNewPasswordRequestDTO.h
//  alijk
//
//  Created by lipeng on 14/12/25.
//  Copyright (c) 2014年 zhongxin. All rights reserved.
//

#import "BaseDTOModel.h"

@interface UpdateNewPasswordRequestDTO : RequestDTO

@property (nonatomic, copy) NSString *oldPassWord;
@property (nonatomic, copy) NSString *nPassWord;

@end
