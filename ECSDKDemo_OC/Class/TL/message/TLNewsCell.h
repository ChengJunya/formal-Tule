//
//  TLNewsCell.h
//  TL
//
//  Created by Rainbow on 5/11/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLNewsDataDTO.h"
@interface TLNewsCell : UITableViewCell
@property(nonatomic,strong) TLNewsDataDTO *cellData;
-(void)setCellDto:(TLNewsDataDTO*)cellData;
+(CGFloat)cellHeight;
@end
