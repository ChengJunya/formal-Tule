//
//  ADPersonCenterDTO.m
//  alijk
//
//  Created by Rainbow on 4/5/15.
//  Copyright (c) 2015 zhongxin. All rights reserved.
//

#import "ADPersonCenterDTO.h"

@implementation ADPersonCenterDTO


- (instancetype)initWithId:(NSString*)dtoId title:(NSString*)title info:(NSString*)info toViewControllers:(NSArray*)toViewControllers icon:(NSString*)icon isRedDotHidden:(BOOL)isRedDotHidden{
    self = [super init];
    if (self) {
        _dtoId = dtoId;
        _title = title;
        _info = info;
        _toViewControllers = toViewControllers;
        _icon = icon;
        _isRedDotHidden = isRedDotHidden;
        _type = @"1";
        _isOn = NO;
    }
    return self;
}

- (instancetype)initWithId:(NSString*)dtoId title:(NSString*)title info:(NSString*)info toViewControllers:(NSArray*)toViewControllers icon:(NSString*)icon isRedDotHidden:(BOOL)isRedDotHidden  type:(NSString*)type isOn:(BOOL)isOn{
    self = [super init];
    if (self) {
        _dtoId = dtoId;
        _title = title;
        _info = info;
        _toViewControllers = toViewControllers;
        _icon = icon;
        _isRedDotHidden = isRedDotHidden;
        _type = type;
        _isOn = isOn;
    }
    return self;
}

@end
