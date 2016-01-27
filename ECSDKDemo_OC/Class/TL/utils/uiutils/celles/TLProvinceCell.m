//
//  TLProvinceCell.m
//  TL
//
//  Created by Rainbow on 2/10/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "TLProvinceCell.h"
#import "TLProvinceDTO.h"
@interface TLProvinceCell()
@property (nonatomic,strong) UILabel *nameLabel;
@end
@implementation TLProvinceCell


-(void)initContent{
    //titlebox
    //contentbox
    TLProvinceDTO * cellDTO = self.cellData;
    CGFloat cellTempHeight = 40.f;
    
    if (self.cellContentView) {
        [self.cellContentView removeFromSuperview];
        self.cellContentView = nil;
    }
    
    self.cellContentView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.width, cellTempHeight)];
    [self addSubview:self.cellContentView];
    self.cellContentView.backgroundColor = [UIColor clearColor];
    
    NSString *nameStr = cellDTO.provinceName;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:FONT_16,NSFontAttributeName ,nil];
    CGSize nameStrSize = [nameStr sizeWithAttributes:dic];
    
    
    
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.f,(self.cellContentView.height-nameStrSize.height)/2, nameStrSize.width, nameStrSize.height)];
    _nameLabel.text = nameStr;
    _nameLabel.textColor = COLOR_MAIN_TEXT;
    _nameLabel.font = FONT_16;
    [self.cellContentView addSubview:_nameLabel];
    
    
    
    
    self.cellHeight = cellTempHeight;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    //[super setSelected:selected animated:animated];

    
    if (selected) {
        self.backgroundColor = UIColorFromRGB(0xCCCCCC);
        _nameLabel.textColor = COLOR_ORANGE_TEXT;
        //[self action];
        
    }else{
        self.backgroundColor = [UIColor clearColor];
        _nameLabel.textColor = COLOR_MAIN_TEXT;
    }
    
}


@end
