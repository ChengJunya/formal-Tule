//
//  BoncColumnSelectItemTableViewCell.m
//  ContractManager
//
//  Created by Rainbow on 12/21/14.
//  Copyright (c) 2014 BONC. All rights reserved.
//

#import "BoncColumnSelectItemTableViewCell.h"
#import "BoncDefine.h"
@implementation BoncColumnSelectItemTableViewCell
@synthesize rowData=_rowData,rowIndex=_rowIndex;
- (void)awakeFromNib {
    // Initialization code
    NSLog(@"awakeFromNib");
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
    }
    
    return self;
    
}




//渲染内部视图
- (void)initContent{
    if ([self.contentView viewWithTag:1]!=nil) {
        [[self.contentView viewWithTag:1] removeFromSuperview];
    }
    if (self.isShowSwitch!=nil) {
        [self.isShowSwitch removeFromSuperview];
    }
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:11];
    
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    
    NSString *columnName = [self.rowData valueForKey:@"NAME"];
    //stringByReplacingOccurrencesOfString
    //NSRange enterRange = [columnName rangeOfString:@"\\n"];
    
   // headerData = [headerData stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    columnName = [columnName stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    //NSMutableString *newColumnNameStr = [NSMutableString stringWithString:columnName];
    //[newColumnNameStr replaceCharactersInRange:enterRange withString:@""];
    //columnName = [NSString stringWithString:newColumnNameStr];
    CGSize columnNameSize = [columnName sizeWithAttributes:dic];
    UILabel *columnNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, (CGRectGetHeight(self.frame)-columnNameSize.height)/2, columnNameSize.width, columnNameSize.height)];
    columnNameLabel.tag = 1;
    [columnNameLabel setText:columnName];
    [columnNameLabel setTextColor:[UIColor blackColor]];
    [columnNameLabel setFont:font];
    [self.contentView addSubview:columnNameLabel];
    
    CGFloat switchHeight = 31.0f;
    CGFloat switchWidth = 51.0f;
    
    self.isShowSwitch = [[BoncSwitch alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame) - switchWidth-10.0f, (CGRectGetHeight(self.frame)-switchHeight)/2, switchWidth, switchHeight)];
    self.isShowSwitch.tag = 2;
    self.isShowSwitch.on = [[self.rowData valueForKey:@"ISSHOW"] intValue]==1?YES:NO;
    [self.isShowSwitch setRowIndex:self.rowIndex];
    //[isShowSwitch setTintColor:[UIColor blueColor]];
    //[isShowSwitch setThumbTintColor:[UIColor purpleColor]];
    //[isShowSwitch setOnTintColor:[UIColor purpleColor]];
    [self.contentView addSubview:self.isShowSwitch];
    //[isShowSwitch setSelected:([[self.rowData valueForKey:@"ISSHOW"] intValue]==1?YES:NO)];
    
    
}
- (void)setFrame:(CGRect)frame {
    

    frame = CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame),BoncColumnSelectView_WIDTH, CGRectGetHeight(frame));
    
    [super setFrame:frame];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
    if (selected) {
        NSLog(@"selected");
        self.backgroundColor = [UIColor clearColor];
        
    }else{
        NSLog(@"unSelected");
        self.backgroundColor = [UIColor clearColor];
    }
    
}

@end
