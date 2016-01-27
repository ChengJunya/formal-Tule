//
//  TLSaveCarServiceResponse.h
//  TL
//
//  Created by Rainbow on 3/30/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "BaseDTOModel.h"
#import "TLSaveCarServiceResult.h"
@interface TLSaveCarServiceResponse : ResponseDTO
@property (nonatomic,copy)TLSaveCarServiceResult *result;
@end
