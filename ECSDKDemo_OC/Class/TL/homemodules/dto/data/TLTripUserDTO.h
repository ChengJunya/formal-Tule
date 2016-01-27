//
//  TLTripUserDTO.h
//  TL
//
//  Created by Rainbow on 3/17/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "JSONModel.h"

//简单用户信息
@protocol TLTripUserDTO


@end

@interface TLTripUserDTO : JSONModel
@property (nonatomic,copy) NSString *userName;
@property (nonatomic,copy) NSString<Optional> *userIndex;
@property (nonatomic,copy) NSString *userIcon;
@property (nonatomic,copy) NSString<Optional> *visitTime;
@property (nonatomic,copy) NSString<Optional> *loginId;
@property (nonatomic,copy) NSString<Optional> *voipAccount;

@end


/*
 "user":{
 "userName":"途乐Man" ,
 "userIndex":101,
 "userIcon":" http://qlogo3.store.qq.com/qzone/641384094/641384094/100?1356670743 "
 }       --用户信息

*/