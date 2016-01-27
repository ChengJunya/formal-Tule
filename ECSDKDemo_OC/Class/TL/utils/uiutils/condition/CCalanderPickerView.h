//
//  CCalanderPickerView.h
//  ContractManager
//
//  Created by Rainbow on 12/19/14.
//  Copyright (c) 2014 BONC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CConditionBasicView.h"
@interface CCalanderPickerView : CConditionBasicView
@property (nonatomic,strong) NSArray *pickerDataArray;
@property (nonatomic,strong) UIDatePicker *datePicker;
@property (nonatomic,strong) UILabel *selectedTimeLabel;
@property (nonatomic,strong) NSString *dateFormat;
-(instancetype)initWithFrameData:(CGRect)frame itemData:(NSDictionary *)itemData dateFormat:(NSString*)dateFormat;
//-(instancetype)initWithFrameData:(CGRect)frame itemData:(NSDictionary *)itemData;
@end
