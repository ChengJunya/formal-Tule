//
//  TLUpdateFormItem.h
//  TL
//
//  Created by Rainbow on 2/26/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TLUpdateFormItem : UIView

@property (nonatomic,strong) id itemData;
@property (nonatomic,assign) CGRect itemFrame;
@property (nonatomic,strong) UIView *rightView;
- (instancetype)initWithFrame:(CGRect)frame itemData:(id)itemData;
- (NSString *)updateValue;

@end
