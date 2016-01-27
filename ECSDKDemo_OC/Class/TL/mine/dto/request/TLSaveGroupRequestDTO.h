//
//  TLSaveGroupRequestDTO.h
//  TL
//
//  Created by Rainbow on 5/6/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "BaseDTOModel.h"

@interface TLSaveGroupRequestDTO : RequestDTO
@property (nonatomic,copy) NSString *groupName;
@property (nonatomic,copy) NSString *provinceId;
@property (nonatomic,copy) NSString *cityId;
@property (nonatomic,copy) NSString *groupDesc;
@property (nonatomic,copy) UIImage *groupIcon;
@property (nonatomic,copy) NSString *longtitude;
@property (nonatomic,copy) NSString *latitude;




@end


/*
 groupName
 String
 是
 群组名称
 provinceId
 String
 是
 群组所在省份
 cityId
 String
 是
 群组所在地市
 groupDesc
 String
 是
 群组描述
 groupIcon
 File 
 是 
 群组头像
 
 
 longtitude
 String
 是
 群主所在经度（如果获取不到用户经度信息传-1）
 latitude
 String
 是
 群组所在纬度 （如果获取不到用户纬度信息传-1）

*/