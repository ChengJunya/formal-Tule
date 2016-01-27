//
//  TLRemoveFriendRequest.h
//  TL
//
//  Created by YONGFU on 7/7/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "BaseDTOModel.h"

@interface TLRemoveFriendRequest : RequestDTO
@property (nonatomic,copy) NSString *friendLoginId;
@end
