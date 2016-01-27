//
//  TLCommentCell.m
//  TL
//
//  Created by Rainbow on 2/13/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "TLCommentCell.h"
#import "TLCommentDataDTO.h"
#import "TLHelper.h"
#import "UserDataHelper.h"

@implementation TLCommentCell

-(void)initContent{
    
    TLCommentDataDTO *cellDto = self.cellData;
    
    //titlebox
    //contentbox
    CGFloat minHeight = 80.f;
    CGFloat cellTempHeight = 200.f;
    CGFloat vGap = 10.f;
    CGFloat hGap = 10.f;
    CGFloat yOffSet = 0.f;
    
    if (self.cellContentView) {
        [self.cellContentView removeFromSuperview];
        self.cellContentView = nil;
    }
    
    self.cellContentView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:self.cellContentView];
    
    
    CGFloat userIconHeight = 60.f;

    NSString *userIconUrl = [NSString stringWithFormat:@"%@%@",TL_SERVER_BASE_URL,cellDto.user.userIcon];
    if (userIconUrl) {
        
        UIImageView *userImageView = [[UIImageView alloc] initWithFrame:CGRectMake(hGap, vGap, userIconHeight, userIconHeight)];
        userImageView.layer.borderWidth = 0.5f;
        userImageView.layer.borderColor = [UIColor grayColor].CGColor;
        userImageView.layer.cornerRadius = userIconHeight/2;
        [self.cellContentView addSubview:userImageView];
        userImageView.layer.masksToBounds = YES;
        
        [userImageView sd_setImageWithURL:[NSURL URLWithString:userIconUrl] placeholderImage:[UIImage imageNamed:@"ico_loading_logo"]];
        
        
        
        userImageView.onTouchTapBlock = ^(UIImageView *imageView){
            if (![GUserDataHelper isLoginUser:cellDto.user.loginId]) {
                [RTLHelper gotoUserInfoView:cellDto.user.loginId];
            }
            
        };
        
    }
    
    NSDictionary *timeDic = [NSDictionary dictionaryWithObjectsAndKeys:FONT_14,NSFontAttributeName ,nil];

    
    NSString *userName = cellDto.user.userName;
    CGSize userNameSize = [userName sizeWithAttributes:timeDic];
    UILabel *userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(hGap*2+userIconHeight,vGap, userNameSize.width, userNameSize.height)];
    userNameLabel.font = FONT_14;
    userNameLabel.text = userName;
    userNameLabel.textColor = COLOR_TAB_TEXT_P;
    [self.cellContentView addSubview:userNameLabel];
    
    
    //add commenttime str
    NSString *commentTime = cellDto.publishTime;
    CGSize commentTimeStrSize = [commentTime sizeWithAttributes:timeDic];
    
    UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.cellContentView.frame)-hGap-commentTimeStrSize.width,vGap, commentTimeStrSize.width, commentTimeStrSize.height)];
    commentLabel.font = FONT_14;
    commentLabel.textColor = COLOR_MAIN_TEXT;
    commentLabel.text = commentTime;
    [self.cellContentView addSubview:commentLabel];
    
    
    
    NSString *commentContextStr = cellDto.commentContent;
//    CGSize commentContextStrSize = [commentContextStr sizeWithAttributes:timeDic];
    
    CGFloat commentContextWidth = CGRectGetWidth(self.cellContentView.frame)-hGap*3-userIconHeight;
    
    CGRect newContentStrFrame = [commentContextStr boundingRectWithSize:CGSizeMake(commentContextWidth, 1000) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin) attributes:timeDic context:nil];
    
    yOffSet = yOffSet + vGap*2 + commentTimeStrSize.height;
    
    UILabel *commentContextLabel = [[UILabel alloc] initWithFrame:CGRectMake(hGap*2+userIconHeight,yOffSet, CGRectGetWidth(newContentStrFrame),CGRectGetHeight(newContentStrFrame))];
    commentContextLabel.font = FONT_14;
    commentContextLabel.text = commentContextStr;
    [commentContextLabel setNumberOfLines:0];
    commentContextLabel.textColor = COLOR_MAIN_TEXT;
    [self.cellContentView addSubview:commentContextLabel];

    
    
    
//    NSString *titleStr = [self.cellData valueForKey:@"TITLE"];
//    NSDictionary *titleDic = [NSDictionary dictionaryWithObjectsAndKeys:FONT_16,NSFontAttributeName ,nil];
//    CGSize titleSize = [titleStr sizeWithAttributes:titleDic];
//    
//    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.cellContentView.width-userIconHeight-20.f-titleSize.width, self.cellContentView.height-userIconHeight-10.f, titleSize.width+10.f, titleSize.height)];
//    titleLabel.text = titleStr;
//    titleLabel.textColor = [UIColor whiteColor];
//    //titleLabel.strokeColor = [UIColor blackColor];
//    titleLabel.font = FONT_16;
//    //titleLabel.strokeSize = 0.5f;
//    [self.cellContentView addSubview:titleLabel];
//    
//    
//    
//    NSString *infoStr = [NSString stringWithFormat:@"%@ · %@人气",[self.cellData valueForKey:@"PUBLISHTIME"],[self.cellData valueForKey:@"SCOUNT"]];
//    NSDictionary *infoDic = [NSDictionary dictionaryWithObjectsAndKeys:FONT_12,NSFontAttributeName ,nil];
//    CGSize infoSize = [infoStr sizeWithAttributes:infoDic];
//    
//    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.cellContentView.width-userIconHeight-20.f-infoSize.width, self.cellContentView.height-infoSize.height-10.f, infoSize.width+10.f, infoSize.height)];
//    infoLabel.text = infoStr;
//    infoLabel.textColor = [UIColor whiteColor];
//    //infoLabel.strokeColor = [UIColor blackColor];
//    infoLabel.font = FONT_12;
//    //infoLabel.strokeSize = 0.5f;
//    [self.cellContentView addSubview:infoLabel];
    
    
    yOffSet = MAX(minHeight, CGRectGetHeight(newContentStrFrame)+vGap+yOffSet);
    
    
    self.cellHeight = yOffSet;
    
}

@end
