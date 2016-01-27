//
//  TLPersonCountDTO.h
//  TL
//
//  Created by Rainbow on 3/20/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "JSONModel.h"

@protocol TLPersonCountDTO


@end

@interface TLPersonCountDTO : JSONModel

@property (nonatomic,copy) NSString *codeValue;//---值
@property (nonatomic,copy) NSString *codeName;//---名称
@property (nonatomic,copy) NSString *codeType;//---名称
@property (nonatomic,copy) NSString *codeIndex;//---名称


@end
