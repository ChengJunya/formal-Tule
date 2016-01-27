//
//  BoncColumnSelectView.h
//  ContractManager
//
//  Created by Rainbow on 12/21/14.
//  Copyright (c) 2014 BONC. All rights reserved.
//

#import <UIKit/UIKit.h>


#define BoncColumnSelectItemTableViewCell_HEIGHT 40.0f

@protocol BoncColumnSelectViewDelegate <NSObject>

-(void)columnSelectionChange:(NSDictionary*)itemData;

@end

@interface BoncColumnSelectView : UIView<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSArray *columnData;
@property (nonatomic,strong) UITableView *columnTableView;
@property (nonatomic,weak) id<BoncColumnSelectViewDelegate> delegate;
-(instancetype)initWithFrame:(CGRect)frame columnData:(NSArray *)columnData;
@end
