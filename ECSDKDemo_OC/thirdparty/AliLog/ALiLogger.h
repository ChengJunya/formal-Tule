//
//  ALiLogger.h
//  NSLogTester
//
//  Created by Rainbow on 4/24/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDLog.h"

@interface ALiLogger : DDAbstractLogger<DDLogger>
+ (instancetype)sharedInstance;
@property (nonatomic,strong) UIView *logView;
@property (nonatomic,strong) UIView *logParentView;
@property (nonatomic,strong) NSArray *colors;

-(void)showLogView;
@end
