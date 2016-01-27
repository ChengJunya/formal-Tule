//
//  AKRedPointCell.m
//  alijk
//
//  Created by zhangyang on 15/2/10.
//  Copyright (c) 2015年 zhongxin. All rights reserved.
//

#import "AKRedPointCell.h"
#import "ZXUIHelper.h"
#import "RUILabel.h"
#import "TLModuleDataHelper.h"

#define CELL_HEIGHT 44.f
#define ICON_HEIGHT 24.f
#define REDDOT_HEIGHT 8.f
#define PADDING_RIGHT 40.f

@interface AKRedPointCell (){
    UIImageView *iconImageView;
    UILabel* titLabel;
    UILabel* infoLabel;
    CALayer* redDotLayer;
    UISwitch * switchs;
}


@end

@implementation AKRedPointCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setupViews];
        
    }
    
    return self;
}

#pragma mark - 
#pragma mark - 初始化CELL视图
//添加视图
- (void)setupViews{
    
    iconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:iconImageView];
    
    titLabel = [ZXUIHelper addUILabelWithText:@"" textColor:COLOR_TITLEE textAlignment:NSTextAlignmentLeft font:FONT_16];
    [self.contentView addSubview:titLabel];
    
    
    infoLabel = [ZXUIHelper addUILabelWithText:@"" textColor:COLOR_ASSI_TEXT textAlignment:NSTextAlignmentRight font:FONT_14];
    [self.contentView addSubview:infoLabel];
    

    switchs = [[UISwitch alloc]initWithFrame:CGRectZero];//CGRectMake(hasPrakView.width-hGap-50, 5.f, 50, 40)];
    [self.contentView addSubview:switchs];

    [switchs setOn:YES];
    //[switchs setTintColor:COLOR_ORANGE_TEXT];
    [switchs setOnTintColor:COLOR_ORANGE_TEXT];
    
    [switchs addTarget:self action:@selector(switchsSelectAction:) forControlEvents:UIControlEventTouchUpInside];
    
    redDotLayer = [CALayer layer];
    redDotLayer.backgroundColor = [UIColor redColor].CGColor;
    redDotLayer.cornerRadius = REDDOT_HEIGHT/2;
    redDotLayer.hidden = NO;
    [self.contentView.layer addSublayer:redDotLayer];
    
    
    self.height = CELL_HEIGHT;
    
}

-(void)switchsSelectAction:(UISwitch*)st{
    

        switch (self.cellDto.dtoId.integerValue) {
            case 21://隐身模式
            {
                [GUserDefault setValue:switchs.on?@"1":@"0" forKey:IS_HIDDEN_MODULE_KEY];
                
                NSLog(@"隐身模式%@",[GUserDefault valueForKey:IS_HIDDEN_MODULE_KEY]);
                [GTLModuleDataHelper settingHidden:[GUserDefault valueForKey:IS_HIDDEN_MODULE_KEY] requestArr:[NSMutableArray array] block:^(id obj, BOOL ret) {
                   
                }];
                break;
            }
            case 31://群组消息
            {
                [GUserDefault setValue:switchs.on?@"1":@"0" forKey:IS_GROUP_MESSAGE_NOTICE_KEY];
                NSLog(@"群组消息%@",[GUserDefault valueForKey:IS_GROUP_MESSAGE_NOTICE_KEY]);
                break;
            }
            case 32://所有人的消息
            {
                [GUserDefault setValue:switchs.on?@"1":@"0" forKey:IS_ALL_MESSAGE_NOTICE_KEY];
                NSLog(@"所有人的消息%@",[GUserDefault valueForKey:IS_ALL_MESSAGE_NOTICE_KEY]);
                break;
            }
            case 41://34g
            {
                [GUserDefault setValue:switchs.on?@"1":@"0" forKey:IS_DOWNLOAD_IN34GNET];
                NSLog(@"34g%@",[GUserDefault valueForKey:IS_DOWNLOAD_IN34GNET]);
                break;
            }
            
            default:
                break;
        }
    
    
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    iconImageView.frame = CGRectMake(UI_Comm_Margin, (CELL_HEIGHT-ICON_HEIGHT)/2, ICON_HEIGHT, ICON_HEIGHT);
    
    titLabel.width = [titLabel.text sizeWithAttributes:@{NSFontAttributeName:FONT_16}].width;
    titLabel.frame = CGRectMake(UI_Comm_Margin, (CELL_HEIGHT-titLabel.height)/2, titLabel.width, titLabel.height);
    
    infoLabel.frame = CGRectMake(titLabel.right+UI_Comm_Margin, (CELL_HEIGHT-infoLabel.height)/2, self.contentView.width-titLabel.width-UI_Comm_Margin*2-PADDING_RIGHT, infoLabel.height);
    
    redDotLayer.frame = CGRectMake(titLabel.right+UI_Comm_Margin,(CELL_HEIGHT-REDDOT_HEIGHT)/2,REDDOT_HEIGHT,REDDOT_HEIGHT);
    
    switchs.frame = CGRectMake(self.contentView.width-switchs.width-UI_Comm_Margin, (CELL_HEIGHT-switchs.height)/2, 20.f, 40.f);
    [self setSwitchSelectState];
}


