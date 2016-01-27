//
//  CPickerRowView.h
//  TL
//
//  Created by Rainbow on 3/31/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPickerRowView : UIView
@property(nonatomic,strong) id itemData;
@property (nonatomic,assign) BOOL isSelected;
@property (nonatomic,assign) BOOL isMulty;
- (instancetype)initWithFrame:(CGRect)frame itemData:(id)itemData;
-(void)addViews;
@end
