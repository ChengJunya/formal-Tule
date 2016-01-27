//
//  CLeftMenuTableCell.m
//  ContractManager
//
//  Created by Rainbow on 12/27/14.
//  Copyright (c) 2014 BONC. All rights reserved.
//

#import "CLeftMenuTableCell.h"

@implementation CLeftMenuTableCell

- (void)awakeFromNib {
    // Initialization code

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
    
    
    
    CGFloat imageWidth = rowHeight-CLeftMenuTableCell_IMAGE_GAP*2;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CLeftMenuTableCell_IMAGE_GAP, CLeftMenuTableCell_IMAGE_GAP, imageWidth, imageWidth)];
    imageView.tag = 1600;
    [imageView setImage:[UIImage imageNamed:[self.rowData valueForKey:@"image"]]];
    [self.contentView addSubview:imageView];
    
    NSString *title = [self.rowData valueForKey:@"name"];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15], NSFontAttributeName, nil];
    CGSize titleSize = [title sizeWithAttributes:dic];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageWidth+CLeftMenuTableCell_IMAGE_GAP*4, (CGRectGetHeight(self.frame)-titleSize.height)/2, titleSize.width, titleSize.height)];
    titleLabel.text = title;
    titleLabel.tag = 1601;
    [titleLabel setFont:[UIFont systemFontOfSize:15]];
    [titleLabel setTextColor:UIColorFromRGB(0x000000)];
    [self.contentView addSubview:titleLabel];
    
    
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
