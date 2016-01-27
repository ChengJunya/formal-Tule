//
//  TLStoreProItem.h
//  TL
//
//  Created by Rainbow on 2/27/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TLStoreProItem : UIButton
@property (nonatomic,strong) id itemData;
- (instancetype)initWithFrame:(CGRect)frame itemData:(id)itemData;
@end
