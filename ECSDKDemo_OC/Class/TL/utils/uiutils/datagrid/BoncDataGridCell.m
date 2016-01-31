//
//  BoncDataGridCell.m
//  TableViewGridTest
//
//  Created by Rainbow on 12/2/14.
//  Copyright (c) 2014 Rainbow. All rights reserved.
//

#import "BoncDataGridCell.h"
#import "BoncColumnItem.h"
#import "BoncUtils.h"
#import "BoncCheckBoxColumnItem.h"

#import "RImageBtn.h"
@implementation BoncDataGridCell
@synthesize CheckBoxBlock=_CheckBoxBlock,DeleteItemBlock=_DeleteItemBlock;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        //
        self.columns = [[NSMutableArray alloc] init];
        
    }
    
    return self;
   
}

-(void)setHeaderData:(NSDictionary *)headerData{
    self.columnWidths = [[NSMutableArray alloc] init];
    _headerData = headerData;
    
    
    NSString *headerFontSize = [self.headerData valueForKey:@"fontSize"]?[self.headerData valueForKey:@"fontSize"]:GRID_HEADER_FONT_SIZE;
    
    NSString *fontStr = [self.headerData valueForKey:@"font"]?[self.headerData valueForKey:@"font"]:GRID_HEADER_FONT;
    
    NSString *isAutoColumnWidthStr = [self.headerData valueForKey:@"isAutoColumnWidth"]?[self.headerData valueForKey:@"isAutoColumnWidth"]:IS_AUTO_COLOUMN_WIDTH;
    BOOL isAutoColumnWidth = [@"1" isEqualToString:isAutoColumnWidthStr]?YES:NO;
    
    
    NSArray *headerDataArray = [self.headerData valueForKey:@"header"];
    
    __block CGFloat xValue = 0;
    __block CGFloat totalWidth = 0;
    
    
    //计算实际文字的总宽度-用于自动计算列宽
    [headerDataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        int isShowFlag = [[obj objectForKey:@"ISSHOW"] intValue];
        if (isShowFlag==1) {
            NSString *headerName = [obj objectForKey:@"NAME"];
            
            UIFont *font = [UIFont fontWithName:fontStr size:[headerFontSize floatValue]];
            NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
            CGSize headerNameSize  = [headerName sizeWithAttributes:dic];
            totalWidth = totalWidth + headerNameSize.width;
        }
        
    }];
    
    
    //自动计算列宽
    [headerDataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        //循环
        int isShowFlag = [[obj objectForKey:@"ISSHOW"] intValue];
        if (isShowFlag==1) {
            
            NSString *headerName = [obj objectForKey:@"NAME"];
            NSString *headerColumnWidthStr = [obj objectForKey:@"WIDHT"];
            
            UIFont *font = [UIFont fontWithName:fontStr size:[headerFontSize floatValue]];
            NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
            CGSize headerNameSize  = [headerName sizeWithAttributes:dic];
            
            
            float headerColumnWidth = [headerColumnWidthStr floatValue];
            
            if (isAutoColumnWidth) {
                //自动计算列宽

                headerColumnWidth = (CGRectGetWidth(self.frame)-C_COLUMN_BTN_WIDTH)*headerNameSize.width/totalWidth;
                
            }else{
                if (idx==[headerDataArray count]-1) {
                    headerColumnWidth = CGRectGetWidth(self.frame)- xValue;
                    
                }
            }
            
            [self.columnWidths addObject:[NSString stringWithFormat:@"%f",headerColumnWidth]];
            
     
            xValue = xValue + headerColumnWidth;
        }else{
            [self.columnWidths addObject:[NSString stringWithFormat:@"0"]];
        }
    }];
    
}

