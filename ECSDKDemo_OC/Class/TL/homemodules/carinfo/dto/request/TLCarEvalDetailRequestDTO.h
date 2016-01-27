//
//  TLCarEvalDetailRequestDTO.h
//  TL
//
//  Created by Rainbow on 3/29/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "BaseDTOModel.h"

@interface TLCarEvalDetailRequestDTO : RequestDTO
@property (nonatomic,copy) NSString *carEvaId;
@property (nonatomic,copy) NSString *dataType;
@end


/*

 carEvaId
 String
 是
 车型编号
*/