//
//  TLNewsCell.m
//  TL
//
//  Created by Rainbow on 5/11/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "TLNewsCell.h"

#import "RUILabel.h"
#define CELL_HEIGHT 86.f
#define IMAGE_HEIGHT 80.f
#define H_GAP 15.f
#define V_GAP 3.f
@interface TLNewsCell(){
    UIImageView *cellImage;
    RUILabel *userNameLabel;
    RUILabel *infoLabel;
    RUILabel *dateLabel;
    CALayer *bottomLine;
    
    CGFloat infoLabelHeight;
}

@end

@implementation TLNewsCell

- (void)awakeFromNib {
    
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setupViews];
        
    }
    
    return self;
}

#pragma mark -
#pragma mark - 初始化CELL视图
//添加视图
- (void)setupViews{
    self.backgroundColor = COLOR_DEF_BG;
    
    CGFloat hGap = 10.f;
    CGFloat vGap = 3.f;
    
    
    cellImage = [[UIImageView alloc] initWithFrame:CGRectMake(hGap, vGap, IMAGE_HEIGHT, IMAGE_HEIGHT)];
    cellImage.backgroundColor = UIColorFromRGBA(0x000000, 0.5);
    [self.contentView addSubview:cellImage];
    
    userNameLabel = [[RUILabel alloc] initWithFrame:CGRectZero str:@"" font:FONT_16B color:COLOR_MAIN_TEXT];
    [self.contentView addSubview:userNameLabel];
    
    
    
    infoLabel = [[RUILabel alloc] initWithFrame:CGRectZero str:@"" font:FONT_14 color:COLOR_MAIN_TEXT];
    [self.contentView addSubview:infoLabel];
    infoLabel.numberOfLines = 2;
    infoLabelHeight = infoLabel.height*2;
    
    dateLabel = [[RUILabel alloc] initWithFrame:CGRectZero str:@"" font:FONT_14 color:COLOR_MAIN_TEXT];
    dateLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:dateLabel];
    
    bottomLine = [CALayer layer];
    bottomLine.backgroundColor = UIColorFromRGBA(0xCCCCCC, 0.5).CGColor;
    [self.contentView.layer addSublayer:bottomLine];
    
    
    
    
    
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    
    
    userNameLabel.frame = CGRectMake(H_GAP*2+IMAGE_HEIGHT, V_GAP, self.contentView.width-IMAGE_HEIGHT-H_GAP*3, userNameLabel.height);
    
    infoLabel.frame = CGRectMake(IMAGE_HEIGHT+H_GAP*2, V_GAP*2+userNameLabel.height, self.contentView.width-IMAGE_HEIGHT-H_GAP*3, infoLabelHeight);
    
    
    dateLabel.frame = CGRectMake(H_GAP*2+IMAGE_HEIGHT, (CELL_HEIGHT-dateLabel.height-V_GAP), self.contentView.width-IMAGE_HEIGHT-H_GAP*3, dateLabel.height);
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
+(CGFloat)cellHeight{
    return CELL_HEIGHT;
}

-(void)setCellDto:(TLNewsDataDTO*)cellData{
    _cellData = cellData;
    [self refrashUI];
}

-(void)refrashUI{
    NSString *bgImageUrl = [NSString stringWithFormat:@"%@%@",TL_SERVER_BASE_URL,self.cellData.newsPic];
    [cellImage sd_setImageWithURL:[NSURL URLWithString:bgImageUrl] placeholderImage:[UIImage imageNamed:@"ico_loading_logo"]];
    
    userNameLabel.text = self.cellData.newsTitle;
    //[userNameLabel setWidth:[self.cellData.newsTitle sizeWithAttributes:@{NSFontAttributeName:FONT_16B}].width];
    
    infoLabel.text = self.cellData.newsDesc;
    //[infoLabel setWidth:[self.cellData.newsDesc sizeWithAttributes:@{NSFontAttributeName:FONT_16}].width];
    
    dateLabel.text = self.cellData.newsDate;
    //[dateLabel setWidth:[self.cellData.newsDate sizeWithAttributes:@{NSFontAttributeName:FONT_16}].width];
    
    
    
    
}

@end
