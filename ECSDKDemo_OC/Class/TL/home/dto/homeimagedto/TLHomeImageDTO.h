//
//  TLHomeImageDTO.h
//  TL
//
//  Created by Rainbow on 3/8/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "JSONModel.h"

@protocol TLHomeImageDTO


@end

@interface TLHomeImageDTO : JSONModel
@property (nonatomic,copy) NSString *imageUrl;
@property (nonatomic,copy) NSString<Optional> *activityId;
@property (nonatomic,copy) NSString<Optional> *objType;
@property (nonatomic,copy) NSString<Optional> *objId;
@property (nonatomic,copy) NSString<Optional> *type;

@end
