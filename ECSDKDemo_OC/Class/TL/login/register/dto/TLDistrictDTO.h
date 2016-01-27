//
//  TLDistrictDTO.h
//  TL
//
//  Created by Rainbow on 3/8/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "JSONModel.h"
@protocol TLDistrictDTO

@end
@interface TLDistrictDTO : JSONModel
@property (nonatomic,copy) NSString *districtId;
@property (nonatomic,copy) NSString *districtName;
@property (nonatomic,copy) NSString *cityId;
@end
