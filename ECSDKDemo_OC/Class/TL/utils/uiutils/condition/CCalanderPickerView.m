//
//  CCalanderPickerView.m
//  ContractManager
//
//  Created by Rainbow on 12/19/14.
//  Copyright (c) 2014 BONC. All rights reserved.
//

#import "CCalanderPickerView.h"
#import "RUtiles.h"

@interface CCalanderPickerView()


@end

@implementation CCalanderPickerView

-(instancetype)initWithFrameData:(CGRect)frame itemData:(NSDictionary *)itemData{
    self = [super initWithFrame:frame];
    if (self) {
        self.itemData = itemData;
        self.dateFormat = @"yyyy-MM-dd";
        self.selectedTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, self.width, 16.f)];
        self.selectedTimeLabel.font = [UIFont systemFontOfSize:14];
        self.selectedTimeLabel.textColor = [UIColor blackColor];
        self.selectedTimeLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:self.selectedTimeLabel];
        
        
        
        self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0f, 16.0f, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        self.datePicker.datePickerMode = UIDatePickerModeDate;
        [self.datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged ];
        [self addSubview:self.datePicker];
        
        self.currentSelectedItem = [NSDictionary dictionaryWithObjectsAndKeys:[self.itemData valueForKey:@"selectedId"],@"id",[self.itemData valueForKey:@"selectedName"],@"name",[self.itemData valueForKey:@"paremKey"],@"paramKey", nil];
        
        
    }
    return self;
}

-(instancetype)initWithFrameData:(CGRect)frame itemData:(NSDictionary *)itemData dateFormat:(NSString*)dateFormat{
    self = [super initWithFrame:frame];
    if (self) {
        self.itemData = itemData;
        self.dateFormat = dateFormat;
        self.selectedTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, self.width, 16.f)];
        self.selectedTimeLabel.font = [UIFont systemFontOfSize:14];
        self.selectedTimeLabel.textColor = [UIColor blackColor];
        self.selectedTimeLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:self.selectedTimeLabel];
        
        
        
        self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0f, 16.0f, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        self.datePicker.datePickerMode = UIDatePickerModeDate;
        [self.datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged ];
        [self addSubview:self.datePicker];
        
        self.currentSelectedItem = [NSDictionary dictionaryWithObjectsAndKeys:[self.itemData valueForKey:@"selectedId"],@"id",[self.itemData valueForKey:@"selectedName"],@"name",[self.itemData valueForKey:@"paremKey"],@"paramKey", nil];
        
        
    }
    return self;
}
-(void)dateChanged:(id)sender{
    UIDatePicker* control = (UIDatePicker*)sender;
    NSDate* _date = control.date;
    /*添加你自己响应代码*/
    
 
    self.currentSelectedItem = [NSDictionary dictionaryWithObjectsAndKeys:[RUtiles stringFromDateWithFormat:_date format:self.dateFormat],@"id",[RUtiles stringFromDateWithFormat:_date format:self.dateFormat],@"name",[self.itemData valueForKey:@"paremKey"],@"paramKey", nil];
    [self.selectBtn setTitle:[RUtiles stringFromDateWithFormat:_date format:self.dateFormat] forState:UIControlStateNormal];
    self.selectedTimeLabel.text = [RUtiles stringFromDateWithFormat:_date format:self.dateFormat];
}
-(NSDictionary *)getConditionData{
    
    return nil;
}

@end
