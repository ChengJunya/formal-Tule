//
//  ZXColorAlert.m
//  alijk
//
//  Created by zhangyang on 14-8-28.
//  Copyright (c) 2014年 zhongxin. All rights reserved.
//

#import "ZXColorAlert.h"
#import "RTLabel.h"

#define AlertButtonHeight 30
#define AlertWidth       270

@interface ZXColorAlert ()
{
    NSMutableArray* _buttonArr;
    UIView* _bottomView;
    CGFloat _bottomHeight;
}

@end

@implementation ZXColorAlert

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithButtonTitles:(NSArray*)btnArr alertTitle:(NSString*)title subTitle:(NSString*)subTitle buttonHeight:(CGFloat)height
{
    if (self = [super initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT)]) {
        self.backgroundColor = RGBColor(0, 0, 0, 0);
        
        
        _buttonArr = [[NSMutableArray alloc] init];
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, AlertWidth, 10)];
        _bottomView.alpha = 0;
        _bottomView.backgroundColor = [UIColor whiteColor];
        _bottomView.layer.cornerRadius = 4.f;
        _bottomView.layer.masksToBounds = YES;
        [self addSubview:_bottomView];
        
        //alert 的 Title
        RTLabel* titleLabel = [[RTLabel alloc] initWithFrame:CGRectMake(10, 10, AlertWidth-10*2, 10*2)];
        [_bottomView addSubview:titleLabel];
        titleLabel.font = [UIFont systemFontOfSize:16.f];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.lineSpacing = 5.0f;
//        titleLabel.textAlignment = NSTextAlignmentCenter;
        [titleLabel setText:title];
        CGSize actSize =  [titleLabel optimumSize];
        CGRect rc = titleLabel.frame;
        rc.size = actSize;
        rc.origin.x = (AlertWidth-rc.size.width)/2;
        titleLabel.frame = rc;
        
        
        RTLabel* subtitleLabel;
        if (subTitle && subTitle.length>0) {
            subtitleLabel = [[RTLabel alloc] initWithFrame:CGRectMake(10, CGRectLeftBottomY(titleLabel.frame)+10, AlertWidth-10*2, 10*2)];
            [_bottomView addSubview:subtitleLabel];
            subtitleLabel.font = [UIFont systemFontOfSize:14.f];
            subtitleLabel.textColor = [UIColor blackColor];
//            subtitleLabel.textAlignment = NSTextAlignmentCenter;
            [subtitleLabel setText:subTitle];
            actSize  = [subtitleLabel optimumSize];
            rc = subtitleLabel.frame;
            rc.size = actSize;
            rc.origin.x = (AlertWidth-rc.size.width)/2;
            subtitleLabel.frame = rc;
        }
        
        
        CGFloat btnWith = (AlertWidth-10*2-5*(btnArr.count-1))/btnArr.count;
        for (int i=0; i<btnArr.count; i++) {
            NSString* title  =  btnArr[i];
            UIButton* btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
            btn.titleLabel.adjustsFontSizeToFitWidth = YES;
            [btn setTitle:title forState:(UIControlStateNormal)];
            [btn addTarget:self action:@selector(buttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
            [self addSubview:btn];
            if (i==0) {
                if (subTitle && subTitle.length>0){
                    btn.frame = CGRectMake(10, CGRectLeftBottomY(subtitleLabel.frame)+20, btnWith, height);
                }else{
                    btn.frame = CGRectMake(10, CGRectLeftBottomY(titleLabel.frame)+20, btnWith, height);
                }
                
            }else{
                UIButton* last = _buttonArr[i-1];
                if (subTitle && subTitle.length>0) {
                    btn.frame = CGRectMake(CGRectRightTopX(last.frame)+5, CGRectLeftBottomY(subtitleLabel.frame)+20,btnWith, height);
                }else{
                    btn.frame = CGRectMake(CGRectRightTopX(last.frame)+5, CGRectLeftBottomY(titleLabel.frame)+20,btnWith, height);
                }
                
            }
            
            [_bottomView addSubview:btn];
            [_buttonArr addObject:btn];
            
        }
        
        //重置视图的位置和大小
        UIButton* aBtn = _buttonArr[0];
        _bottomHeight = CGRectLeftBottomY(aBtn.frame)+10;
        CGRect viewRC = _bottomView.frame;
        viewRC.size.height = _bottomHeight;
        _bottomView.frame = viewRC;
        
        _bottomView.center = self.center;
        
    }
    return self;
}
-(void)setButtonBackGroundImage:(UIImage*)image forState:(UIControlState)state{
    
    for (int i=0; i<_buttonArr.count; i++) {
        UIButton* btn = _buttonArr[i];
        [btn setBackgroundImage:image forState:state];
    }
    
    if (_buttonArr.count > 1) {
        //把取消按钮剔除
        UIButton* cancleButton = _buttonArr.firstObject;
        [cancleButton setBackgroundImage:[UIImage resizedImage:@"btn_gray_n" leftScale:0.2 topScale:1] forState:(UIControlStateNormal)];
        [cancleButton setBackgroundImage:[UIImage resizedImage:@"btn_gray_p" leftScale:0.2 topScale:1] forState:(UIControlStateHighlighted)];
    }
}

-(void)buttonAction:(UIButton*)sender{

    NSUInteger currentIndex = [_buttonArr indexOfObject:sender];
    //block
    if (self.block) {
        self.block(self,currentIndex);
    }
    
    [self hideAlert];
}

-(void)alertSelectBlock:(ZXAlertBlock)block
{
    self.block = block;
}

-(void)tapAction:(id)sender{
    [self hideAlert];
}


-(void)showAlertInView:(UIView*)superView{
    [superView addSubview:self];
    [UIView animateWithDuration:0.2 animations:^{
        self.backgroundColor = RGBColor(0, 0, 0, 0.7);
        _bottomView.alpha = 1;
//        CGRect rc = _bottomView.frame;
//        rc.origin.y = DEVICE_HEIGHT-_bottomHeight;
//        _bottomView.frame = rc;
    }];
    
}

-(void)hideAlert{
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0.0f;
//        CGRect rc = _bottomView.frame;
//        rc.origin.y = DEVICE_HEIGHT;
//        _bottomView.frame = rc;
        _bottomView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}






@end