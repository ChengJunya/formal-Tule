//
//  RColorButton.h
//  ContractManager
//
//  Created by Rainbow on 12/27/14.
//  Copyright (c) 2014 BONC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RColorButton : UIButton

-(instancetype)initWithFrameColor:(CGRect)frame normalColor:(UIColor *)normalColor selectedColor:(UIColor *)selectedColor;
@end
