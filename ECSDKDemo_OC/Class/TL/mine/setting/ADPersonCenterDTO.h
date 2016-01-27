//
//  ADPersonCenterDTO.h
//  alijk
//
//  Created by Rainbow on 4/5/15.
//  Copyright (c) 2015 zhongxin. All rights reserved.
//

#import "JSONModel.h"

@interface ADPersonCenterDTO : JSONModel
@property (nonatomic,strong) NSString *dtoId;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *info;
@property (nonatomic,strong) NSArray *toViewControllers;
@property (nonatomic,strong) NSString *icon;
@property (nonatomic,strong) NSString *type;
@property (nonatomic,assign) BOOL isOn;

@property (nonatomic,assign) BOOL isRedDotHidden;


- (instancetype)initWithId:(NSString*)dtoId title:(NSString*)title info:(NSString*)info toViewControllers:(NSArray*)toViewControllers icon:(NSString*)icon isRedDotHidden:(BOOL)isRedDotHidden;
- (instancetype)initWithId:(NSString*)dtoId title:(NSString*)title info:(NSString*)info toViewControllers:(NSArray*)toViewControllers icon:(NSString*)icon isRedDotHidden:(BOOL)isRedDotHidden type:(NSString*)type isOn:(BOOL)isOn;
@end
