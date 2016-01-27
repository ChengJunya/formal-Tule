//
//  TLUserEditRequestDTO.h
//  TL
//
//  Created by Rainbow on 4/8/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "BaseDTOModel.h"

@interface TLUserEditRequestDTO : RequestDTO
@property (nonatomic,copy) NSString *userName;
@property (nonatomic,copy) NSString *gender;
@property (nonatomic,copy) NSString *birthday;
@property (nonatomic,copy) NSString *profession;
@property (nonatomic,copy) NSString *hobby;
@property (nonatomic,copy) NSString *signature;
@property (nonatomic,copy) NSString *school;
@property (nonatomic,copy) NSString *job;
@property (nonatomic,copy) NSArray *userImg;
@property (nonatomic,copy) UIImage *userIcon;
@property (nonatomic,copy) NSString *loginId;
@property (nonatomic,copy) NSString *cityId;

@end


/*
 userName
 String
 是
 昵称
 gender
 String
 是
 1：男，0：女
 ( 从码表里面取值：gender)
 birthday
 String
 否
 出生日期(yyyy-MM-dd)
 profession
 String
 否
 职业( 从代码表中获取：profession)
 hobby
 String
 否
 兴趣爱好，如果有多个兴趣爱好，以英文逗号进行分隔
 signature
 String
 否
 个人签名
 school
 String
 否
 毕业院校
 job
 String
 否
 工作单位
 userImg
 文件数组
 否
 图片相册
 userIcon
 文件
 否
 个人头像

*/