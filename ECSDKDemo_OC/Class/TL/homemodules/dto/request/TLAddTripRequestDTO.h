//
//  TLAddTripRequestDTO.h
//  TL
//
//  Created by Rainbow on 3/17/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "BaseDTOModel.h"

@interface TLAddTripRequestDTO : RequestDTO

@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *cityId;
@property(nonatomic,copy) NSString *content;
@property(nonatomic,copy) NSString *isTop; //0 1
@property(nonatomic,copy) NSArray *userImage;
@property(nonatomic,copy) NSString *type;//1 2 3
@property(nonatomic,copy) NSString *operateType;//1-add 2-modify
@property(nonatomic,copy) NSString *objId;//

@end


/**

 title
 String
 是
 标题
 cityId
 String
 否	攻略，游记所属地/区
 注：当type为2时该字段不用填
 content
 String
 是
 正文或路书主题
 
 isTop
 String
 否
 0:不置顶
 1:置顶
 注：当type为2时该字段不用填
 userImage
 图片文件数组
 否
 用户上传的图片，可以为多张
 注：（路书主题录入时没有图片上传，该字段为空）
 type
 String
 是
 1:攻略
 2:路书
 3:游记
 
 返回参数
 参数名称
 参数类型(String,json Object)
 是否必填（是，否）
 备注
 resultType
 String
 是
 取值：1（操作成功），0（操作失败）
 resultCode
 String
 是
 返回结果码(参考文档最开始部分的结果吗)，100000为成功，其余都为失败
 resultDesc
 String
 是
 返回的描述
 result
 Json Object
 否 
 注：当resultType为1时才会有值 
 {
 
 }
*/