//
//  TLUpdateFormItem.m
//  TL
//
//  Created by Rainbow on 2/26/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "TLUpdateFormItem.h"

@interface TLUpdateFormItem(){
    UITextField *valueTextField;
}

@end

@implementation TLUpdateFormItem


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
    NSString *placeHolder = [self.itemData valueForKey:@"PLACE_HOLDER"];
    
    
    CGRect lableValueRectSize = [lableValue boundingRectWithSize:CGSizeMake(lableValueWidth,1000) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin) attributes:dic context:nil];
    //self.bounds = CGRectMake(0.f, 0.f, CGRectGetWidth(self.frame), CGRectGetHeight(lableValueRectSize)+vGap*2);
    self.itemFrame = CGRectMake(self.frame.origin.x, self.frame.origin.y, CGRectGetWidth(self.frame), CGRectGetHeight(lableValueRectSize)+vGap*2);
    
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(hGap, vGap, lableNameWidth, lableNameSize.height)];
    nameLabel.font = FONT_14;
    nameLabel.text = lableName;
    nameLabel.textColor = COLOR_MAIN_TEXT;
    [self addSubview:nameLabel];
    
    self.rightView = [[UIView alloc ] initWithFrame:CGRectMake(leftWidth+hGap, vGap, lableValueWidth, CGRectGetHeight(lableValueRectSize))];
    
//    UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftWidth+hGap, vGap, lableValueWidth, CGRectGetHeight(lableValueRectSize))];
//    valueLabel.font = FONT_14;
//    valueLabel.text = lableValue;
//    valueLabel.textColor = COLOR_MAIN_TEXT;
//    valueLabel.numberOfLines = 0;
//    [self addSubview:valueLabel];
    [self addSubview:self.rightView];
    
    
    valueTextField = [[UITextField alloc] initWithFrame:CGRectMake(0.f, 0.f, lableValueWidth, CGRectGetHeight(lableValueRectSize))];
    valueTextField.placeholder = placeHolder;
    valueTextField.text = lableValue;
    valueTextField.font = FONT_14;
    valueTextField.textColor = COLOR_MAIN_TEXT;
    [self.rightView addSubview:valueTextField];
}

- (NSString *)updateValue{
    return valueTextField.text;
}

@end
