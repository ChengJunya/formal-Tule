//
//  TLMineStoreListItem.h
//  TL
//
//  Created by Rainbow on 2/27/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TLMineStoreListItem : UIButton

@property (nonatomic,strong) id itemData;
@property (nonatomic,assign) BOOL isShowAction;
- (instancetype)initWithFrame:(CGRect)frame itemData:(id)itemData;
- (instancetype)initWithFrame:(CGRect)frame itemData:(id)itemData isShowAction:(BOOL)isShowAction;
- (void)setTitle:(NSString*)title;
@end
