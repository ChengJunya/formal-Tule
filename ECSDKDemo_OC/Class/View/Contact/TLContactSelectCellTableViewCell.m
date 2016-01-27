//
//  TLContactSelectCellTableViewCell.m
//  TL
//
//  Created by YONGFU on 5/19/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "TLContactSelectCellTableViewCell.h"

#import "RUILabel.h"
#define CELL_HEIGHT 66.f
#define IMAGE_HEIGHT 60.f
#define H_GAP 15.f
#define V_GAP 3.f
@interface TLContactSelectCellTableViewCell(){
    UIImageView *cellImage;
    UIImageView *selectImage;
    RUILabel *userNameLabel;
//    RUILabel *infoLabel;
    CALayer *bottomLine;
}

@end

@implementation TLContactSelectCellTableViewCell

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
    
    

    selectImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.contentView.width-CELL_HEIGHT, CELL_HEIGHT/4, CELL_HEIGHT/2, CELL_HEIGHT/2)];
    [self.contentView addSubview:selectImage];
    
    
    
    userNameLabel = [[RUILabel alloc] initWithFrame:CGRectZero str:@"" font:FONT_16B color:COLOR_MAIN_TEXT];
    [self.contentView addSubview:userNameLabel];
    
    
    
//    infoLabel = [[RUILabel alloc] initWithFrame:CGRectZero str:@"" font:FONT_16 color:COLOR_MAIN_TEXT];
//    [self.contentView addSubview:infoLabel];
    
    
    bottomLine = [CALayer layer];
    bottomLine.backgroundColor = UIColorFromRGBA(0xCCCCCC, 0.5).CGColor;
    [self.contentView.layer addSublayer:bottomLine];
    
    
    
    
    
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    if (self.cellData.isSelected.integerValue==1) {
        selectImage.image = [UIImage imageNamed:@"tl_contact_selected"];
    }else{
        selectImage.image = [UIImage imageNamed:@"tl_contact_unselected"];
    }
    
    userNameLabel.frame = CGRectMake(H_GAP*2+IMAGE_HEIGHT, (CELL_HEIGHT-userNameLabel.height)/2, userNameLabel.width, userNameLabel.height);
//    infoLabel.frame = CGRectMake(self.contentView.width - H_GAP*2 - infoLabel.width, (CELL_HEIGHT-infoLabel.height)/2, infoLabel.width, infoLabel.height);
}


+(CGFloat)cellHeight{
    return CELL_HEIGHT;
}

-(void)setCellDto:(TLSimpleUserDTO*)cellData{
    _cellData = cellData;
    [self refrashUI];
}

-(void)refrashUI{
    NSString *bgImageUrl = [NSString stringWithFormat:@"%@%@",TL_SERVER_BASE_URL,self.cellData.userIcon];
    [cellImage sd_setImageWithURL:[NSURL URLWithString:bgImageUrl] placeholderImage:[UIImage imageNamed:@"ico_loading_logo"]];
    
    userNameLabel.text = self.cellData.userName;
    [userNameLabel setWidth:[self.cellData.userName sizeWithAttributes:@{NSFontAttributeName:FONT_16B}].width];
    
    
    
    
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
   
    
}


@end
