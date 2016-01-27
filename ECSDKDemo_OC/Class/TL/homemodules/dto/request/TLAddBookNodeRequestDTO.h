//
//  TLAddBookNodeRequestDTO.h
//  TL
//
//  Created by Rainbow on 3/17/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "BaseDTOModel.h"

@interface TLAddBookNodeRequestDTO : RequestDTO

@property(nonatomic,copy) NSString *travelId;//路数ID
@property(nonatomic,copy) NSString *cityId;
@property(nonatomic,copy) NSString *content;
@property(nonatomic,copy) NSString *isTop; //0 1
@property(nonatomic,copy) NSArray *userImage;
@property(nonatomic,copy) NSString *operateType;//1-add 2-modify
@property(nonatomic,copy) NSString *objId;//




@end
