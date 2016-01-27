//
//  TLListCarServiceResponse.h
//  TL
//
//  Created by Rainbow on 3/30/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "BaseDTOModel.h"
#import "TLListCarServiceResult.h"
@interface TLListCarServiceResponse : ResponseDTO
@property (nonatomic,copy)TLListCarServiceResult *result;
@end
