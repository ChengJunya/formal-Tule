//
//  TLProvinceDTO.h
//  TL
//
//  Created by Rainbow on 3/8/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "JSONModel.h"
@protocol TLProvinceDTO

@end

@interface TLProvinceDTO : JSONModel
@property (nonatomic,copy) NSString *provinceId;
@property (nonatomic,copy) NSString *provinceName;

@end
