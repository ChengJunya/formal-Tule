//
//  CDataPickerView.h
//  ContractManager
//
//  Created by Rainbow on 12/19/14.
//  Copyright (c) 2014 BONC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CConditionBasicView.h"
@interface CDataPickerView : CConditionBasicView<UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic,strong) NSArray *pickerDataArray;
@property (nonatomic,strong) UIPickerView *pickerView;
-(instancetype)initWithFrameData:(CGRect)frame itemData:(NSDictionary *)itemData;
@end
