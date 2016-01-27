//
//  TLListCarServiceResult.h
//  TL
//
//  Created by Rainbow on 3/30/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "JSONModel.h"
#import "TLCarServiceDTO.h"
@interface TLListCarServiceResult : JSONModel
@property (nonatomic,copy) NSArray<TLCarServiceDTO> *data;
@end
