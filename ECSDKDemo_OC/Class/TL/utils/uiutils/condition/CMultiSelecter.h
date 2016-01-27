//
//  CMultiSelecter.h
//  TL
//
//  Created by Rainbow on 3/31/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMultiSelecter : UIView
@property (nonatomic,copy) void (^OkBlock)(NSDictionary *data);
-(void)setSelectedDate:(NSDate*)date;
-(void)showContentView;
- (instancetype)initWithFrame:(CGRect)frame itemData:(id)itemData;
@end
