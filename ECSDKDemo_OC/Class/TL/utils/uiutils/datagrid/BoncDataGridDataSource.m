//
//  BoncDataGridDataSource.m
//  TableViewGridTest
//
//  Created by Rainbow on 12/2/14.
//  Copyright (c) 2014 Rainbow. All rights reserved.
//

#import "BoncDataGridDataSource.h"

#import "BoncDataGridHeaderView.h"
#import "SBJsonParser.h"
#import "BoncDataGridCell.h"
#import "BoncDefine.h"
#import "CImageTextCellTableViewCell.h"
#import "CImageTextCell2TableViewCell.h"
#import "CustomerTableViewCell.h"
#import "CLeftMenuTableCell.h"
#import "TLLeftMenuCell.h"
#import "BasicCellViewTableViewCell.h"
#import "TLNoteMessageCell.h"
#import "TLStrategyCell.h"
#import "TLProvinceCell.h"
#import "TLCityCell.h"
#import "TLCommentCell.h"
#import "TLWayBookCell.h"
#import "RTextCell.h"
#import "TLGroupActivityCell.h"
#import "TLCarInfoCell.h"
#import "TLCarCommentCell.h"
#import "TLCarHireCell.h"
#import "TLCarServiceCell.h"
#import "TLSecondCell.h"
#import "TLStoreCell.h"
#import "TLUserListCell.h"
#import "TLContactCell.h"
#import "TLOrgMessageCell.h"
#import "TLComment10000Cell.h"


//sctionViews
#import "TLSearchSectionView.h"

@interface BoncDataGridDataSource(){

}
@end

@implementation BoncDataGridDataSource
@synthesize sections=_sections,gridData=_gridData,columnSelectView=_columnSelectView;
-(instancetype)initWithTableView:(UITableView*)tableView itemData:(NSDictionary*)itemData{
    self = [super init];
    if (self) {
        //获取资源初始化数据
        self.tableView = tableView;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.itemData = itemData;
        
        NSArray *gridDataArray = [self.itemData valueForKey:@"GRID_DATA"];
        self.gridData = [NSMutableArray arrayWithArray: gridDataArray];
        
        self.sections = [self.itemData valueForKey:@"SECTION_DATA"];

        if ([@"0" isEqualToString:[self.itemData valueForKey:@"isShowHeader"]]) {
            
        }else{
            //如果
            if ([@"1" isEqualToString:[self.itemData valueForKey:@"isShowColumnSelecter"]]) {
                NSString *headerHeightStr = [self.headerData valueForKey:@"headerHeight"]?[self.headerData valueForKey:@"headerHeight"]:GRID_HEADER_HEIGHT;
                
                NSArray *headerData = [self.headerData valueForKey:@"header"];
                self.columnSelectView = [[BoncColumnSelectView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.tableView.frame)-BoncColumnSelectView_WIDTH, [headerHeightStr floatValue], BoncColumnSelectView_WIDTH, [headerData count]*BoncColumnSelectItemTableViewCell_HEIGHT) columnData:headerData];
                self.columnSelectView.delegate = self;

                self.isColumnSelectViewHidden = YES;
                
                UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
                //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
                tapGestureRecognizer.cancelsTouchesInView = NO;
                //将触摸事件添加到当前view
                [self.tableView addGestureRecognizer:tapGestureRecognizer];
            }
        }
    }
    return self;
}

