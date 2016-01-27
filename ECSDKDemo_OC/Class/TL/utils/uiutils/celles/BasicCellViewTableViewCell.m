//
//  BasicCellViewTableViewCell.m
//  TL
//
//  Created by Rainbow on 2/7/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "BasicCellViewTableViewCell.h"

@implementation BasicCellViewTableViewCell
@synthesize cellHeight=_cellHeight,cellData=_cellData;
- (void)awakeFromNib {

}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
    }
    
    return self;
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self initContent];
}



//渲染内部视图
- (void)initContent{
    
    _cellHeight = 80.f;
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
    [super setFrame:frame];
    
}

@end
