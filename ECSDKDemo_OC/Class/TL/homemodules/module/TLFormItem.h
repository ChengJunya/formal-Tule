//
//  TLFormItem.h
//  TL
//
//  Created by Rainbow on 2/16/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TLFormItem : UIView
@property (nonatomic,strong) id itemData;
@property (nonatomic,assign) CGRect itemFrame;
@property (nonatomic,strong) NSString *nameStr;
@property (nonatomic,strong) NSString *valueStr;
- (instancetype)initWithFrame:(CGRect)frame itemData:(id)itemData;

@end
