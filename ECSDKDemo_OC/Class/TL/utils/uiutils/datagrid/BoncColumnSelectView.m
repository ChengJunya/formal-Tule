//
//  BoncColumnSelectView.m
//  ContractManager
//
//  Created by Rainbow on 12/21/14.
//  Copyright (c) 2014 BONC. All rights reserved.
//

#import "BoncColumnSelectView.h"
#import "BoncColumnSelectItemTableViewCell.h"
@implementation BoncColumnSelectView
@synthesize delegate=_delegate;
-(instancetype)initWithFrame:(CGRect)frame columnData:(NSArray *)columnData{
    self = [super initWithFrame:frame];
    if (self) {

        [self.layer setBackgroundColor:[UIColor whiteColor].CGColor];
        [self.layer setCornerRadius:10.0f];
        
        self.columnData = columnData;
        self.columnTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        [self addSubview:self.columnTableView];
        self.columnTableView.delegate = self;
        self.columnTableView.dataSource = self;
        [self.columnTableView reloadData];
        self.columnTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.columnTableView.layer setBackgroundColor:[UIColor colorWithRed:0.0/255.0 green:159.0/255.0 blue:248.0/255.0 alpha:0.5].CGColor];
        [self.columnTableView.layer setCornerRadius:10.0f];

    }
    return self;
}


-(void)switchAction:(BoncSwitch*)uiSwitch{
    
    NSDictionary *rowData = [self.columnData objectAtIndex:uiSwitch.rowIndex];
    
    
    
    
    if (uiSwitch.on) {
        [rowData setValue:@"1" forKey:@"ISSHOW"];
    }else{
        [rowData setValue:@"0" forKey:@"ISSHOW"];
    }
    
    if([self.delegate respondsToSelector:@selector(columnSelectionChange:)] == YES )
    {
        
        [self.delegate columnSelectionChange:rowData];
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"BoncColumnSelectItemTableViewCell";
    BoncColumnSelectItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[BoncColumnSelectItemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    [cell setRowIndex:indexPath.row];
    [cell setRowData:[self.columnData objectAtIndex:indexPath.row]];
    [cell initContent];
    [cell.isShowSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    
    return cell;
    
    
    
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.columnData count];
}




-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1 ;
}





-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return BoncColumnSelectItemTableViewCell_HEIGHT;
}





@end
