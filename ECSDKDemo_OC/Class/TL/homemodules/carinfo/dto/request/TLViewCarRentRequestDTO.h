//
//  TLViewCarRentRequestDTO.h
//  TL
//
//  Created by Rainbow on 3/29/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "BaseDTOModel.h"

@interface TLViewCarRentRequestDTO : RequestDTO
@property (nonatomic,copy) NSString *rentId;
@property (nonatomic,copy) NSString *dataType;
@end


/*
 rentId
 String
 是
 租赁编号
*/