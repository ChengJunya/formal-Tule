//
//  TLHiddenSetting.h
//  TL
//
//  Created by YONGFU on 6/27/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "BaseDTOModel.h"

@interface TLHiddenSetting : RequestDTO
@property (nonatomic,copy) NSString *showLocation;
@end


/*

 showLocation
 String
 是
 0:对外不显示位置，1:对外显示位置
*/