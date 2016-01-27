//
//  CConditionView.h
//  ContractManager
//
//  Created by Rainbow on 12/19/14.
//  Copyright (c) 2014 BONC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CConditionBasicView.h"

@interface CConditionView : UIView
@property (nonatomic,strong) NSArray *conditionsDataArray;
@property (nonatomic,strong) NSMutableArray *conditionArray;
@property (nonatomic,strong) CConditionBasicView *currentView;
@property (nonatomic,assign) BOOL isContentHidden;
@property (nonatomic,strong) NSMutableArray *btnArray;
@property (nonatomic,strong) NSString *dateFormat;


@property (nonatomic,copy) void (^ConditionConfirmBlock)(NSArray* data);

-(instancetype)initWithFrame:(CGRect)frame conditionsDataArray:(NSArray*)conditionsDataArray;
-(void)showHideContentView;
@end
