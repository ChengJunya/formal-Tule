//
//  CSelectView.m
//  TL
//
//  Created by Rainbow on 2/17/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "CSelectView.h"
#import "CDataPickerView.h"

@interface CSelectView()
@property (nonatomic,assign) BOOL isContentHidden;
@property (nonatomic,strong) CDataPickerView *picker;
@end
@implementation CSelectView



- (instancetype)initWithFrame:(CGRect)frame itemData:(id)itemData
{
    self = [super initWithFrame:frame];
    if (self) {
        ////itemData: ==== @{@"id":@"1",@"type":@"select",@"selectedId":defaultDate,@"selectedName":defaultDate,@"data":@[@{@"id":@"1",@"name":@"10-20"},@{@"id":@"2",@"name":@"20-30"},@{@"id":@"3",@"name":@"30-40"}],@"paramKey":@"accDay"}

        self.itemData = itemData;
        self.layer.borderWidth = 1.0f;
        self.layer.borderColor = [UIColor grayColor].CGColor;
        self.backgroundColor = [UIColor whiteColor];
        
        self.isContentHidden = YES;

        
    
        self.picker = [[CDataPickerView alloc] initWithFrameData:CGRectMake(0.0, 0.0, CGRectGetWidth(frame), CGRectGetHeight(frame)-C_OK_BTN_HEIGHT) itemData:self.itemData];
        
        [self addSubview:self.picker];
        
        
        
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
-(void)setSelectedData:(id)data{
    NSUInteger selectIndex = [[data valueForKey:@"SELECT_INDEX"] intValue];
    [self.picker.pickerView selectRow:selectIndex inComponent:0 animated:NO];
    self.picker.currentSelectedItem = [self.picker.pickerDataArray objectAtIndex:selectIndex];
}

-(void)okBtnHandler:(UIButton *)btn{
    [self showHideContentView];
    [self.picker ok];
    NSDictionary *selectedItem = [self.picker selectedItem];
    if (self.OkBlock) {
        
        self.OkBlock(selectedItem);
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


@end
