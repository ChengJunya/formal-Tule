//
//  TLNewsDataDTO.h
//  TL
//
//  Created by Rainbow on 4/27/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "JSONModel.h"

@protocol TLNewsDataDTO


@end

@interface TLNewsDataDTO : JSONModel
@property (nonatomic,copy) NSString *newsId;
@property (nonatomic,copy) NSString *newsTitle;
@property (nonatomic,copy) NSString *newsDesc;
@property (nonatomic,copy) NSString *newsDate;
@property (nonatomic,copy) NSString *newsPic;
@property (nonatomic,copy) NSString *url;
@end

/*

 "newsId":1                     --新闻编号
 "newsTitle":""                --新闻标题
 "newsDesc":""                --新闻简介
 "newsDate":""                --发布日期
 "newsPic":""                   --新闻缩略图
 "url":"action/viewNews?newsId=1"
 --新闻详情URL地址
 }
*/