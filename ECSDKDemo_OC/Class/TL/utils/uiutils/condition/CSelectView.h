//
//  CSelectView.h
//  TL
//
//  Created by Rainbow on 2/17/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSelectView : UIView
@property (nonatomic,strong) id itemData;
@property (nonatomic,copy) void (^OkBlock)(NSDictionary *data);
-(void)setSelectedData:(id)data;
-(void)showContentView;
- (instancetype)initWithFrame:(CGRect)frame itemData:(id)itemData;
@end
