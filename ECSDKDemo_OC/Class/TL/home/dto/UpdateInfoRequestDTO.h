//
//  UpdateInfoRequestDTO.h
//  alijk
//
//  Created by easy on 14/7/28.
//  Copyright (c) 2014年 zhongxin. All rights reserved.
//

#import "BaseDTOModel.h"

@interface UpdateInfoRequestDTO : RequestDTO

@property (nonatomic, copy) NSString* platForm;     // andriod  ios
@property (nonatomic, copy) NSString* version;      // 当前版本信息
@end
