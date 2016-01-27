//
//  TLGridCellView.h
//  TL
//
//  Created by YONGFU on 5/31/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TLGridCellView : UIView
@property (nonatomic,strong) NSArray *cellDataArray;
- (instancetype)initWithFrame:(CGRect)frame items:(NSArray *)items;
@end
