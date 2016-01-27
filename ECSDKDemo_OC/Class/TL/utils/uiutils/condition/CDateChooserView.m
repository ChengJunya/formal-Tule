//
//  CDateChooserView.m
//  BIBuilderApp
//
//  Created by Rainbow on 2/2/15.
//  Copyright (c) 2015 Bonc. All rights reserved.
//

#import "CDateChooserView.h"
#import "CCalanderPickerView.h"
#import "RUtiles.h"
@interface CDateChooserView()
@property (nonatomic,assign) BOOL isContentHidden;
@property (nonatomic,strong) CCalanderPickerView *picker;

@end

@implementation CDateChooserView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.dateFormat = @"yyyy-MM-dd HH:mm";
        self.dateChoserType = 3;//1-time 2-date 3-datetime
        [self setupViews:frame];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame dateFormat:(NSString*)format dateChoserType:(NSInteger)dateChoserType
{
    self = [super initWithFrame:frame];
    if (self) {
        self.dateFormat = format;
        self.dateChoserType = dateChoserType;
        [self setupViews:frame];

    }
    return self;
}


-(void)setupViews:(CGRect)frame{
    self.layer.borderWidth = 1.0f;
    self.layer.borderColor = [UIColor grayColor].CGColor;
    self.backgroundColor = [UIColor whiteColor];
    
    
    
    
    self.isContentHidden = YES;
    NSDate *currentDate = [NSDate new];
    
    NSString *defaultDate = [RUtiles stringFromDateWithFormat:currentDate format:self.dateFormat];
    self.picker = [[CCalanderPickerView alloc] initWithFrameData:CGRectMake(0.0, 0.f, CGRectGetWidth(frame), CGRectGetHeight(frame)-C_OK_BTN_HEIGHT) itemData:@{@"id":@"1",@"type":@"date",@"selectedId":defaultDate,@"selectedName":defaultDate,@"data":@[],@"paramKey":@"accDay"} dateFormat:self.dateFormat];
    
    [self addSubview:self.picker];
    
    switch (self.dateChoserType) {
        case 1:
        {
            self.picker.datePicker.datePickerMode = UIDatePickerModeTime;//模式
            break;
        }
        case 2:
        {
               self.picker.datePicker.datePickerMode = UIDatePickerModeDate;//模式
            break;
        }
        case 3:
        {
               self.picker.datePicker.datePickerMode = UIDatePickerModeDateAndTime;//模式
            break;
        }
        default:
            break;
    }
    
    
    
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
    [self.picker.datePicker setDate:date];
    self.picker.selectedTimeLabel.text = [RUtiles stringFromDateWithFormat:date format:self.dateFormat];
    //self.picker.currentSelectedItem = @{@"id":@"1",@"type":@"date",@"selectedId":self.picker.selectedTimeLabel.text,@"selectedName":self.picker.selectedTimeLabel.text,@"data":@[],@"paramKey":@"accDay"};
    
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
    //[self showHideContentView];
    if (self.CancelBlock) {
        NSDictionary *selectedItem = [self.picker selectedItem];
        
        self.CancelBlock(selectedItem);
    }
    
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
