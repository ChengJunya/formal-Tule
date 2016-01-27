//
//  TLImageDTO.h
//  TL
//
//  Created by Rainbow on 3/17/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "JSONModel.h"
//图片信息
@protocol TLImageDTO

@end

@interface TLImageDTO : JSONModel
@property (nonatomic,copy) NSString *imageName;
@property (nonatomic,copy) NSString *imageUrl;
@end


/*
 "images":[
 {"imageName":"PHOTO_20150102",  "imageUrl":" http://hiphotos.baidu.com/lvpics/pic/item/73ca5910b8217aa4c3ce79a8.jpg"}
 ]
*/