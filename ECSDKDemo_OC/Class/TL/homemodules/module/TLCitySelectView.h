//
//  TLCitySelectView.h
//  TL
//
//  Created by Rainbow on 2/10/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLCityDTO.h"
@interface TLCitySelectView : UIView
@property (nonatomic,copy) void (^SelectedCityBlock)(TLCityDTO*);
@end
