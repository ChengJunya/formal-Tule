//
//  TLContactCell.m
//  TL
//
//  Created by Rainbow on 3/1/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "TLContactCell.h"
#import "RUILabel.h"
#import "TLSimpleUserDTO.h"
@implementation TLContactCell

-(void)initContent{
    

    //titlebox
    //contentbox
    
    CGFloat yOffSet = 0.f;
    CGFloat imageHeight =  60.f;
    CGFloat imageWidth = 60.f;
    
    
    if (self.cellContentView) {
        [self.cellContentView removeFromSuperview];
        self.cellContentView = nil;
    }
    
    self.cellContentView = [[UIView alloc] initWithFrame:self.bounds];
    self.cellContentView.backgroundColor = UIColorFromRGBA(0xFFFFFF, 1);
    [self addSubview:self.cellContentView];
    
    
    CGFloat vGap = 3.f;
    CGFloat hGap = 15.f;
    

    
    
    //
    //add image
    
   
    
    
    
    NSString *icon = [self.cellData valueForKey:@"userIcon"];
    NSString *bgImageUrl = [NSString stringWithFormat:@"%@%@",TL_SERVER_BASE_URL,icon];
    if (icon.length>0) {
        UIImageView *cellImage = [[UIImageView alloc] initWithFrame:CGRectMake(hGap, vGap, imageWidth, imageHeight)];
        cellImage.layer.borderColor = UIColorFromRGBA(0x000000, 0.5).CGColor;
        cellImage.layer.borderWidth = 0.5f;
         cellImage.backgroundColor = UIColorFromRGBA(0x000000, 0.5);
        //cellImage.alpha = 0.f;
        [self.cellContentView addSubview:cellImage];
        
        if ([@"10000" isEqualToString: [self.cellData valueForKey:@"itemId"] ]) {
            cellImage.image = [UIImage imageNamed:icon];
        }else{
            [cellImage sd_setImageWithURL:[NSURL URLWithString:bgImageUrl] placeholderImage:[UIImage imageNamed:@"ico_loading_logo"]];
        }
        
    }
    
    
    
    CGFloat paddingLeft = hGap;
    if (icon.length>0) {
        paddingLeft = hGap*2+imageWidth;
    }
    
    NSString *userName = [self.cellData valueForKey:@"userName"];
    RUILabel *userNameLabel = [[RUILabel alloc] initWithFrame:CGRectZero str:userName font:FONT_16B color:COLOR_MAIN_TEXT];
    userNameLabel.frame = CGRectMake(paddingLeft, (imageHeight+vGap*2-CGRectGetHeight(userNameLabel.frame))/2, CGRectGetWidth(userNameLabel.frame), CGRectGetHeight(userNameLabel.frame));
    [self.cellContentView addSubview:userNameLabel];
    
    
    
    NSString *tlUserName = [self.cellData valueForKey:@"tl10000Name"];
    if (tlUserName.length>0) {
        RUILabel *tlUserNameLabel = [[RUILabel alloc] initWithFrame:CGRectZero str:tlUserName font:FONT_16B color:COLOR_MAIN_TEXT];
        tlUserNameLabel.frame = CGRectMake(paddingLeft, vGap, CGRectGetWidth(tlUserNameLabel.frame), CGRectGetHeight(tlUserNameLabel.frame));
        [self.cellContentView addSubview:tlUserNameLabel];
    }
    
    
    NSString *tlUserSign = [self.cellData valueForKey:@"tl10000Sign"];
    if (tlUserSign.length>0) {
        RUILabel *tlUserSignLabel = [[RUILabel alloc] initWithFrame:CGRectZero str:tlUserSign font:FONT_14 color:COLOR_ASSI_TEXT];
        tlUserSignLabel.frame = CGRectMake(paddingLeft, self.cellContentView.height-tlUserSignLabel.height-vGap, CGRectGetWidth(tlUserSignLabel.frame), CGRectGetHeight(tlUserSignLabel.frame));
        [self.cellContentView addSubview:tlUserSignLabel];
    }
    
    
    
    
    NSString *distance = [self.cellData valueForKey:@"distance"];
    RUILabel *distanceLabel = [[RUILabel alloc] initWithFrame:CGRectZero str:distance font:FONT_16 color:COLOR_MAIN_TEXT];
    distanceLabel.frame = CGRectMake(CGRectGetWidth(self.cellContentView.frame)-hGap*2-CGRectGetWidth(distanceLabel.frame), (imageHeight+vGap*2-CGRectGetHeight(distanceLabel.frame))/2, CGRectGetWidth(distanceLabel.frame), CGRectGetHeight(distanceLabel.frame));
    [self.cellContentView addSubview:distanceLabel];
    
    yOffSet = vGap + imageHeight + vGap;
    CALayer *bottomLine = [CALayer layer];
    bottomLine.frame = CGRectMake(hGap, yOffSet-1, CGRectGetWidth(self.cellContentView.frame)-hGap*2, 1.f);
    bottomLine.backgroundColor = UIColorFromRGBA(0xCCCCCC, 0.5).CGColor;
    [self.cellContentView.layer addSublayer:bottomLine];
    
    
    
    self.cellHeight = vGap*2+imageHeight;
    
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    
    // Configure the view for the selected state
    if (selected) {
        NSLog(@"selected");
        self.backgroundColor = [UIColor clearColor];
        
        //[self action];
        
    }else{
        NSLog(@"unSelected");
        self.backgroundColor = [UIColor clearColor];
    }
    
}

@end
