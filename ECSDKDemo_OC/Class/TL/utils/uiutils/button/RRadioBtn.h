//
//  RRadioBtn.h
//  BIBuilderApp
//
//  Created by Rainbow on 1/24/15.
//  Copyright (c) 2015 Bonc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RRadioBtn : UIButton
@property (nonatomic,strong) NSDictionary *itemData;
- (instancetype)initWithFrame:(CGRect)frame itemData:(NSDictionary*)itemData;
@end
