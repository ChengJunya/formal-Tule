//
//  CCitySelectView.h
//  TL
//
//  Created by Rainbow on 3/7/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCitySelectView : UIView<UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic,strong) UIPickerView *pickerView;
@property (nonatomic,strong) void (^PickerSelectBlock)(id,CCitySelectView*);
@property (nonatomic,strong) void (^PickerSubSelectBlock)(id,CCitySelectView*);
@property (nonatomic,strong) NSString *firstCoponentNameKey;
@property (nonatomic,strong) NSString *subCoponentNameKey;
@property (nonatomic,strong) NSString *thirdCoponentNameKey;
@property (nonatomic,strong) id firstCoponentSelectedItem;
@property (nonatomic,strong) id subCoponentSelectedItem;
@property (nonatomic,strong) id thirdCoponentSelectedItem;
-(void)setPickerArray:(NSArray *)pickerArray;

-(void)setSubPickerArray:(NSArray *)subPickerArray;
-(void)setThirdPickerArray:(NSArray *)thirdPickerArray;
@end
