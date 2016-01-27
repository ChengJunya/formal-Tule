//
//  CConditionBasicView.h
//  ContractManager
//
//  Created by Rainbow on 12/19/14.
//  Copyright (c) 2014 BONC. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface CConditionBasicView : UIView
@property (nonatomic,strong) UIButton *selectBtn;
@property (nonatomic,strong) NSDictionary *itemData;
@property (nonatomic,strong) NSDictionary *selectedItem;
@property (nonatomic,strong) NSDictionary *currentSelectedItem;
-(NSDictionary *)getConditionData;
-(void)cancel;
-(void)ok;

@end
