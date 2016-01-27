//
//  UpdatePasswordRequestDTO.h
//  alijk
//
//  Created by easy on 14/7/28.
//  Copyright (c) 2014年 zhongxin. All rights reserved.
//

#import "BaseDTOModel.h"

@interface UpdatePasswordRequestDTO : RequestDTO

@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *passwordNew;

@end
