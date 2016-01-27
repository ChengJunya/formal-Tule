//
//  BasicCellViewTableViewCell.h
//  TL
//
//  Created by Rainbow on 2/7/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RUtiles.h"
@interface BasicCellViewTableViewCell : UITableViewCell
@property (nonatomic,assign) CGFloat cellHeight;
@property (nonatomic,strong) id cellData;
@property (nonatomic,strong) UIView *cellContentView;
- (void)initContent;
@end
