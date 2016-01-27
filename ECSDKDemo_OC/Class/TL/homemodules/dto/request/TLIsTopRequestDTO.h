//
//  TLIsTopRequestDTO.h
//  TL
//
//  Created by Rainbow on 3/20/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "BaseDTOModel.h"

@interface TLIsTopRequestDTO : RequestDTO

@property (nonatomic,copy) NSString *objId;//游记，攻略，路书，活动编码
@property (nonatomic,copy) NSString *type;//1:攻略 2:路书 3:游记 4:活动
@end
