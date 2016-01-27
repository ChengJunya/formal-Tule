//
//  TLCarServiceDetailRequest.h
//  TL
//
//  Created by Rainbow on 3/30/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "BaseDTOModel.h"

@interface TLCarServiceDetailRequest : RequestDTO
@property (nonatomic,copy) NSString *serviceId;
@property (nonatomic,copy) NSString *dataType;
@end
