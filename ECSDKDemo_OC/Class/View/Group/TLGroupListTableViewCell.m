//
//  TLGroupListTableViewCell.m
//  TL
//
//  Created by Rainbow on 5/6/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "TLGroupListTableViewCell.h"
#import "RUILabel.h"
#define CELL_HEIGHT 66.f
#define IMAGE_HEIGHT 60.f
#define H_GAP 15.f
#define V_GAP 3.f
@interface TLGroupListTableViewCell(){
    UIImageView *cellImage;
    RUILabel *userNameLabel;
    RUILabel *infoLabel;
    CALayer *bottomLine;
}

@end

@implementation TLGroupListTableViewCell

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
    
    
    
    infoLabel = [[RUILabel alloc] initWithFrame:CGRectZero str:@"" font:FONT_16 color:COLOR_MAIN_TEXT];
    [self.contentView addSubview:infoLabel];
    
    
    bottomLine = [CALayer layer];
    bottomLine.backgroundColor = UIColorFromRGBA(0xCCCCCC, 0.5).CGColor;
    [self.contentView.layer addSublayer:bottomLine];
    
    
    
    
    
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    
    
    userNameLabel.frame = CGRectMake(H_GAP*2+IMAGE_HEIGHT, (CELL_HEIGHT-userNameLabel.height)/2, userNameLabel.width, userNameLabel.height);
    infoLabel.frame = CGRectMake(self.contentView.width - H_GAP*2 - infoLabel.width, (CELL_HEIGHT-infoLabel.height)/2, infoLabel.width, infoLabel.height);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
+(CGFloat)cellHeight{
    return CELL_HEIGHT;
}

-(void)setCellDto:(TLGroupDataDTO*)cellData{
    _cellData = cellData;
    [self refrashUI];
}

-(void)refrashUI{
    NSString *bgImageUrl = [NSString stringWithFormat:@"%@%@",TL_SERVER_BASE_URL,self.cellData.groupIcon];
    [cellImage sd_setImageWithURL:[NSURL URLWithString:bgImageUrl] placeholderImage:[UIImage imageNamed:@"ico_loading_logo"]];
    
    userNameLabel.text = self.cellData.groupName;
    [userNameLabel setWidth:[self.cellData.groupName sizeWithAttributes:@{NSFontAttributeName:FONT_16B}].width];
    
    if (self.cellData.join.integerValue==1) {
        infoLabel.text = @"已加入";
        [infoLabel setWidth:[infoLabel.text sizeWithAttributes:@{NSFontAttributeName:FONT_16B}].width];
    }else{
        infoLabel.text = @"";
        [infoLabel setWidth:[infoLabel.text sizeWithAttributes:@{NSFontAttributeName:FONT_16B}].width];
    }
    
    
    
}

@end
