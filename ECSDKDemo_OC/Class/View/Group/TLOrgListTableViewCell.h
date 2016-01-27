//
//  TLOrgListTableViewCell.h
//  TL
//
//  Created by Rainbow on 5/3/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLOrgDataDTO.h"
@interface TLOrgListTableViewCell : UITableViewCell
@property(nonatomic,strong) TLOrgDataDTO *cellData;
-(void)setCellDto:(TLOrgDataDTO*)cellData;
+(CGFloat)cellHeight;
@end
