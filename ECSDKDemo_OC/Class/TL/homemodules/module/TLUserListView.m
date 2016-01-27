//
//  TLUserListView.m
//  TL
//
//  Created by Rainbow on 2/16/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "TLUserListView.h"
#import "TLTripUserDTO.h"
#import "TLHelper.h"
@interface TLUserListView()
@property (nonatomic,strong) UIScrollView *userScroll;
@end
@implementation TLUserListView

- (instancetype)initWithFrame:(CGRect)frame itemData:(id)itemData
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGBA(0xCCCCCC, 0.5);
        self.itemData = itemData;
        self.isShowImageName = YES;
        [self setupView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame itemData:(id)itemData isShowImageName:(BOOL)isShowImageName
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGBA(0xCCCCCC, 0.5);
        self.itemData = itemData;
        self.isShowImageName = isShowImageName;
        [self setupView];
    }
    return self;
}

-(void)setupView{
    self.backgroundColor = COLOR_WHITE_BG;
    _userScroll = [[UIScrollView alloc] initWithFrame:self.bounds];
    [self addSubview:_userScroll];
    CGFloat vGap = 10.f;
    CGFloat hGap = 10.f;
    
    NSDictionary *dic14B = [NSDictionary dictionaryWithObjectsAndKeys:FONT_14B,NSFontAttributeName, nil];
    CGSize textSize = [@"0" sizeWithAttributes:dic14B];
    
    
    CGFloat userIconHeight = 0.f;
    if (self.isShowImageName) {
        userIconHeight = CGRectGetHeight(self.frame)-textSize.height-vGap*3;
    }else{
        userIconHeight = CGRectGetHeight(self.frame)-vGap*2;
    }
    
    
    NSArray<TLTripUserDTO> *userArray = self.itemData;
    [userArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        TLTripUserDTO *user = obj;
        
        NSString *userIconUrl = [NSString stringWithFormat:@"%@%@",TL_SERVER_BASE_URL,user.userIcon];
        if (userIconUrl) {
            
            UIImageView *userImageView = [[UIImageView alloc] initWithFrame:CGRectMake(hGap*(idx+1)+userIconHeight*idx, vGap, userIconHeight, userIconHeight)];
            userImageView.layer.borderWidth = 1.f;
            userImageView.layer.borderColor = [UIColor whiteColor].CGColor;
            [self.userScroll addSubview:userImageView];
            
            [userImageView sd_setImageWithURL:[NSURL URLWithString:userIconUrl] placeholderImage:[UIImage imageNamed:@"ico_loading_logo"]];
            self.userScroll.contentSize = CGSizeMake(CGRectGetMaxX(userImageView.frame), CGRectGetHeight(self.frame));
            
            
            userImageView.onTouchTapBlock = ^(UIImageView *imageView){
                if (self.type==1) {
                    [RTLHelper gotoGroupInfoView:user.loginId];
                }else{
                     [RTLHelper gotoUserInfoView:user.loginId];
                }
                
            };
        }
        
        if (self.isShowImageName) {
            
            NSString *userName = user.userName;
            UILabel *userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(hGap*(idx+1)+userIconHeight*idx, CGRectGetHeight(self.frame)-vGap-textSize.height, userIconHeight, textSize.height)];
            userNameLabel.text = userName;
            userNameLabel.font = FONT_14B;
            userNameLabel.textColor = COLOR_MAIN_TEXT;
            userNameLabel.textAlignment = NSTextAlignmentCenter;
            [self.userScroll addSubview:userNameLabel];
        }    }];
}

@end
