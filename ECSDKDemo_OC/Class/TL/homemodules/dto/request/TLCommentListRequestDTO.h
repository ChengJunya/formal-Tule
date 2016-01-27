//
//  TLCommentListRequestDTO.h
//  TL
//
//  Created by Rainbow on 3/17/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "BaseDTOModel.h"

@interface TLCommentListRequestDTO : RequestDTO

@property (nonatomic,copy) NSString *pageSize;
@property (nonatomic,copy) NSString *currentPage;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *objId;//1-攻略 2-路数 3-游记 活动编号


@end
