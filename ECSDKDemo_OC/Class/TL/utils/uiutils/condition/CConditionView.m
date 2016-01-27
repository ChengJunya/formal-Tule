//
//  CConditionView.m
//  ContractManager
//
//  Created by Rainbow on 12/19/14.
//  Copyright (c) 2014 BONC. All rights reserved.
//

#import "CConditionView.h"
#import "CDataPickerView.h"
#import "CCalanderPickerView.h"
#import "CConditionBasicView.h"
#import "RUtiles.h"
@implementation CConditionView
@synthesize conditionsDataArray=_conditionsDataArray,conditionArray=_conditionArray,isContentHidden=_isContentHidden,ConditionConfirmBlock=_ConditionConfirmBlock;

-(instancetype)initWithFrame:(CGRect)frame conditionsDataArray:(NSArray*)conditionsDataArray{
    self = [super initWithFrame:frame];
    if (self) {
        self.btnArray = [[NSMutableArray alloc] init];
        self.isContentHidden = YES;
        self.conditionsDataArray = conditionsDataArray;
        self.conditionArray = [[NSMutableArray alloc] init];
        [self setBackgroundColor:[UIColor whiteColor]];
        [self initConditions:frame];
    }
    return self;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        
    }
    return self;
}

-(void)initConditions:(CGRect)rect{
    
    CGFloat itemHeight = C_CONDITION_HEIGHT;
    CGFloat itemWidth = CGRectGetWidth(rect)/[self.conditionsDataArray count];
    
    [self.conditionsDataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *type = [obj valueForKey:@"type"];
        UIButton *itemBtn = [[UIButton alloc] initWithFrame:CGRectMake(itemWidth*idx, 0.0f, itemWidth, itemHeight)];
        itemBtn.tag = idx+300;
        [self setBtnBackgroundColor:itemBtn selected:itemBtn.selected];
        //selectedId selectedName
        [itemBtn setTitle:[obj valueForKey:@"selectedName"] forState:UIControlStateNormal];
        [itemBtn addTarget:self action:@selector(itemSelectHandler:) forControlEvents:UIControlEventTouchUpInside];
        [itemBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        NSString *selectedId = [obj valueForKey:@"selectedId"];
        NSString *selectedName = [obj valueForKey:@"selectedName"];
        NSString *paramKey = [obj valueForKey:@"paramKey"];
        
        NSDictionary *selectedData = [NSDictionary dictionaryWithObjectsAndKeys:selectedId,@"id",selectedName,@"name",paramKey,@"paramKey", nil];
        

        
        [self addSubview:itemBtn];
        
        [self.btnArray addObject:itemBtn];
        
        if ([@"date" isEqualToString:type]) {
                NSDate *currentDate = [NSDate new];
             NSString *defaultDate = [RUtiles stringFromDateWithFormat:currentDate format:self.dateFormat];
            CCalanderPickerView *datePicker = [[CCalanderPickerView alloc] initWithFrameData:CGRectMake(0.0, 0.f, CGRectGetWidth(rect), CGRectGetHeight(rect)-C_OK_BTN_HEIGHT) itemData:@{@"id":@"1",@"type":@"date",@"selectedId":defaultDate,@"selectedName":defaultDate,@"data":@[],@"paramKey":@"accDay"} dateFormat:self.dateFormat];
            [datePicker setSelectBtn:itemBtn];
            [datePicker setSelectedItem:selectedData];
            [self.conditionArray addObject:datePicker];
        }else if ([@"combobox" isEqualToString:type]) {
           
            CDataPickerView *selectPickView = [[CDataPickerView alloc] initWithFrameData:CGRectMake(0.0f, C_CONDITION_HEIGHT, CGRectGetWidth(rect), C_CONDITION_CONTENT_HEIGHT) itemData:obj];
            [selectPickView setSelectBtn:itemBtn];
            [selectPickView setSelectedItem:selectedData];
            [self.conditionArray addObject:selectPickView];

        }
        


        
        
    }];
    
    UIButton *okBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, CGRectGetHeight(rect)-C_OK_BTN_HEIGHT, CGRectGetWidth(rect)/2, C_OK_BTN_HEIGHT)];
    [self setBtnBackgroundColor:okBtn selected:okBtn.selected];
    [okBtn setTitle:@"确定" forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(okBtnHandler:) forControlEvents:UIControlEventTouchUpInside];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self addSubview:okBtn];
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(rect)/2, CGRectGetHeight(rect)-C_OK_BTN_HEIGHT, CGRectGetWidth(rect)/2, C_OK_BTN_HEIGHT)];
    [self setBtnBackgroundColor:cancelBtn selected:cancelBtn.selected];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnHander:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self addSubview:cancelBtn];
    
}



