//
//  TLWayNodeView.h
//  TL
//
//  Created by Rainbow on 2/15/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TLWayNodeView : UIView
@property (nonatomic,strong) id itemData;
@property (nonatomic,copy) void (^ItemSelectBlock)(id itemData);
- (instancetype)initWithFrame:(CGRect)frame itemData:(id)itemData;
@end
