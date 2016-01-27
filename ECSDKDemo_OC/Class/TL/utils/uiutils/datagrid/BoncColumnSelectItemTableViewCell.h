//
//  BoncColumnSelectItemTableViewCell.h
//  ContractManager
//
//  Created by Rainbow on 12/21/14.
//  Copyright (c) 2014 BONC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BoncSwitch.h"
@interface BoncColumnSelectItemTableViewCell : UITableViewCell
@property (nonatomic,strong) NSDictionary *rowData;
@property (nonatomic,strong) BoncSwitch *isShowSwitch;
@property (nonatomic,assign) int rowIndex;
- (void)initContent;
@end