//渲染内部视图
- (void)initContent{
    NSArray *headerData = [self.headerData valueForKey:@"header"];

        [self.contentView setBackgroundColor:[UIColor clearColor]];
    
    //计算实际文字的总宽度-用于自动计算列宽
    //删除上次加载的视图
    [self.columns enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIView *item = obj;
        [item removeFromSuperview];
    }];
    __block CGFloat xValue = 0;
    [headerData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        int isShowFlag = [[obj objectForKey:@"ISSHOW"] intValue];
        if (isShowFlag==1) {
            NSString *type = [obj valueForKey:@"TYPE"];
            NSString *headerCode = [obj objectForKey:@"CODE"];
            NSString *columnWidthStr = [self.columnWidths objectAtIndex:idx];
            float columnWidth = [columnWidthStr floatValue];
        
        //#############################################################
        
            //type:TEXT
            if ([@"TEXT" isEqualToString:type]) {
                BoncColumnItem *columnItemView = [[BoncColumnItem alloc] initWithFrame:CGRectMake(xValue, 0.0f, columnWidth, CGRectGetHeight(self.frame))];
                [columnItemView setRowData:self.rowData];
                [columnItemView setCode:headerCode];
                [self.contentView addSubview:columnItemView];
                
                [self.columns addObject:columnItemView];
                
            }else if([@"CHECKBOX" isEqualToString:type]) {
                //type:CHECKBOX
                CGFloat imageWidth = 30.0f;
                NSString *columnText = [self.rowData valueForKey:headerCode];
                RImageBtn *checkBtn = [[RImageBtn alloc] initWithFrameImageStateTitle:CGRectMake(xValue+5.0f, (CGRectGetHeight(self.frame)-imageWidth)/2, imageWidth, imageWidth) btnImage:@"checkUnSelected.png" selectedImage:@"checkSelected.png" highLightedImage:@"checkSelected.png" btnTitle:@""];
                [checkBtn addTarget:self action:@selector(checkBoxBtnHandler:) forControlEvents:UIControlEventTouchUpInside];

                [checkBtn setItemData:@{@"headerCode":headerCode}];
                if ([@"0" isEqualToString:columnText]) {
                    [checkBtn setSelected:NO];
                    
                }else{
                    [checkBtn setSelected:YES];
                            [self.contentView setBackgroundColor:[BoncUtils colorWithHexString:@"#1076ef" alpha:0.2]];
                }
                [self.contentView addSubview:checkBtn];
                [self.columns addObject:checkBtn];

            
//            BoncCheckBoxColumnItem *checkBoxColumnItem = [[BoncCheckBoxColumnItem alloc] initWithFrame:CGRectMake(xValue, 0.0f, columnWidth, CGRectGetHeight(self.frame))];
//            
//                [checkBoxColumnItem setRowData:self.rowData];
//                [checkBoxColumnItem setCode:headerCode];
//                [self.contentView addSubview:checkBoxColumnItem];
//            
//                [self.columns addObject:checkBoxColumnItem];
                
            }else if ([@"DELETEBTN" isEqualToString:type]){
                //删除按钮
                //type:CHECKBOX
                CGFloat imageWidth = columnWidth;
                //NSString *columnText = [self.rowData valueForKey:headerCode];
                RImageBtn *deleteBtn = [[RImageBtn alloc] initWithFrameImageTitle:CGRectMake(xValue+5.0f, (CGRectGetHeight(self.frame)-imageWidth/2)/2, imageWidth, imageWidth/2) btnImage:@"bottom_submit_normal.9.png" btnTitle:@"删除"];
                [deleteBtn addTarget:self action:@selector(deleteBtnHandler:) forControlEvents:UIControlEventTouchUpInside];
                
                [self.contentView addSubview:deleteBtn];
                [self.columns addObject:deleteBtn];
            }
        //#############################################################
            
            
            xValue = xValue + columnWidth;
        }
    }];
    
    
   
    if (self.lineLayer) {
        [self.lineLayer removeFromSuperlayer];
    }
    self.lineLayer = [CALayer layer];
    [self.lineLayer setFrame:CGRectMake(0.0, CGRectGetHeight(self.frame)-1, CGRectGetWidth(self.frame), 1.0f)];
    self.lineLayer.borderWidth = 1.0f;
    self.lineLayer.borderColor = [UIColor colorWithRed:12/255.0 green:12/255.0 blue:12/255.0 alpha:0.2].CGColor;
    
    [self.contentView.layer addSublayer:self.lineLayer];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
//    if (selected) {
//        NSLog(@"selected");
//        [self.contentView setBackgroundColor:[BoncUtils colorWithHexString:@"#1076ef" alpha:0.2]];
//        //self.backgroundColor = [BoncUtils colorWithHexString:@"#1076ef" alpha:0.2];
//    }else{
//        NSLog(@"unSelected");
//        [self.contentView setBackgroundColor:[UIColor clearColor]];
//    }
    
}

-(void)checkBoxBtnHandler:(RImageBtn *)btn{
    if (btn.selected) {
        [btn setSelected:NO];
        [self.contentView setBackgroundColor:[UIColor clearColor]];
        [super setSelected:btn.selected animated:YES];
        [self.rowData setValue:@"0" forKey:[[btn itemData] valueForKey:@"headerCode"]];
    }else{
        [btn setSelected:YES];
        [self.contentView setBackgroundColor:[BoncUtils colorWithHexString:@"#1076ef" alpha:0.2]];
        [self.rowData setValue:@"1" forKey:[[btn itemData] valueForKey:@"headerCode"]];
        [super setSelected:btn.selected animated:YES];
    }
    
    
 
    
    //这是现在我们要说的block
    
    if (self.CheckBoxBlock) {
        
        self.CheckBoxBlock();
        
    }
}

-(void)deleteBtnHandler:(RImageBtn *)btn{

    
    //这是现在我们要说的block
    
    if (self.DeleteItemBlock) {
        
        self.DeleteItemBlock(self.rowData);
        
    }
}


@end
