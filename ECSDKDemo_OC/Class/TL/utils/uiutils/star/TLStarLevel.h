//
//  TLStarLevel.h
//  TL
//
//  Created by Rainbow on 2/19/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TLStarLevel : UIView
@property (nonatomic,assign)NSUInteger level;
@property (nonatomic,assign) NSUInteger currentLevel;
@property (nonatomic,assign)BOOL isStarSelect;
- (instancetype)initWithFrame:(CGRect)frame level:(NSUInteger)level currentLevel:(NSUInteger)currentLevel;
@end
