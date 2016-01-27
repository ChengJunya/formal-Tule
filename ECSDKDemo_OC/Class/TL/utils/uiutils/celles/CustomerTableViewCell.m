//
//  CustomerTableViewCell.m
//  ContractManager
//
//  Created by Rainbow on 12/27/14.
//  Copyright (c) 2014 BONC. All rights reserved.
//

#import "CustomerTableViewCell.h"
@implementation CustomerTableViewCell

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
    if([self.contentView viewWithTag:1603]!=nil){
        [[self.contentView viewWithTag:1603] removeFromSuperview];
    }
    if([self.contentView viewWithTag:1604]!=nil){
        [[self.contentView viewWithTag:1604] removeFromSuperview];
    }
    
    
    CGFloat imageWidth = rowHeight-CustomerTableViewCell_IMAGE_GAP*2;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CustomerTableViewCell_IMAGE_GAP, CustomerTableViewCell_IMAGE_GAP, imageWidth, imageWidth)];
    imageView.tag = 1600;
    [imageView setImage:[UIImage imageNamed:[self.rowData valueForKey:@"IMAGE_NAME"]]];
    [self.contentView addSubview:imageView];
    
    NSString *title = [self.rowData valueForKey:@"NAME"];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15], NSFontAttributeName, nil];
    CGSize titleSize = [title sizeWithAttributes:dic];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageWidth+CustomerTableViewCell_IMAGE_GAP*2, CustomerTableViewCell_IMAGE_GAP, titleSize.width, titleSize.height)];
    titleLabel.text = title;
    titleLabel.tag = 1601;
    [titleLabel setFont:[UIFont systemFontOfSize:15]];
    [titleLabel setTextColor:UIColorFromRGB(0x000000)];
    [self.contentView addSubview:titleLabel];
    
    
    NSString *phone = [self.rowData valueForKey:@"TEL"];
    
    CGSize phoneSize = [phone sizeWithAttributes:dic];
    
    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)-CustomerTableViewCell_IMAGE_GAP-phoneSize.width, CustomerTableViewCell_IMAGE_GAP, phoneSize.width, phoneSize.height)];
    phoneLabel.text = phone;
    phoneLabel.tag = 1604;
    [phoneLabel setFont:[UIFont systemFontOfSize:15]];
    [phoneLabel setTextColor:UIColorFromRGB(0x000000)];
    [self.contentView addSubview:phoneLabel];
    
    
    
    
    

    NSString *desc = [NSString stringWithFormat:@"%@", [self.rowData valueForKey:@"ADDRESS"]];
    
    
    
    
    NSDictionary *dicDesc = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12], NSFontAttributeName, nil];
    CGSize descSize = [desc sizeWithAttributes:dicDesc];
    
    UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageWidth+CustomerTableViewCell_IMAGE_GAP*2, rowHeight-descSize.height-CustomerTableViewCell_IMAGE_GAP-descSize.height, descSize.width, descSize.height)];
    descLabel.text = desc;
    descLabel.tag = 1602;
    [descLabel setFont:[UIFont systemFontOfSize:12]];
    [descLabel setTextColor:UIColorFromRGB(0x000000)];
    [self.contentView addSubview:descLabel];
    
    
    NSString *createTime = [NSString stringWithFormat:@"%@", [self.rowData valueForKey:@"CREATETIME"]];
    CGSize createTimeSize = [createTime sizeWithAttributes:dicDesc];
    UILabel *createTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageWidth+CustomerTableViewCell_IMAGE_GAP*2, rowHeight-descSize.height-CustomerTableViewCell_IMAGE_GAP*2-createTimeSize.height*2, createTimeSize.width, createTimeSize.height)];
    createTimeLabel.text = createTime;
    createTimeLabel.tag = 1603;
    [createTimeLabel setFont:[UIFont systemFontOfSize:12]];
    [createTimeLabel setTextColor:UIColorFromRGB(0x000000)];
    [self.contentView addSubview:createTimeLabel];
    
    
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
