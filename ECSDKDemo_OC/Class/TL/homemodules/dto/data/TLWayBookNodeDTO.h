//
//  TLWayBookNodeDTO.h
//  TL
//
//  Created by Rainbow on 3/17/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "TLTripTravelDTO.h"
#import "TLImageDTO.h"

@protocol TLWayBookNodeDTO


@end

@interface TLWayBookNodeDTO : TLTripTravelDTO
@property (nonatomic,copy) NSArray<TLImageDTO> *images;
@end


/**
 "createTime":"2015-03-03 00:00:00",
 "images":[
 {          "imageName":"PHOTO_20150102",
 "imageURL":"http://hiphotos.baidu.com/lvpics/pic/item/73ca5910b8217aa4c3ce79a8.jpg"
 }
*/