-(void)setBtnBackgroundColor:(UIButton*)btn selected:(BOOL)selected{
    if (selected) {
        btn.layer.backgroundColor = [UIColor colorWithRed:0 green:122/255.0 blue:255/255.0 alpha:1].CGColor;
        btn.layer.borderWidth = 1.0f;
        btn.layer.borderColor = UIColorFromRGB(0xffa800).CGColor;
        
    }else{
        btn.layer.backgroundColor = [UIColor colorWithRed:0 green:122/255.0 blue:255/255.0 alpha:1].CGColor;
        btn.layer.borderWidth = 1.0f;
        btn.layer.borderColor = [UIColor whiteColor].CGColor;
    }
}


-(void)okBtnHandler:(UIButton *)btn{
    [self showHideContentView];
    __block BOOL goFlag = NO;
    
    NSMutableArray *items = [[NSMutableArray alloc] init];
    
    [self.conditionArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CConditionBasicView *conditionView = obj;
        
        [conditionView ok];
        
        if ([@"-1" isEqualToString:[conditionView.selectedItem valueForKey:@"id"]]&&[@"userId" isEqualToString:[conditionView.selectedItem valueForKey:@"paramKey"]]) {
            [RUtiles alert:@"提示" info:@"请选择派发人员"];
            goFlag = NO;
            return;
        }else{
            goFlag = YES;
        }
        [items addObject:conditionView.selectedItem];
        NSLog(@"当前选中值：%@",[conditionView selectedItem]);
    }];
    
    if (goFlag) {
        if(self.ConditionConfirmBlock){
            self.ConditionConfirmBlock([items copy]);
        }
    }
    
    
}


-(void)cancelBtnHander:(UIButton *)btn{
    [self showHideContentView];
    
    [self.conditionArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CConditionBasicView *conditionView = obj;

        [conditionView cancel];
    }];
    
}

-(void)showHideContentView{
    if (self.isContentHidden) {
        return;
    }
    self.isContentHidden = YES;
    CGRect toFrame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame)+C_CONDITION_CONTENT_HEIGHT+C_OK_BTN_HEIGHT, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    //动画设置高度
    [UIView animateWithDuration:0.5f animations:^{
        self.frame = toFrame;
    }];
    
    [self.btnArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton *tmpBtn = obj;
        [tmpBtn setSelected:NO];
        [self setBtnBackgroundColor:tmpBtn selected:NO];
    }];
}

-(void)itemSelectHandler:(UIButton *)btn{
    
    if (self.isContentHidden) {
        CGRect toFrame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame)-C_CONDITION_CONTENT_HEIGHT-C_OK_BTN_HEIGHT, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        
        //动画设置高度
        [UIView animateWithDuration:0.5f animations:^{
            self.frame = toFrame;
        }];
        self.isContentHidden = NO;
    }
    
    
    [self.btnArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton *tmpBtn = obj;
        if(tmpBtn.tag == btn.tag){
            [btn setSelected:YES];
            [self setBtnBackgroundColor:btn selected:YES];

            
        }else{
            [tmpBtn setSelected:NO];
            [self setBtnBackgroundColor:tmpBtn selected:NO];
        }
    }];
    
    
    if (self.currentView!=nil) {
        [self.currentView removeFromSuperview];
    }
    
    CConditionBasicView *view = [self.conditionArray objectAtIndex:btn.tag-300];
    [self addSubview:view];
    self.currentView = view;
    
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


@end
