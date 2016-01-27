//
//  TLKeyValueItemView.h
//  TL
//
//  Created by Rainbow on 2/19/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TLKeyValueItemView : UIView
@property (nonatomic,strong) NSArray *itemData;
- (instancetype)initWithFrame:(CGRect)frame itemData:(NSArray *)itemData;
@end
