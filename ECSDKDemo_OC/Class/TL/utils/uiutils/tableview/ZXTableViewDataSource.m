//
//  ZXTableViewDataSource.m
//  alijk
//
//  Created by Rainbow on 3/5/15.
//  Copyright (c) 2015 zhongxin. All rights reserved.
//

#import "ZXTableViewDataSource.h"

@implementation ZXTableViewDataSource
@synthesize sections=_sections,gridData=_gridData;
-(instancetype)initWithTableView:(UITableView*)tableView itemData:(NSDictionary*)itemData{
    self = [super init];
    if (self) {
        
        //获取资源初始化数据
        self.tableView = tableView;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        
        
        self.canEditRow = YES;
        self.itemData = itemData;
        
        NSArray *gridDataArray = [self.itemData valueForKey:@"GRID_DATA"];
        self.gridData = [NSMutableArray arrayWithArray: gridDataArray];
        
        self.sections = [self.itemData valueForKey:@"SECTION_DATA"];
        
        
    }
    return self;
}

-(void)setGridData:(NSMutableArray *)gridData{
    _gridData = gridData;
}



-(instancetype)init{
    self = [super init];
    if (self) {
        
        
    }
    return self;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id sectionData = [self.sections objectAtIndex:indexPath.section];
    id cellData = [[self.gridData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    UITableViewCell *defaultCell;
    
    if (self.CellBlock) {
        UITableViewCell *cell =  self.CellBlock(cellData,sectionData,tableView);
        return cell;
    }else{
        NSString *CellIdentifier = @"Default_cell_id";
        defaultCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (defaultCell == nil) {
            defaultCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        defaultCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    return defaultCell;
    
    
    
}




/*
 -(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
 NSDictionary *sectionItem = [self.sections objectAtIndex:section];
 return [sectionItem objectForKey:@"column1"];
 }
 */

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arrayOfSection = [self.gridData objectAtIndex:section];
    return [arrayOfSection count];
}

/*
 -(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
 NSDictionary *sectionItem = [self.sections objectAtIndex:section];
 TableCellHaderView *header = [[TableCellHaderView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.tableView.frame.size.width, 30.0f)];
 [header setCoulumn1Label:[sectionItem valueForKey:@"column1"]];
 [header setCoulumn2Label:[sectionItem valueForKey:@"column2"]];
 return header;
 
 }
 */


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.sections count] ;
}



-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    UIView *header;
    
    
    if (self.HeaderBlock) {
        NSDictionary *sectionData = [self.sections objectAtIndex:section];
        header = self.HeaderBlock(sectionData,tableView);
        return header.frame.size.height;
    }else{
        return 0;
    }
    
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.CellHeightBlock) {
        return self.CellHeightBlock();
    }else{
        return 88.f;
    }
    
    /*
    NSLog(@"heightForRowAtIndexPath");
    CGFloat cellHeight = 0.f;
    id sectionData = [self.sections objectAtIndex:indexPath.section];
    id cellData = [[self.gridData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];

    
    UITableViewCell *defaultCell;
    
    if (self.CellBlock) {
        UITableViewCell *cell =  self.CellBlock(cellData,sectionData,tableView);// [self createTLLeftMenuCell:CellIdentifier tableView:tableView];
        
        cellHeight = cell.frame.size.height;
        //cell = nil;

    }else{
        NSString *CellIdentifier = @"Default_cell_id";
        defaultCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (defaultCell == nil) {
            defaultCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        defaultCell.selectionStyle = UITableViewCellSelectionStyleNone;
        cellHeight = defaultCell.frame.size.height;
        //defaultCell = nil;
    }
    
    return cellHeight;
    */
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header;
    
    
    if (self.HeaderBlock) {
        NSDictionary *sectionData = [self.sections objectAtIndex:section];
        header = self.HeaderBlock(sectionData,tableView);
    }
    
    return header;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, tableView.bounds.size.width, 0.01f)];
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    id cellData = [[self.gridData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    if (self.ItemSelectedBlock) {
        self.ItemSelectedBlock(cellData);
    }
    
    
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.canEditRow;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSMutableArray *gridArray = [self.gridData objectAtIndex:indexPath.section];
        id itemData = [gridArray objectAtIndex:indexPath.row];
        
        if (self.ItemDeleteBlock) {
            self.ItemDeleteBlock(itemData);
        }
        
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}
@end
