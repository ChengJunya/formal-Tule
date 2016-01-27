//
//  CDateChooserView.h
//  BIBuilderApp
//
//  Created by Rainbow on 2/2/15.
//  Copyright (c) 2015 Bonc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CDateChooserView : UIView
@property (nonatomic,copy) void (^OkBlock)(NSDictionary *data);
@property (nonatomic,copy) void (^CancelBlock)(NSDictionary *data);
@property (nonatomic,strong) NSString* dateFormat;
@property(nonatomic,assign) NSInteger dateChoserType;
-(void)setSelectedDate:(NSDate*)date;
-(void)showContentView;
-(void)showHideContentView;
- (instancetype)initWithFrame:(CGRect)frame dateFormat:(NSString*)format dateChoserType:(NSInteger)dateChoserType;
@end
