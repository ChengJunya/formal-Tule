//
//  TLCarServiceDetailView.h
//  TL
//
//  Created by Rainbow on 2/19/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "TLDetailView.h"

@interface TLCarServiceDetailView : TLDetailView
@property (nonatomic,copy) void (^StarBlock)(id itemData);
- (instancetype)initWithFrame:(CGRect)frame viewData:(id)viewData detailData:(id)detailData;
@end
