//
//  BoncDataGridHeaderView.m
//  TableViewGridTest
//
//  Created by Rainbow on 12/2/14.
//  Copyright (c) 2014 Rainbow. All rights reserved.
//

#import "BoncDataGridHeaderView.h"
#import "BoncUtils.h"

@implementation BoncDataGridHeaderView

@synthesize headerData=_headerData,delegate=_delegate;




-(instancetype)initWithFrame:(CGRect)frame{
    self =  [super initWithFrame:frame];
    if(self){
        
        self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    /*
     1，画header背景
     2，画header边框
     3，循环数据
     4, 画名称
     
     headerData:{header:[{CODE:'ID',NAME:'序列',WIDHT:'80'},{CODE:'KPINAME',NAME:'KPI名称',WIDHT:'80'},{CODE:'DESC',NAME:'KPI描述',WIDHT:'80'}],headerHeight:'40',spliteColor:'#FF00FF',borderColor:'#FFF000',backgroundColor:'#FFFF00','borderWidthStr':'1'}
     
     */
    
    
    UIColor *borderColor = [self.headerData valueForKey:@"borderColor"]?[BoncUtils colorWithHexString:[self.headerData valueForKey:@"borderColor"] alpha:1.0f]:[BoncUtils  colorWithHexString:GRID_HEADER_BORDER_COLOR alpha:1.0f];
    
    UIColor *spliteColor = [self.headerData valueForKey:@"spliteColor"]?[BoncUtils colorWithHexString:[self.headerData valueForKey:@"spliteColor"] alpha:1.0f]:[BoncUtils  colorWithHexString:GRID_HEADER_BORDER_COLOR alpha:1.0f];
    
     UIColor *backgroundColor = [self.headerData valueForKey:@"backgroundColor"]?[BoncUtils colorWithHexString:[self.headerData valueForKey:@"backgroundColor"] alpha:1.0f]:[BoncUtils  colorWithHexString:GRID_HEADER_BORDER_COLOR alpha:1.0f];
    
    UIColor *fontColor = [self.headerData valueForKey:@"color"]?[BoncUtils colorWithHexString:[self.headerData valueForKey:@"color"] alpha:1.0f]:[BoncUtils  colorWithHexString:GRID_HEADER_COLOR alpha:1.0f];
    
    NSString *headerHeightStr = [self.headerData valueForKey:@"headerHeight"]?[self.headerData valueForKey:@"headerHeight"]:GRID_HEADER_HEIGHT;
    
    
     NSString *borderWidthStr = [self.headerData valueForKey:@"borderWidth"]?[self.headerData valueForKey:@"borderWidth"]:GRID_HEADER_BORDER_WIDTH;
    
    NSString *headerFontSize = [self.headerData valueForKey:@"fontSize"]?[self.headerData valueForKey:@"fontSize"]:GRID_HEADER_FONT_SIZE;
    
    NSString *fontStr = [self.headerData valueForKey:@"font"]?[self.headerData valueForKey:@"font"]:GRID_HEADER_FONT;
    
    NSString *isAutoColumnWidthStr = [self.headerData valueForKey:@"isAutoColumnWidth"]?[self.headerData valueForKey:@"isAutoColumnWidth"]:IS_AUTO_COLOUMN_WIDTH;
    BOOL isAutoColumnWidth = [@"1" isEqualToString:isAutoColumnWidthStr]?YES:NO;
    
    
    
    
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = [borderWidthStr floatValue];
    self.layer.backgroundColor = backgroundColor.CGColor;
    CGFloat headerHeight = [headerHeightStr floatValue];
    
   
    NSArray *headerData = [self.headerData valueForKey:@"header"];
    
     __block CGFloat xValue = 0;
    __block CGFloat totalWidth = 0;
    
    
    //计算实际文字的总宽度-用于自动计算列宽 把显示字段的宽度计算
    [headerData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *headerName = [obj objectForKey:@"NAME"];
        int isShowFlag = [[obj objectForKey:@"ISSHOW"] intValue];
        
        UIFont *font = [UIFont fontWithName:fontStr size:[headerFontSize floatValue]];
        NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
        CGSize headerNameSize  = [headerName sizeWithAttributes:dic];
        //字段是显示的计算进去
        if (isShowFlag==1) {
                totalWidth = totalWidth + headerNameSize.width;
        }
        
        
        
    }];
    
    
    //自动计算列宽
    [headerData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        
        int isShowFlag = [[obj objectForKey:@"ISSHOW"] intValue];
        if (isShowFlag==1) {
            
        
        
           //循环
            NSString *headerCode = [obj objectForKey:@"CODE"];
            NSString *headerName = [obj objectForKey:@"NAME"];
            NSString *headerColumnWidthStr = [obj objectForKey:@"WIDHT"];
            
            
            
            
            float headerColumnWidth = [headerColumnWidthStr floatValue];
            
            NSLog(@"headerCode:%@,headerName:%@,headerWidth:%@",headerCode,headerName,headerColumnWidthStr);
            
           
            
            UIFont *font = [UIFont fontWithName:fontStr size:[headerFontSize floatValue]];
            
            NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,fontColor,NSForegroundColorAttributeName, nil];
            
            CGSize headerNameSize  = [headerName sizeWithAttributes:dic];
            CGRect headerNameRect;
            
            //获取宽度自动计算每一列的宽度
            if (isAutoColumnWidth) {
                //自动计算列宽
                headerColumnWidth = (CGRectGetWidth(rect)-C_COLUMN_BTN_WIDTH)*headerNameSize.width/totalWidth;

            }
            
            if (idx==[headerData count]-1) {
                
                headerNameRect = CGRectMake(xValue+(headerColumnWidth-headerNameSize.width)/2,(headerHeight-headerNameSize.height)/2, CGRectGetWidth(rect)- xValue, headerNameSize.height);
            }else{
                
                    headerNameRect = CGRectMake(xValue+(headerColumnWidth-headerNameSize.width)/2,(headerHeight-headerNameSize.height)/2, headerNameSize.width, headerNameSize.height);
            
                xValue = xValue +headerColumnWidth;

                //画分割线
                CALayer *spliteLayer = [CALayer layer];
                spliteLayer.backgroundColor = spliteColor.CGColor;
                [spliteLayer setFrame:CGRectMake(xValue, 0, 1, headerHeight)];
                [self.layer addSublayer:spliteLayer];
            }
            
            
            [headerName drawInRect:headerNameRect withAttributes:dic];
        }
        
    }];
   
    
    
    self.showBtn = [[RImageBtn alloc] initWithFrameImageTitle:CGRectMake(CGRectGetWidth(rect)-30.0f, 0.0f, 30, CGRectGetHeight(rect)) btnImage:@"navigation.png" btnTitle:@""];

    [self setBtnBackgroundColor:self.showBtn selected:self.showBtn.selected];
    //[self.showBtn setTitle:@"目" forState:UIControlStateNormal];
    [self.showBtn addTarget:self action:@selector(showBtnHandler:) forControlEvents:UIControlEventTouchUpInside];
    //[self.showBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self addSubview:self.showBtn];
    
    
    

}

-(void)showBtnHandler:(UIButton*)btn{

    //[self setBtnBackgroundColor:self.showBtn selected:self.showBtn.selected];
    if([self.delegate respondsToSelector:@selector(isShowSelectColumnBtnSelected:)] == YES )
    {
        [self.delegate isShowSelectColumnBtnSelected:btn.selected];
    }
}


-(void)setBtnBackgroundColor:(UIButton*)btn selected:(BOOL)selected{
    if (selected) {
        btn.layer.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:159.0/255.0 blue:248.0/255.0 alpha:0.5].CGColor;
        btn.layer.borderWidth = 1.0f;
        btn.layer.borderColor = [UIColor whiteColor].CGColor;
        
    }else{
        btn.layer.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:159.0/255.0 blue:248.0/255.0 alpha:0.5].CGColor;
        btn.layer.borderWidth = 1.0f;
        btn.layer.borderColor = [UIColor whiteColor].CGColor;
    }
}


@end
