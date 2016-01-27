//
//  CustomActionSheet.m
//  alijk
//
//  Created by zhangyang on 14-8-21.
//  Copyright (c) 2014年 zhongxin. All rights reserved.
//

#import "CustomActionSheet.h"
#define ActionSheetButtonHeight 40

@implementation CustomActionSheet

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithButtonTitles:(NSArray*)btnArr
{
    if (self = [super initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT)]) {
        self.backgroundColor = RGBColor(0, 0, 0, 0);
        _buttonArr = [[NSMutableArray alloc] init];
        _bottomHeight = btnArr.count*ActionSheetButtonHeight+(btnArr.count-1)*15+20*2;
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, DEVICE_HEIGHT, DEVICE_WIDTH, _bottomHeight)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_bottomView];
        
        for (int i=0; i<btnArr.count; i++) {
            NSString* title  =  btnArr[i];
            UIButton* btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
            [btn setTitle:title forState:(UIControlStateNormal)];
            [btn addTarget:self action:@selector(buttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
            [self addSubview:btn];
            if (i==0) {
                btn.frame = CGRectMake(UI_LAYOUT_MARGIN, 20, UI_COMM_BTN_WIDTH, ActionSheetButtonHeight);
            }else{
                btn.frame = CGRectMake(UI_LAYOUT_MARGIN, CGRectLeftBottomY([_buttonArr[i-1] frame])+15,UI_COMM_BTN_WIDTH, ActionSheetButtonHeight);
            }
            
            [_bottomView addSubview:btn];
            [_buttonArr addObject:btn];
            
        }
        //添加手势
        UITapGestureRecognizer* recognizer;
        recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        recognizer.numberOfTapsRequired = 1;
        [self addGestureRecognizer:recognizer];
        
    }
    return self;
}
-(void)setButtonBackGroundImage:(UIImage*)image forState:(UIControlState)state{
   
    for (int i=0; i<_buttonArr.count; i++) {
        UIButton* btn = _buttonArr[i];
        [btn setBackgroundImage:image forState:state];
    }
    
     //把取消按钮剔除
    UIButton* cancleButton = _buttonArr.lastObject;
    [cancleButton setBackgroundImage:[UIImage resizedImage:@"btn_gray_n" leftScale:0.2 topScale:1] forState:(UIControlStateNormal)];
    [cancleButton setBackgroundImage:[UIImage resizedImage:@"btn_gray_p" leftScale:0.2 topScale:1] forState:(UIControlStateHighlighted)];

}

-(void)buttonAction:(UIButton*)sender{
    
    NSUInteger currentIndex = [_buttonArr indexOfObject:sender];
    //block
    if (self.block) {
        self.block(self,currentIndex);
    }
    
    [self hideActionSheet];
}

-(void)actionSheetSelectBlock:(CustomActionSheetBlock)block
{
    self.block = block;
}

-(void)tapAction:(id)sender{
    [self hideActionSheet];
}


-(void)showActionSheetInView:(UIView*)superView{
    [GApplication.keyWindow addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = RGBColor(0, 0, 0, 0.7);
        CGRect rc = _bottomView.frame;
        rc.origin.y = DEVICE_HEIGHT-_bottomHeight;
        _bottomView.frame = rc;
    }];
    
}

-(void)hideActionSheet{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.0f;
        CGRect rc = _bottomView.frame;
        rc.origin.y = DEVICE_HEIGHT;
        _bottomView.frame = rc;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}






@end
