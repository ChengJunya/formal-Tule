//
//  TLStoreDetailView.h
//  TL
//
//  Created by Rainbow on 2/20/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "TLDetailView.h"

@interface TLStoreDetailView : TLDetailView
- (instancetype)initWithFrame:(CGRect)frame viewData:(id)viewData detailData:(id)detailData;
@property (nonatomic,copy) void (^StarBlock)(id itemData);
@end