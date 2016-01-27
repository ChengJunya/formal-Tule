//
//  TLMyFriendsListResultDTO.h
//  TL
//
//  Created by Rainbow on 4/27/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "JSONModel.h"
#import "TLSimpleUserDTO.h"
@interface TLMyFriendsListResultDTO : JSONModel
@property (nonatomic,copy) NSArray<TLSimpleUserDTO> *data;
@end
