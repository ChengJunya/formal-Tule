//
//  TLGroupListTableViewCell.h
//  TL
//
//  Created by Rainbow on 5/6/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLGroupDataDTO.h"
@interface TLGroupListTableViewCell : UITableViewCell
@property(nonatomic,strong) TLGroupDataDTO *cellData;
-(void)setCellDto:(TLGroupDataDTO*)cellData;
+(CGFloat)cellHeight;
@end
