//
//  TLCityDTO.h
//  TL
//
//  Created by Rainbow on 3/8/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "JSONModel.h"
@protocol TLCityDTO

@end


@interface TLCityDTO : JSONModel
@property (nonatomic,strong) NSString *cityId;
@property (nonatomic,strong) NSString *cityName;
@property (nonatomic,strong) NSString<Optional> *zipCode;
@property (nonatomic,strong) NSString *provinceId;


@end
