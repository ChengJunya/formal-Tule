//
//  TLListGroupRequestDTO.h
//  TL
//
//  Created by Rainbow on 5/3/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "TLListOrgRequestDTO.h"

@interface TLListGroupRequestDTO : TLListOrgRequestDTO
@property (nonatomic,copy) NSString *groupId;
@end


/*

 type
 String
 是
 1: 我加入的群组
 2:我创建的群组
 3:群组查询
 searchText
 String
 否
*/