-(void)setGridData:(NSMutableArray *)gridData{
    _gridData = gridData;
    [self.tableView reloadData];
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    if(!self.isColumnSelectViewHidden){
        [self isShowSelectColumnBtnSelected:YES];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id cellData = [[self.gridData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    NSString *cellType = [[self.sections objectAtIndex:indexPath.section] valueForKey:@"CELL_TYPE"];
     NSString *CellIdentifier = cellType;
    UITableViewCell *defaultCell;
    
    if ([@"NORMAL" isEqualToString:cellType]) {
        BoncDataGridCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[BoncDataGridCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setRowData:cellData];
        [cell setHeaderData:self.headerData];
        [cell initContent];
        
        cell.CheckBoxBlock = ^{
            [self checkBoxSelected];
        };
        
        return cell;
        
    }else if ([@"IMAGETEXT01" isEqualToString:cellType]) {
         CImageTextCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[CImageTextCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setRowData:[self.gridData objectAtIndex:indexPath.row]];
        [cell initContent];
        
        return cell;
        
        //IMAGETEXT02
    }else if ([@"IMAGETEXT02" isEqualToString:cellType]) {
        CImageTextCell2TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[CImageTextCell2TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
       
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
       
        
        [cell setRowData:[self.gridData objectAtIndex:indexPath.row]];
        [cell initContent];
        
        return cell;
        
        //IMAGETEXT03
    }else if ([@"IMAGETEXT03" isEqualToString:cellType]) {
        CustomerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[CustomerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        CGRect cellFrame =[cell frame];
        cellFrame.origin =CGPointMake(0,0);
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell setRowData:cellData];
        [cell initContent];
        
        return cell;
        
        //IMAGETEXT04 CLeftMenuTableCell.h
    }else if ([@"IMAGETEXT04" isEqualToString:cellType]) {
        CLeftMenuTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[CLeftMenuTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
          cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell setRowData:cellData];
        [cell initContent];
        
        return cell;
        
        //LEFT_MENU_LIST_GRID
    }else if ([@"LEFT_MENU_LIST_GRID" isEqualToString:cellType]) {
        BasicCellViewTableViewCell *cell = [self createTLLeftMenuCell:CellIdentifier tableView:tableView];
        
        [cell setCellData:cellData];
        [cell initContent];
        return cell;

    }else if ([@"MESSAGE_LIST_GRID" isEqualToString:cellType]) {
        BasicCellViewTableViewCell *cell = [self createTLNoteMessageCell:CellIdentifier tableView:tableView];
//        NSDictionary *cellData = cellData;
        [cell setCellData:cellData];
        [cell initContent];
        return cell;
        
    }else if ([MODULE_STRATEGY isEqualToString:cellType]) {
        BasicCellViewTableViewCell *cell = [self createTLStrategyCell:CellIdentifier tableView:tableView];
//        NSDictionary *cellData = [self.gridData objectAtIndex:indexPath.row];
        [cell setCellData:cellData];
        [cell initContent];
        return cell;
        
    }else if ([PROVINCE_CELL isEqualToString:cellType]) {
        BasicCellViewTableViewCell *cell = [self createTLProvinceCell:CellIdentifier tableView:tableView];
//        NSDictionary *cellData = [self.gridData objectAtIndex:indexPath.row];
        [cell setCellData:cellData];
        [cell initContent];
        return cell;
    }else if ([CITY_CELL isEqualToString:cellType]) {
        BasicCellViewTableViewCell *cell = [self createTLCityCell:CellIdentifier tableView:tableView];
//        NSDictionary *cellData = [self.gridData objectAtIndex:indexPath.row];
        [cell setCellData:cellData];
        [cell initContent];
        return cell;
        
    }else if ([COMMENT_CELL isEqualToString:cellType]) {
        BasicCellViewTableViewCell *cell = [self createTLCommentCell:CellIdentifier tableView:tableView];
//        NSDictionary *cellData = [self.gridData objectAtIndex:indexPath.row];
        [cell setCellData:cellData];
        [cell initContent];
        return cell;
        

    }else if ([TL_ORG_MSSAGE_CELL isEqualToString:cellType]) {
        BasicCellViewTableViewCell *cell = [self createTLOrgCommentCell:CellIdentifier tableView:tableView];
        //        NSDictionary *cellData = [self.gridData objectAtIndex:indexPath.row];
        [cell setCellData:cellData];
        [cell initContent];
        return cell;
        
    }else if ([MODULE_WAYBOOK isEqualToString:cellType]) {
        BasicCellViewTableViewCell *cell = [self createTLWayBookCell:CellIdentifier tableView:tableView];
//        NSDictionary *cellData = [self.gridData objectAtIndex:indexPath.row];
        [cell setCellData:cellData];
        [cell initContent];
        return cell;
        
    }else if ([@"RTextCell" isEqualToString:cellType]) {
        BasicCellViewTableViewCell *cell = [self createRTextCell:CellIdentifier tableView:tableView];
//        NSDictionary *cellData = [self.gridData objectAtIndex:indexPath.row];
        [cell setCellData:cellData];
        [cell initContent];
        return cell;
    }else if ([MODULE_GROUPACTIVITY isEqualToString:cellType]) {
        BasicCellViewTableViewCell *cell = [self createTLGroupActivityCell:CellIdentifier tableView:tableView];
//        NSDictionary *cellData = [self.gridData objectAtIndex:indexPath.row];
        [cell setCellData:cellData];
        [cell initContent];
        return cell;
        
    }else if ([MODULE_CARINFO_INFO isEqualToString:cellType]) {
        //carinfo
        BasicCellViewTableViewCell *cell = [self createTLCarInfoCell:CellIdentifier tableView:tableView];
//        NSDictionary *cellData = [self.gridData objectAtIndex:indexPath.row];
        [cell setCellData:cellData];
        [cell initContent];
        return cell;
    }else if ([MODULE_CARINFO_COMMENT isEqualToString:cellType]) {
       //carcomment
        BasicCellViewTableViewCell *cell = [self createTLCarCommentCell:CellIdentifier tableView:tableView];
//        NSDictionary *cellData = [self.gridData objectAtIndex:indexPath.row];
        [cell setCellData:cellData];
        [cell initContent];
        return cell;
    }else if ([MODULE_CARINFO_HIRE isEqualToString:cellType]) {
        //car hire
        BasicCellViewTableViewCell *cell = [self createTLCarHireCell:CellIdentifier tableView:tableView];
//        NSDictionary *cellData = [self.gridData objectAtIndex:indexPath.row];
        [cell setCellData:cellData];
        [cell initContent];
        return cell;
    }else if ([MODULE_CARINFO_SERVICE isEqualToString:cellType]) {
        //car service
        BasicCellViewTableViewCell *cell = [self createTLCarServiceCell:CellIdentifier tableView:tableView];
//        NSDictionary *cellData = [self.gridData objectAtIndex:indexPath.row];
        [cell setCellData:cellData];
        [cell initContent];
        return cell;
    }else if ([MODULE_SECONDPATFORM isEqualToString:cellType]) {
        //car service
        BasicCellViewTableViewCell *cell = [self createTLSecondCell:CellIdentifier tableView:tableView];
//        NSDictionary *cellData = [self.gridData objectAtIndex:indexPath.row];
        [cell setCellData:cellData];
        [cell initContent];
        return cell;
    }else if ([MODULE_STORE isEqualToString:cellType]) {
        BasicCellViewTableViewCell *cell = [self createTLStoreCell:CellIdentifier tableView:tableView];
        [cell setCellData:cellData];
        [cell initContent];
        return cell;
    }else if ([TL_USER_CELL isEqualToString:cellType]) {
        BasicCellViewTableViewCell *cell = [self createTLUserListCell:CellIdentifier tableView:tableView];
        [cell setCellData:cellData];
        [cell initContent];
        return cell;
    }else if ([TL_CONTACT_CELL isEqualToString:cellType]) {
        BasicCellViewTableViewCell *cell = [self createTLContactCell:CellIdentifier tableView:tableView];
        [cell setCellData:cellData];
        [cell initContent];
        return cell;
    }else if ([COMMENT10000_CELL isEqualToString:cellType]) {
        BasicCellViewTableViewCell *cell = [self createTLComment10000Cell:CellIdentifier tableView:tableView];
        [cell setCellData:cellData];
        [cell initContent];
        return cell;
    }else{
        
        BoncDataGridCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[BoncDataGridCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }

        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        
        [cell setRowData:[self.gridData objectAtIndex:indexPath.row]];
        [cell setHeaderData:self.headerData];
        [cell initContent];
        cell.CheckBoxBlock = ^{
            
            [self checkBoxSelected];
            
        };
        cell.DeleteItemBlock = ^(NSDictionary * rowData){
            [self deleteBtnSelected:rowData];
        };
        return cell;
    }


    return defaultCell;
    
    
    
}

-(BasicCellViewTableViewCell*)createTLLeftMenuCell:(NSString*)CellIdentifier tableView:(UITableView*)tableView{
    TLLeftMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[TLLeftMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(BasicCellViewTableViewCell*)createTLNoteMessageCell:(NSString*)CellIdentifier tableView:(UITableView*)tableView{
    TLNoteMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[TLNoteMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(BasicCellViewTableViewCell*)createTLStrategyCell:(NSString*)CellIdentifier tableView:(UITableView*)tableView{
    TLStrategyCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[TLStrategyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(BasicCellViewTableViewCell*)createTLWayBookCell:(NSString*)CellIdentifier tableView:(UITableView*)tableView{
    TLWayBookCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[TLWayBookCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}



-(BasicCellViewTableViewCell*)createTLProvinceCell:(NSString*)CellIdentifier tableView:(UITableView*)tableView{
    TLProvinceCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[TLProvinceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
-(BasicCellViewTableViewCell*)createTLCityCell:(NSString*)CellIdentifier tableView:(UITableView*)tableView{
    TLCityCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[TLCityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
-(BasicCellViewTableViewCell*)createTLCommentCell:(NSString*)CellIdentifier tableView:(UITableView*)tableView{
    TLCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[TLCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(BasicCellViewTableViewCell*)createTLComment10000Cell:(NSString*)CellIdentifier tableView:(UITableView*)tableView{
    TLComment10000Cell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[TLComment10000Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(BasicCellViewTableViewCell*)createTLOrgCommentCell:(NSString*)CellIdentifier tableView:(UITableView*)tableView{
    TLOrgMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[TLOrgMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}



-(BasicCellViewTableViewCell*)createRTextCell:(NSString*)CellIdentifier tableView:(UITableView*)tableView{
    RTextCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[RTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(BasicCellViewTableViewCell*)createTLGroupActivityCell:(NSString*)CellIdentifier tableView:(UITableView*)tableView{
    TLGroupActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[TLGroupActivityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

//carinfo
-(BasicCellViewTableViewCell*)createTLCarInfoCell:(NSString*)CellIdentifier tableView:(UITableView*)tableView{
    TLCarInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[TLCarInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
//carcomment
-(BasicCellViewTableViewCell*)createTLCarCommentCell:(NSString*)CellIdentifier tableView:(UITableView*)tableView{
    TLCarCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[TLCarCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
//carhire
-(BasicCellViewTableViewCell*)createTLCarHireCell:(NSString*)CellIdentifier tableView:(UITableView*)tableView{
    TLCarHireCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[TLCarHireCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
//carservice
-(BasicCellViewTableViewCell*)createTLCarServiceCell:(NSString*)CellIdentifier tableView:(UITableView*)tableView{
    TLCarServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[TLCarServiceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

//TLSecondCell
-(BasicCellViewTableViewCell*)createTLSecondCell:(NSString*)CellIdentifier tableView:(UITableView*)tableView{
    TLSecondCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[TLSecondCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

//TLStoreCell

-(BasicCellViewTableViewCell*)createTLStoreCell:(NSString*)CellIdentifier tableView:(UITableView*)tableView{
    TLStoreCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[TLStoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

//TLUserListCell
-(BasicCellViewTableViewCell*)createTLUserListCell:(NSString*)CellIdentifier tableView:(UITableView*)tableView{
    TLUserListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[TLUserListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

//TL_CONTACT_CELL
-(BasicCellViewTableViewCell*)createTLContactCell:(NSString*)CellIdentifier tableView:(UITableView*)tableView{
    TLContactCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[TLContactCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void)checkBoxSelected{
    NSLog(@"checkBoxSelected....");
}

-(void)deleteBtnSelected:(NSDictionary *)rowData{
    [self.gridData removeObject:rowData];
    
    [self.tableView reloadData];
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arrayOfSection = [self.gridData objectAtIndex:section];
    return [arrayOfSection count];
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.sections count] ;
}



-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if ([self.sections count]>1) {
        CGFloat sectionHeight = 0.f;
        NSDictionary *sectionData = [self.sections objectAtIndex:section];
        NSUInteger sectionType = [[sectionData valueForKey:@"SECTION_TYPE"] integerValue];
        switch (sectionType) {
                //通过sectiontype来判断创建什么样的头部信息，并获取头部信息的高度
            case 1:
            {
                TLSearchSectionView *headerView = [[TLSearchSectionView alloc] initWithFrame:CGRectMake(0.f, 0.f, CGRectGetWidth(self.tableView.frame), 30.f) sectionData:sectionData];
                sectionHeight = headerView.sectionHeight;
                headerView = nil;
                break;
            }
            default:
                sectionHeight = 30.f;
                break;
        }
        
        
        return sectionHeight;
    }else{
        return 0.f;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *tempCellIdentifier = @"TEMP_CELL_ID";

    CGFloat cellHeight = 0.f;
    id cellData = [[self.gridData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    NSString *cellType = [[self.sections objectAtIndex:indexPath.section] valueForKey:@"CELL_TYPE"];
    
    if ([@"LEFT_MENU_LIST_GRID" isEqualToString:cellType]) {
        BasicCellViewTableViewCell *cell = [self createTLLeftMenuCell:tempCellIdentifier tableView:tableView];
       
        [cell setCellData:cellData];
        [cell initContent];
        cellHeight = cell.cellHeight;
        cell = nil;
        
    }else if ([@"MESSAGE_LIST_GRID" isEqualToString:cellType]) {
        BasicCellViewTableViewCell *cell = [self createTLNoteMessageCell:tempCellIdentifier tableView:tableView];
        [cell setCellData:cellData];
        [cell initContent];
        cellHeight = cell.cellHeight;
        cell = nil;
        
    }else if ([MODULE_STRATEGY isEqualToString:cellType]) {
        BasicCellViewTableViewCell *cell = [self createTLStrategyCell:tempCellIdentifier tableView:tableView];
        [cell setCellData:cellData];
        [cell initContent];
        cellHeight = cell.cellHeight;
        cell = nil;
        
    }else if ([PROVINCE_CELL isEqualToString:cellType]) {
        BasicCellViewTableViewCell *cell = [self createTLProvinceCell:tempCellIdentifier tableView:tableView];
        [cell setCellData:cellData];
        [cell initContent];
        cellHeight = cell.cellHeight;
        cell = nil;
    }else if ([CITY_CELL isEqualToString:cellType]) {
        BasicCellViewTableViewCell *cell = [self createTLCityCell:tempCellIdentifier tableView:tableView];
        [cell setCellData:cellData];
        [cell initContent];
        cellHeight = cell.cellHeight;
        cell = nil;
    }else if ([COMMENT_CELL isEqualToString:cellType]) {
        BasicCellViewTableViewCell *cell = [self createTLCommentCell:tempCellIdentifier tableView:tableView];
        [cell setCellData:cellData];
        [cell initContent];
        cellHeight = cell.cellHeight;
        cell = nil;
    }else if ([TL_ORG_MSSAGE_CELL isEqualToString:cellType]) {
        BasicCellViewTableViewCell *cell = [self createTLOrgCommentCell:tempCellIdentifier tableView:tableView];
        [cell setCellData:cellData];
        [cell initContent];
        cellHeight = cell.cellHeight;
        cell = nil;
        
    }else if ([MODULE_WAYBOOK isEqualToString:cellType]) {
        BasicCellViewTableViewCell *cell = [self createTLWayBookCell:tempCellIdentifier tableView:tableView];
        [cell setCellData:cellData];
        [cell initContent];
        cellHeight = cell.cellHeight;
        cell = nil;
    
    }else if ([@"RTextCell" isEqualToString:cellType]) {
        BasicCellViewTableViewCell *cell = [self createRTextCell:tempCellIdentifier tableView:tableView];
        [cell setCellData:cellData];
        [cell initContent];
        cellHeight = cell.cellHeight;
        cell = nil;
    }else if ([MODULE_GROUPACTIVITY isEqualToString:cellType]) {
        BasicCellViewTableViewCell *cell = [self createTLGroupActivityCell:tempCellIdentifier tableView:tableView];
        [cell setCellData:cellData];
        [cell initContent];
        cellHeight = cell.cellHeight;
        cell = nil;
    }else if ([MODULE_CARINFO_INFO isEqualToString:cellType]) {
        //carinfo
        BasicCellViewTableViewCell *cell = [self createTLCarInfoCell:tempCellIdentifier tableView:tableView];
        [cell setCellData:cellData];
        [cell initContent];
        cellHeight = cell.cellHeight;
        cell = nil;

    }else if ([MODULE_CARINFO_COMMENT isEqualToString:cellType]) {
        //carcomment
        BasicCellViewTableViewCell *cell = [self createTLCarCommentCell:tempCellIdentifier tableView:tableView];
        [cell setCellData:cellData];
        [cell initContent];
        cellHeight = cell.cellHeight;
        cell = nil;

    }else if ([MODULE_CARINFO_HIRE isEqualToString:cellType]) {
        //car hire
        BasicCellViewTableViewCell *cell = [self createTLCarHireCell:tempCellIdentifier tableView:tableView];
        [cell setCellData:cellData];
        [cell initContent];
        cellHeight = cell.cellHeight;
        cell = nil;

    }else if ([MODULE_CARINFO_SERVICE isEqualToString:cellType]) {
        //car service
        BasicCellViewTableViewCell *cell = [self createTLCarServiceCell:tempCellIdentifier tableView:tableView];
        [cell setCellData:cellData];
        [cell initContent];
        cellHeight = cell.cellHeight;
        cell = nil;

    }else if ([MODULE_SECONDPATFORM isEqualToString:cellType]) {
        //car service
        BasicCellViewTableViewCell *cell = [self createTLSecondCell:tempCellIdentifier tableView:tableView];
        [cell setCellData:cellData];
        [cell initContent];
        cellHeight = cell.cellHeight;
        cell = nil;
    }else if ([MODULE_STORE isEqualToString:cellType]) {
        //car service
        BasicCellViewTableViewCell *cell = [self createTLStoreCell:tempCellIdentifier tableView:tableView];
        [cell setCellData:cellData];
        [cell initContent];
        cellHeight = cell.cellHeight;
        cell = nil;
    }else if ([TL_USER_CELL isEqualToString:cellType]) {
        BasicCellViewTableViewCell *cell = [self createTLUserListCell:tempCellIdentifier tableView:tableView];
        [cell setCellData:cellData];
        [cell initContent];
        cellHeight = cell.cellHeight;
        cell = nil;
    }else if ([TL_CONTACT_CELL isEqualToString:cellType]) {
        BasicCellViewTableViewCell *cell = [self createTLContactCell:tempCellIdentifier tableView:tableView];
        [cell setCellData:cellData];
        [cell initContent];
        cellHeight = cell.cellHeight;
        cell = nil;
    }else if ([COMMENT10000_CELL isEqualToString:cellType]) {
        BasicCellViewTableViewCell *cell = [self createTLComment10000Cell:tempCellIdentifier tableView:tableView];
        [cell setCellData:cellData];
        [cell initContent];
        cellHeight = cell.cellHeight;
        cell = nil;
    }else{
        cellHeight = 30.f;
    }
    
    return cellHeight;

}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header;
    if ([self.sections count]>1) {
        NSDictionary *sectionData = [self.sections objectAtIndex:section];
        NSUInteger sectionType = [[sectionData valueForKey:@"SECTION_TYPE"] integerValue];
        switch (sectionType) {
                //通过sectiontype来判断创建什么样的头部信息，并获取头部信息的高度
            case 1:
            {
                TLSearchSectionView *headerView = [[TLSearchSectionView alloc] initWithFrame:CGRectMake(0.f, 0.f, CGRectGetWidth(self.tableView.frame), 30.f) sectionData:sectionData];
                header = headerView;
                break;
            }
            case 10:{
                BoncDataGridHeaderView *boncGridHeader = [[BoncDataGridHeaderView alloc] initWithFrame:CGRectMake(0.0, 0.0, tableView.frame.size.width, 30.0f)];
                
                
                boncGridHeader.headerData = self.headerData;
                boncGridHeader.delegate = self;
                header = boncGridHeader;
                break;
            }
            default:
                
                break;
        }
        
    }
    
    return header;
    
}

-(void)isShowSelectColumnBtnSelected:(BOOL)isSelected{
    
    if (self.isColumnSelectViewHidden) {
        [self.tableView addSubview:self.columnSelectView];
        self.isColumnSelectViewHidden = NO;
       
    }else{
        [self.columnSelectView removeFromSuperview];
        self.isColumnSelectViewHidden = YES;
    }
}

#warning ----------- tableView选择
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
        
    id rowData = [[self.gridData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if (self.ItemSelectedBlock) {
        self.ItemSelectedBlock(rowData);
    }
    
}

-(void)columnSelectionChange:(NSDictionary *)itemData{
    [self.tableView reloadData];
}

@end
