//
//  TLNoteMessageCell.m
//  TL
//
//  Created by Rainbow on 2/8/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "TLNoteMessageCell.h"

#import "TLSysMessageDTO.h"
@interface TLNoteMessageCell()
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *messageLabel;
@property (nonatomic,strong) UILabel *linkLabel;
@property (nonatomic,strong) UIView *titleBox;
@property (nonatomic,strong) UIView *contentBox;

@end
@implementation TLNoteMessageCell

-(void)initContent{
    //titlebox
    //contentbox
    
    if (_titleBox) {
        [_titleBox removeFromSuperview];
        _titleBox = nil;
    }
  
    if (_contentBox) {
        [_contentBox removeFromSuperview];
        _contentBox = nil;
    }
    
    
    CGFloat yOffSet = 10.f;
    CGFloat hGap = 10.0f;
    CGFloat vGap = 10.0f;
    CGFloat titleBoxHeight = 40.f;
    CGFloat contentBoxHeight = 80.f;
    
    //@{@"ID":@"1",@"TITLE":@"到期提醒",@"MESSAGE":@"您与2014年2月14日在商店购买的途乐会员将在4天后到期。",@"TYPE":@"1",@"height":cellHeight,@"isAction":@"1"}
    
    TLSysMessageDTO *cellDto = self.cellData;
    
    NSString *titleStr = cellDto.messageType.integerValue==1?@"会员到期提醒消息":@"消费记录提醒消息";
    NSString *messageStr = cellDto.content;
    NSString *linkStr = cellDto.createTime;
    NSDictionary *titleDic = [NSDictionary dictionaryWithObjectsAndKeys:FONT_18B,NSFontAttributeName ,nil];
    NSDictionary *messageDic = [NSDictionary dictionaryWithObjectsAndKeys:FONT_18,NSFontAttributeName ,nil];
    CGSize titleSize = [titleStr sizeWithAttributes:titleDic];
    CGSize messageSize = [messageStr sizeWithAttributes:messageDic];
    CGSize linkSize = [linkStr sizeWithAttributes:messageDic];

    
    
    //titleBox
    _titleBox = [[UIView alloc] initWithFrame:CGRectMake(hGap, yOffSet, CGRectGetWidth(self.frame)-hGap*2, titleBoxHeight)];
    [self addSubview:_titleBox];
    _titleBox.layer.backgroundColor = [UIColor whiteColor].CGColor;

    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(hGap, (titleBoxHeight-titleSize.height)/2 , CGRectGetWidth(_titleBox.frame)-hGap*2, titleSize.height)];
    _titleLabel.text = titleStr;
    _titleLabel.textColor = COLOR_MAIN_TEXT;
    [_titleBox addSubview:_titleLabel];
    yOffSet = yOffSet+titleBoxHeight+2.f;
    
    _contentBox = [[UIView alloc] initWithFrame:CGRectMake(hGap, yOffSet, CGRectGetWidth(self.frame)-hGap*2, contentBoxHeight)];
    _contentBox.layer.backgroundColor = [UIColor whiteColor].CGColor;
    [self addSubview:_contentBox];
    

    
    _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(hGap, vGap , CGRectGetWidth(_titleBox.frame)-hGap*2, messageSize.height)];
    _messageLabel.text = messageStr;
    _messageLabel.textColor = COLOR_MAIN_TEXT;
    [_messageLabel setNumberOfLines:0];
    _messageLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [_contentBox addSubview:_messageLabel];

//CGSize labelsize = [messageStr boundingRectWithSize:CGSizeMake(kPhotoCell_Width, 1000) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin) attributes:attrbute context:nil]
    
    CGRect messageLabelRectSize = [messageStr boundingRectWithSize:CGSizeMake(CGRectGetWidth(_contentBox.frame),1000) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin) attributes:messageDic context:nil];
    _messageLabel.frame = CGRectMake(hGap, vGap, CGRectGetWidth(messageLabelRectSize),CGRectGetHeight(messageLabelRectSize));
    _contentBox.frame = CGRectMake(hGap, yOffSet, CGRectGetWidth(_contentBox.frame),CGRectGetHeight(messageLabelRectSize)+vGap*3+linkSize.height);
    
    
    
    _linkLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(_contentBox.frame)-linkSize.width-hGap, CGRectGetHeight(_contentBox.frame)-linkSize.height-vGap , linkSize.width, linkSize.height)];
    _linkLabel.text = linkStr;
    _linkLabel.textColor = COLOR_TAB_TEXT_P;
    [_contentBox addSubview:_linkLabel];
    
    
    
    self.cellHeight = titleBoxHeight+CGRectGetHeight(_contentBox.frame)+1.f+vGap*2;

}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    // Configure the view for the selected state
    if (selected) {
        NSLog(@"selected");
        self.backgroundColor = [UIColor clearColor];
        
        //[self action];
        
    }else{
        NSLog(@"unSelected");
        self.backgroundColor = [UIColor clearColor];
    }
    
}

@end
