//
//  TLSaveCollectRequestDTO.h
//  TL
//
//  Created by Rainbow on 3/22/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "BaseDTOModel.h"

@interface TLSaveCollectRequestDTO : RequestDTO
@property(nonatomic,copy) NSString *type;
@property(nonatomic,copy) NSString *objId;
@end


/*

 type
 String
 是
 1：攻略，2：路书，3：游记，4：活动
 objId
 String
 是
 游记，攻略，路书，活动编号
*/