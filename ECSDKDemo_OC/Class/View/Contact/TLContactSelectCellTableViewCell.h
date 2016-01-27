//
//  TLContactSelectCellTableViewCell.h
//  TL
//
//  Created by YONGFU on 5/19/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLSimpleUserDTO.h"
@interface TLContactSelectCellTableViewCell : UITableViewCell
@property(nonatomic,strong) TLSimpleUserDTO *cellData;
-(void)setCellDto:(TLSimpleUserDTO*)cellData;
+(CGFloat)cellHeight;
@end
