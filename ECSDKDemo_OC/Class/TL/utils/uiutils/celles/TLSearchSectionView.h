//
//  TLSearchSectionView.h
//  TL
//
//  Created by Rainbow on 2/20/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TLSearchSectionView : UIView
@property (nonatomic,strong) id sectionData;
@property (nonatomic,assign) CGFloat sectionHeight;
- (instancetype)initWithFrame:(CGRect)frame sectionData:(id)sectionData;
@end
