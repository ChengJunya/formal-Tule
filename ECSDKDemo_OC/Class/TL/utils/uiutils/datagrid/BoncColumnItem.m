//
//  BoncColumnItem.m
//  TableViewGridTest
//
//  Created by Rainbow on 12/3/14.
//  Copyright (c) 2014 Rainbow. All rights reserved.
//

#import "BoncColumnItem.h"

@implementation BoncColumnItem

@synthesize code=_code;

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    if([self viewWithTag:12121]){
        [[self viewWithTag:12121] removeFromSuperview];
    }
    
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:11];
    UIColor *fontColor = [UIColor grayColor];
    
    NSString *columnText = [self.rowData valueForKey:self.code];
    
    UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
    label.text = columnText;
    label.tag = 12121;
    label.textAlignment = NSTextAlignmentCenter;
    //自动折行设置
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 0;
    label.font = font;
    [label setTextColor:fontColor];
    
    [self addSubview:label];
    
    
    
    
//    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,fontColor,NSForegroundColorAttributeName, nil];
//    
//    CGSize columnTextSize  = [columnText sizeWithAttributes:dic];
//    CGRect headerNameRect = CGRectMake((CGRectGetWidth(rect)-columnTextSize.width)/2,(CGRectGetHeight(rect)-columnTextSize.height)/2, columnTextSize.width, columnTextSize.height);
//    
    
    
    
        //画分割线
    
        CALayer *spliteLayer = [CALayer layer];
        spliteLayer.backgroundColor = [UIColor colorWithRed:12/255.0 green:12/255.0 blue:12/255.0 alpha:0.1].CGColor;
        [spliteLayer setFrame:CGRectMake(0, 0, 1, CGRectGetHeight(rect))];
        [self.layer addSublayer:spliteLayer];
    
    
    
    //[columnText drawInRect:headerNameRect withAttributes:dic];
    
}


@end
