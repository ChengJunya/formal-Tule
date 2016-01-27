//
//  TLCommentDataDTO.h
//  TL
//
//  Created by Rainbow on 3/22/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "JSONModel.h"
#import "TLTripUserDTO.h"


//评论返回数据
@protocol TLCommentDataDTO


@end

@interface TLCommentDataDTO : JSONModel

@property(nonatomic,copy) NSString *commentId;
@property(nonatomic,copy) NSString *commentContent;
@property(nonatomic,copy) NSString *publishTime;
@property(nonatomic,copy) TLTripUserDTO *user;

@end


/**
 {
 
 "commentId":101,    --评论编号
 "commentContent":"1"                --评论内容
 "publishTime":"2014-1-12 00:00:00",         --评论发表时间
 "user":{
 "userName":"途乐Man" ,
 "userIndex":101,
 "userIcon":" http://qlogo3.store.qq.com/qzone/641384094/641384094/100?1356670743 "
 }       --用户信息
 
 }
 
 */