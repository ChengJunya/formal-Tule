//
//  CImageTextCell2TableViewCell.m
//  ContractManager
//
//  Created by Rainbow on 12/22/14.
//  Copyright (c) 2014 BONC. All rights reserved.
//

#import "CImageTextCell2TableViewCell.h"
#import "RImageBtn.h"
@implementation CImageTextCell2TableViewCell

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
    
    
    
    CGFloat rowHeight = [[self.rowData valueForKey:@"height"] floatValue];
    
    
    if([self.contentView viewWithTag:1200]!=nil){
        [[self.contentView viewWithTag:1200] removeFromSuperview];
    }
    if([self.contentView viewWithTag:1201]!=nil){
        [[self.contentView viewWithTag:1201] removeFromSuperview];
    }
    if([self.contentView viewWithTag:1202]!=nil){
        [[self.contentView viewWithTag:1202] removeFromSuperview];
    }
    if([self.contentView viewWithTag:1203]!=nil){
        [[self.contentView viewWithTag:1203] removeFromSuperview];
    }
    
    
    
    CGFloat imageWidth = rowHeight-CImageTextCell2TableViewCell_IMAGE_GAP*2;
    
    
    
    //UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)-imageWidth- CImageTextCell2TableViewCell_IMAGE_GAP, CImageTextCell2TableViewCell_IMAGE_GAP, imageWidth, imageWidth)];
    //imageView.tag = 1600;
    NSString *imageName;
    RImageBtn *imageBtn;
    if ([@"1" isEqualToString:[self.rowData valueForKey:@"isShared"]]) {
        imageName = [self.rowData valueForKey:@"shared_image"];
        imageBtn = [[RImageBtn alloc] initWithFrameImageTitle:CGRectMake(CGRectGetWidth(self.frame)-imageWidth- CImageTextCell2TableViewCell_IMAGE_GAP, CImageTextCell2TableViewCell_IMAGE_GAP, imageWidth, imageWidth) btnImage:imageName btnTitle:@""];
    }else{
        imageName = [self.rowData valueForKey:@"unShared_image"];
        imageBtn = [[RImageBtn alloc] initWithFrameImageTitle:CGRectMake(CGRectGetWidth(self.frame)-imageWidth- CImageTextCell2TableViewCell_IMAGE_GAP, CImageTextCell2TableViewCell_IMAGE_GAP, imageWidth, imageWidth) btnImage:imageName btnTitle:@""];
        [imageBtn addTarget:self action:@selector(imageBtnHandler:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    
    imageBtn.tag = 1200;
    //[imageView setImage:[UIImage imageNamed:imageName]];
    [self.contentView addSubview:imageBtn];
    
    NSString *title = [self.rowData valueForKey:@"marketing_name"];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15], NSFontAttributeName, nil];
    CGSize titleSize = [title sizeWithAttributes:dic];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CImageTextCell2TableViewCell_IMAGE_GAP, 20.0f, titleSize.width, titleSize.height)];
    titleLabel.text = title;
    titleLabel.tag = 1201;
    [titleLabel setFont:[UIFont systemFontOfSize:15]];
    [titleLabel setTextColor:UIColorFromRGB(0x000000)];
    [self.contentView addSubview:titleLabel];
    
    NSString *desc = [self.rowData valueForKey:@"marketing_location"];
    

    NSDictionary *dicDesc = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12], NSFontAttributeName, nil];
    CGSize descSize = [desc sizeWithAttributes:dicDesc];
    
    UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(CImageTextCell2TableViewCell_IMAGE_GAP, rowHeight-descSize.height-20.0f, descSize.width, descSize.height)];
    descLabel.text = desc;
    descLabel.tag = 1202;
    [descLabel setFont:[UIFont systemFontOfSize:12]];
    [descLabel setTextColor:UIColorFromRGB(0x000000)];
    [self.contentView addSubview:descLabel];
    
    
    
    
    NSString *marketingTime = [self.rowData valueForKey:@"marketing_time"];
     CGSize marketingSize = [marketingTime sizeWithAttributes:dicDesc];
    
    
    UILabel *marketingLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)-marketingSize.width-imageWidth, rowHeight-marketingSize.height-20.0f, marketingSize.width, marketingSize.height)];
    marketingLabel.text = marketingTime;
    marketingLabel.tag = 1203;
    [marketingLabel setFont:[UIFont systemFontOfSize:12]];
    [marketingLabel setTextColor:UIColorFromRGB(0x000000)];
    [self.contentView addSubview:marketingLabel];
    
    
    if (self.lineLayer) {
        [self.lineLayer removeFromSuperlayer];
    }
    self.lineLayer = [CALayer layer];
    [self.lineLayer setFrame:CGRectMake(0.0, CGRectGetHeight(self.frame)-1, CGRectGetWidth(self.frame), 1.0f)];
    self.lineLayer.borderWidth = 1.0f;
    self.lineLayer.borderColor = [UIColor colorWithRed:12/255.0 green:12/255.0 blue:12/255.0 alpha:0.2].CGColor;
    
    [self.contentView.layer addSublayer:self.lineLayer];

}

-(void)imageBtnHandler:(RImageBtn*)btn{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确认要分享这条信息吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.delegate = self;
    [alertView show];
}

//根据被点击按钮的索引处理点击事件
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"clickButtonAtIndex:%d",buttonIndex);
    if (buttonIndex==1) {
        [self.rowData setValue:@"1" forKey:@"isShared"];
        [self initContent];
    }
}

//AlertView已经消失时执行的事件
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"didDismissWithButtonIndex");
}

//ALertView即将消失时的事件
-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"willDismissWithButtonIndex");
}

//AlertView的取消按钮的事件
-(void)alertViewCancel:(UIAlertView *)alertView
{
    NSLog(@"alertViewCancel");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
    if (selected) {
        NSLog(@"selected");
        self.backgroundColor = UIColorFromRGB(0xdcdcdc);
        
        //[self action];
        
    }else{
        NSLog(@"unSelected");
        self.backgroundColor = [UIColor clearColor];
    }
    
}



@end
