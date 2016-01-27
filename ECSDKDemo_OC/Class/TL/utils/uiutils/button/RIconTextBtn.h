//
//  RIconTextBtn.h
//  TL
//
//  Created by Rainbow on 2/10/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RIconTextBtn : UIButton
- (instancetype)initWithFrame:(CGRect)frame withImageSize:(CGSize)imageSize;
@property (nonatomic,assign) CGSize imageSize;
@end
