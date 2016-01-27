//
//  TLOperOrgRequestDTO.h
//  TL
//
//  Created by Rainbow on 5/3/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "BaseDTOModel.h"

@interface TLOperOrgRequestDTO : RequestDTO
@property (nonatomic,copy) NSString *organizationId;
@property (nonatomic,copy) NSString *type;
@end


/*
 organizationId
 String
 是
 组织编号
 type
 String
 是
 1：加入组织
 2：退出组织

*/