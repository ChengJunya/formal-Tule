//
//  AKRedPointCell.h
//  alijk
//
//  Created by zhangyang on 15/2/10.
//  Copyright (c) 2015年 zhongxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADPersonCenterDTO.h"
@interface AKRedPointCell : UITableViewCell

@property (nonatomic,strong) ADPersonCenterDTO *cellDto;

+(CGFloat)cellHeight;


@end
