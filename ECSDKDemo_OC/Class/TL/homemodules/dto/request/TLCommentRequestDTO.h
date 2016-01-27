//
//  TLCommentRequestDTO.h
//  TL
//
//  Created by Rainbow on 3/17/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "BaseDTOModel.h"

@interface TLCommentRequestDTO : RequestDTO

@property (nonatomic,copy) NSString *comment;//评论内容
@property (nonatomic,copy) NSString *loginId;//用户编号
@property (nonatomic,copy) NSString *type;//1:攻略 2:路书 3:游记
@property (nonatomic,copy) NSString *objId;//travel ID


@end
