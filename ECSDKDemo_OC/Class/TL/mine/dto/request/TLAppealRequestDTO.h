//
//  TLAppealRequestDTO.h
//  TL
//
//  Created by Rainbow on 4/17/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "BaseDTOModel.h"

@interface TLAppealRequestDTO : RequestDTO
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *phone;
@property (nonatomic,copy) NSString *email;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSArray *images;
@end


/*
 title
 String
 是
 申诉题目
 phone
 String
 是
 申诉人电话
 email
 String
 是
 申诉人邮箱
 content
 String
 是
 申诉内容
 images
 文件数组
 否
 申诉截图


*/