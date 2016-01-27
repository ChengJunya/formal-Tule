//
//  CImageTextCellTableViewCell.m
//  ContractManager
//
//  Created by Rainbow on 12/20/14.
//  Copyright (c) 2014 BONC. All rights reserved.
//

#import "CImageTextCellTableViewCell.h"




@implementation CImageTextCellTableViewCell
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

-(void)setHeaderData:(NSDictionary *)headerData{
    
    
    
}



//渲染内部视图
- (void)initContent{
    
    

    CGFloat rowHeight = self.frame.size.height;
    
    
    if([self.contentView viewWithTag:1600]!=nil){
        [[self.contentView viewWithTag:1600] removeFromSuperview];
    }
    if([self.contentView viewWithTag:1601]!=nil){
        [[self.contentView viewWithTag:1601] removeFromSuperview];
    }
    if([self.contentView viewWithTag:1602]!=nil){
        [[self.contentView viewWithTag:1602] removeFromSuperview];
    }
    
    

    CGFloat imageWidth = rowHeight-CImageTextCellTableViewCell_IMAGE_GAP*2;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CImageTextCellTableViewCell_IMAGE_GAP, CImageTextCellTableViewCell_IMAGE_GAP, imageWidth, imageWidth)];
    imageView.tag = 1600;
    [imageView setImage:[UIImage imageNamed:[self.rowData valueForKey:@"IMAGE_NAME"]]];
    [self.contentView addSubview:imageView];
    
    NSString *title = [self.rowData valueForKey:@"TITLE_NAME"];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15], NSFontAttributeName, nil];
    CGSize titleSize = [title sizeWithAttributes:dic];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageWidth+CImageTextCellTableViewCell_IMAGE_GAP*2, 20.0f, titleSize.width, titleSize.height)];
    titleLabel.text = title;
    titleLabel.tag = 1601;
    [titleLabel setFont:[UIFont systemFontOfSize:15]];
    [titleLabel setTextColor:UIColorFromRGB(0x000000)];
    [self.contentView addSubview:titleLabel];
    
    NSString *desc;
    if ([@"TODO_CELL" isEqualToString:[self.rowData valueForKey:@"CELL_TYPE"]]) {
        desc = [NSString stringWithFormat:@"%@条待办工单", [self.rowData valueForKey:@"TO_COUNT"]];
    }else if([@"TODO_PROCESS_CELL" isEqualToString:[self.rowData valueForKey:@"CELL_TYPE"]]) {
        desc = [NSString stringWithFormat:@"%@条待处理工单", [self.rowData valueForKey:@"TO_COUNT"]];
    }


    
    NSDictionary *dicDesc = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12], NSFontAttributeName, nil];
    CGSize descSize = [desc sizeWithAttributes:dicDesc];
    
    UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageWidth+CImageTextCellTableViewCell_IMAGE_GAP*2, rowHeight-descSize.height-20.0f, descSize.width, descSize.height)];
    descLabel.text = desc;
    descLabel.tag = 1602;
    [descLabel setFont:[UIFont systemFontOfSize:12]];
    [descLabel setTextColor:UIColorFromRGB(0x000000)];
    [self.contentView addSubview:descLabel];
    
    
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
    if (selected) {
        NSLog(@"selected");
        self.backgroundColor = [UIColor colorWithRed:0 green:122/255.0 blue:255/255.0 alpha:0.2];
        
        //[self action];
        
    }else{
        NSLog(@"unSelected");
        self.backgroundColor = [UIColor clearColor];
    }
    
}


- (void)setFrame:(CGRect)frame {
    
    
    //frame = CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame),BoncColumnSelectView_WIDTH, CGRectGetHeight(frame));
    
    [super setFrame:frame];
    
}

@end
