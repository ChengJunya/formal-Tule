//
//  TLFormItem.m
//  TL
//
//  Created by Rainbow on 2/16/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "TLFormItem.h"

@interface TLFormItem(){
    UILabel *nameLabel;
    UILabel *valueLabel;
}

@end

@implementation TLFormItem

- (instancetype)initWithFrame:(CGRect)frame itemData:(id)itemData
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGBA(0xFFFFFF, 0.5);
        self.itemData = itemData;
        
        [self setupView];
    }
    return self;
}

-(void)setupView{
    
    CGFloat leftWidth = 100.f;
    CGFloat rightWidth = CGRectGetWidth(self.frame)-leftWidth;
    CGFloat hGap = 10.f;
    CGFloat vGap = 10.f;
    CGFloat lableValueWidth = rightWidth-hGap*2;
    CGFloat lableNameWidth = leftWidth-hGap*2;
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:FONT_14,NSFontAttributeName ,nil];
    NSString *lableName = [self.itemData valueForKey:@"LABEL_NAME"];
    CGSize lableNameSize = [lableName sizeWithAttributes:dic];
    NSString *lableValue = [self.itemData valueForKey:@"LABEL_VALUE"];
    
    
    
    CGRect lableValueRectSize = [lableValue boundingRectWithSize:CGSizeMake(lableValueWidth,1000) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin) attributes:dic context:nil];
    //self.bounds = CGRectMake(0.f, 0.f, CGRectGetWidth(self.frame), CGRectGetHeight(lableValueRectSize)+vGap*2);
    self.itemFrame = CGRectMake(self.frame.origin.x, self.frame.origin.y, CGRectGetWidth(self.frame), CGRectGetHeight(lableValueRectSize)+vGap*2);
    
    
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(hGap, vGap, lableNameWidth, lableNameSize.height)];
    nameLabel.font = FONT_14;
    nameLabel.text = lableName;
    nameLabel.textColor = COLOR_MAIN_TEXT;
    [self addSubview:nameLabel];
    
    valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftWidth+hGap, vGap, lableValueWidth, CGRectGetHeight(lableValueRectSize))];
    valueLabel.font = FONT_14;
    valueLabel.text = lableValue;
    valueLabel.textColor = COLOR_MAIN_TEXT;
    valueLabel.numberOfLines = 0;
    [self addSubview:valueLabel];
    
    
    
    
    
    
}


-(void)setNameStr:(NSString *)nameStr{
    _nameStr = nameStr;
    nameLabel.text = _nameStr;
}

-(void)setValueStr:(NSString *)valueStr{
    _valueStr = valueStr;
    valueLabel.text = _valueStr;
}
@end
