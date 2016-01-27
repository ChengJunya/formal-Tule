//
//  RRadioBtn.m
//  BIBuilderApp
//
//  Created by Rainbow on 1/24/15.
//  Copyright (c) 2015 Bonc. All rights reserved.
//

#import "RRadioBtn.h"
#import "RImageBtn.h"

@interface RRadioBtn()
@property(nonatomic,strong)RImageBtn *imageBtn;
@end
@implementation RRadioBtn

@synthesize itemData=_itemData;
- (instancetype)initWithFrame:(CGRect)frame itemData:(NSDictionary*)itemData
{
    self = [super initWithFrame:frame];
    if (self) {
        self.itemData = itemData;
        NSString *normalImage = [itemData valueForKey:@"btnImage"];
        NSString *selectedImage = [itemData valueForKey:@"selectedImage"];
        NSString *radioName = [itemData valueForKey:@"name"];

        
        
        CGFloat vGap = 2.0f;
        CGFloat hGap = 10.0f;
        CGFloat imageHeight = CGRectGetHeight(frame)-vGap*2;
        
        self.imageBtn = [[RImageBtn alloc] initWithFrameImageStateTitle:CGRectMake(hGap, vGap, imageHeight, imageHeight) btnImage:normalImage selectedImage:selectedImage highLightedImage:selectedImage btnTitle:@""];
//        [self.imageBtn addTarget:self action:@selector(imageBtnHandler:) forControlEvents:UIControlEventTouchUpInside];
        self.imageBtn.userInteractionEnabled = NO;
        [self addSubview:self.imageBtn];


        
        UILabel *radioNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageHeight+hGap*2, vGap, CGRectGetWidth(frame)-hGap*3-imageHeight, imageHeight)];
        radioNameLabel.text = radioName;
        radioNameLabel.textColor = [UIColor whiteColor];
        [self addSubview:radioNameLabel];
    }
    return self;
}



-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    self.imageBtn.selected = selected;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