- (void)setSwitchSelectState{
    switch (self.cellDto.dtoId.integerValue) {
        case 21://隐身模式
        {
            switchs.on = [GUserDefault valueForKey:IS_HIDDEN_MODULE_KEY]==nil||[[GUserDefault valueForKey:IS_HIDDEN_MODULE_KEY] isEqualToString:@"1"]?YES:NO;
            NSLog(@"隐身模式%@",[GUserDefault valueForKey:IS_HIDDEN_MODULE_KEY]);
            break;
        }
        case 31://群组消息
        {
            switchs.on = [GUserDefault valueForKey:IS_GROUP_MESSAGE_NOTICE_KEY]==nil||[[GUserDefault valueForKey:IS_GROUP_MESSAGE_NOTICE_KEY] isEqualToString:@"1"]?YES:NO;
            NSLog(@"群组消息%@",[GUserDefault valueForKey:IS_GROUP_MESSAGE_NOTICE_KEY]);
            break;
        }
        case 32://所有人的消息
        {
            switchs.on = [GUserDefault valueForKey:IS_ALL_MESSAGE_NOTICE_KEY]==nil||[[GUserDefault valueForKey:IS_ALL_MESSAGE_NOTICE_KEY] isEqualToString:@"1"]?YES:NO;
            NSLog(@"所有人的消息%@",[GUserDefault valueForKey:IS_ALL_MESSAGE_NOTICE_KEY]);
            break;
        }
        case 41://34g
        {
            switchs.on = [GUserDefault valueForKey:IS_DOWNLOAD_IN34GNET]==nil||[[GUserDefault valueForKey:IS_DOWNLOAD_IN34GNET] isEqualToString:@"1"]?YES:NO;
            NSLog(@"34g%@",[GUserDefault valueForKey:IS_DOWNLOAD_IN34GNET]);
            break;
        }
            
        default:
            break;
    }
}

- (void)updateCell{
    [CATransaction setDisableActions:YES];
    iconImageView.image = [UIImage imageNamed:self.cellDto.icon];
    titLabel.text = self.cellDto.title;
    infoLabel.text = self.cellDto.info;
    redDotLayer.hidden = self.cellDto.isRedDotHidden;
    
    if (self.cellDto.type.integerValue==2) {
        switchs.hidden = NO;
        [switchs setOn:self.cellDto.isOn];
    }else{
        switchs.hidden = YES;
    }
    
}

-(void)setCellDto:(ADPersonCenterDTO *)cellDto{
    _cellDto = cellDto;
    [self updateCell];
}

+(CGFloat)cellHeight{
    return CELL_HEIGHT;
}

@end
