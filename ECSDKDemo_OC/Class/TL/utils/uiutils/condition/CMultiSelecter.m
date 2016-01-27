//
//  CMultiSelecter.m
//  TL
//
//  Created by Rainbow on 3/31/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "CMultiSelecter.h"
#import "RUtiles.h"
#import "CMultySelectView.h"
@interface CMultiSelecter(){
    
}
@property (nonatomic,assign) BOOL isContentHidden;
@property (nonatomic,strong) CMultySelectView *selectView;

@end

@implementation CMultiSelecter

- (instancetype)initWithFrame:(CGRect)frame itemData:(id)itemData
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.borderWidth = 1.0f;
        self.layer.borderColor = [UIColor grayColor].CGColor;
        self.backgroundColor = [UIColor whiteColor];
        
        self.isContentHidden = YES;
        CGFloat selectViewWidth = 120.f;
        self.selectView = [[CMultySelectView alloc] initWithFrame:CGRectMake((CGRectGetWidth(frame)-selectViewWidth)/2, 0.0, selectViewWidth, CGRectGetHeight(frame)-C_OK_BTN_HEIGHT)];
        self.selectView.dataArray = [itemData valueForKey:@"data"];
        [self.selectView addViews];
        [self addSubview:self.selectView];
        
        
        
        UIButton *okBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, CGRectGetHeight(frame)-C_OK_BTN_HEIGHT, CGRectGetWidth(frame)/2, C_OK_BTN_HEIGHT)];
        [self setBtnBackgroundColor:okBtn selected:okBtn.selected];
        [okBtn setTitle:@"确定" forState:UIControlStateNormal];
        [okBtn addTarget:self action:@selector(okBtnHandler:) forControlEvents:UIControlEventTouchUpInside];
        [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [self addSubview:okBtn];
        
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(frame)/2, CGRectGetHeight(frame)-C_OK_BTN_HEIGHT, CGRectGetWidth(frame)/2, C_OK_BTN_HEIGHT)];
        [self setBtnBackgroundColor:cancelBtn selected:cancelBtn.selected];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelBtnHander:) forControlEvents:UIControlEventTouchUpInside];
        [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [self addSubview:cancelBtn];
    }
    return self;
}




-(void)setBtnBackgroundColor:(UIButton*)btn selected:(BOOL)selected{
    if (selected) {
        btn.layer.backgroundColor = [COLOR_TAB_BG_P CGColor];
        btn.layer.borderWidth = 0.5f;
        btn.layer.borderColor = UIColorFromRGB(0xffffff).CGColor;
        
    }else{
        btn.layer.backgroundColor = [COLOR_TAB_BG_P CGColor];
        btn.layer.borderWidth = 0.5f;
        btn.layer.borderColor = UIColorFromRGB(0xffffff).CGColor;
    }
}
-(void)setSelectedDate:(NSDate*)date{

    
}

-(void)okBtnHandler:(UIButton *)btn{
    [self showHideContentView];

    NSString *selectedItem = [self.selectView getSelectedIds];
    NSString *selectedNames = [self.selectView getSelectedNames];
    if (self.OkBlock) {
        
        self.OkBlock(@{@"id":selectedItem,@"name":selectedNames});
    }
}


-(void)cancelBtnHander:(UIButton *)btn{
    [self showHideContentView];
    
    
}

-(void)showContentView{
    if (!self.isContentHidden) {
        return;
    }
    self.isContentHidden = NO;
    CGRect toFrame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame)-CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    //动画设置高度
    [UIView animateWithDuration:0.5f animations:^{
        self.frame = toFrame;
    }];
}

-(void)showHideContentView{
    if (self.isContentHidden) {
        return;
    }
    self.isContentHidden = YES;
    CGRect toFrame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame)+CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    //动画设置高度
    [UIView animateWithDuration:0.5f animations:^{
        self.frame = toFrame;
    }];
    
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */


@end
