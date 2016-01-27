//
//  SessionViewCell.m
//  ECSDKDemo_OC
//
//  Created by jiazy on 14/12/5.
//  Copyright (c) 2014年 ronglian. All rights reserved.
//

#import "SessionViewCell.h"
#import "ECSession.h"
#import "TLUserViewRequestDTO.h"
#import "TLModuleDataHelper.h"
#import "TLUserViewResultDTO.h"

@implementation SessionViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _portraitImg = [[UIImageView alloc] initWithFrame:CGRectMake(20.0f, 10.0f, 45.0f, 45.0f)];
        _portraitImg.contentMode = UIViewContentModeScaleAspectFit;
        _portraitImg.image = [UIImage imageNamed:@"personal_portrait"];
        [self.contentView addSubview:_portraitImg];
        
        
        _dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(210.0f, 5.0f, 100.0f, 20.0f)];
        _dateLabel.textColor = [UIColor colorWithRed:0.80f green:0.80f blue:0.80f alpha:1.00f];
        _dateLabel.font = [UIFont systemFontOfSize:13];
        _dateLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_dateLabel];
        
        _unReadLabel = [[UILabel alloc]initWithFrame:CGRectMake(280.0f, 35.0f, 25.0f, 20.0f)];
        _unReadLabel.backgroundColor = [UIColor redColor];
        _unReadLabel.textColor = [UIColor whiteColor];
        _unReadLabel.font = [UIFont systemFontOfSize:13];
        _unReadLabel.layer.cornerRadius =10;
        _unReadLabel.layer.masksToBounds = YES;
        
        _unReadLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_unReadLabel];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70.0f, 10.0f, self.frame.size.width-140.0f, 25.0f)];
        _nameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.contentView addSubview:_nameLabel];
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.frame.origin.x, _nameLabel.frame.origin.y+_nameLabel.frame.size.height, _nameLabel.frame.size.width, 15.0f)];
        _contentLabel.font = [UIFont systemFontOfSize:13.0f];
        _contentLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _contentLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:_contentLabel];
    }
    return self;
}

-(void)setSessionData:(ECSession*)session{
    
    NSLog(@"%@",session.sessionId);
    if (session.sessionId.length>5 && [[session.sessionId substringToIndex:5] isEqualToString:@"TLORG"]) {
        NSArray *spliteArray = [session.text componentsSeparatedByString:@"|"];
        self.nameLabel.text = spliteArray.count>1?spliteArray[1]:spliteArray[0];
        self.portraitImg.image = [UIImage imageNamed:@"group_head"];
    }else if(session.type == 100) {
        
        self.nameLabel.text = session.sessionId;
        self.portraitImg.image = [UIImage imageNamed:@"group_head"];
        
    }else{
        
        //        NSArray *messages =  [[DeviceDBHelper sharedInstance] getLatestHundredMessageOfSessionId:session.sessionId];
        //        ECMessage *message;
        //        if (messages.count>0) {
        //            message = messages[messages.count-1];
        //        }
        //
        //        NSString *jsonStr = message.userData;
        //        SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
        //        NSDictionary *userInfo = [jsonParser objectWithString:jsonStr];
        //
        //        //{"head":"\/upload\/20150514\/69e58962ac9d4ed0ac187c7ccf0fb5d0.jpg","loginId":"9673240","name":"尼古拉斯-刘能"}
        //        NSString *userIconUrl = @"";
        //        NSString *userName = @"";
        //        if (userInfo!=nil) {
        //            //NSString *loginId = info[0];
        //            //NSString *userName = info[1];
        //            NSString *userIcon = [userInfo valueForKey:@"head"];
        //            userIconUrl = [NSString stringWithFormat:@"%@%@",TL_SERVER_BASE_URL,userIcon];
        //            userName = [userInfo valueForKey:@"name"];
        //        }
        //
        //
        //
        //        cell.nameLabel.text = userName;
        
        
        self.nameLabel.text = [[DemoGlobalClass sharedInstance] getOtherNameWithVoip:session.sessionId];
        //cell.portraitImg.image = [[DemoGlobalClass sharedInstance] getOtherImageWithVoip:session.sessionId];
        
        //TL_GROUP_ICON_URL
        NSString *iconUrlStr;
        if([session.sessionId hasPrefix:@"g"])
        {
            iconUrlStr = [NSString stringWithFormat:@"%@%@?rlGroupId=%@",TL_SERVER_BASE_URL,TL_GROUP_ICON_URL,session.sessionId];
            NSLog(@"session 头像：%@",iconUrlStr);
            
            [self.portraitImg  sd_setImageWithURL:[NSURL URLWithString:iconUrlStr] placeholderImage:[UIImage imageNamed:@"ico_loading_logo"]];
        }else{
            
            
            iconUrlStr = [NSString stringWithFormat:@"%@%@",TL_SERVER_BASE_URL,[[DemoGlobalClass sharedInstance] getOtherImageNameWithVoip:session.sessionId]];
            
            NSString*imageName =  [[DemoGlobalClass sharedInstance] getOtherImageNameWithVoip:session.sessionId];
            if (imageName.length==0) {
                [self getUserInfo:session];
            }else{

                [self.portraitImg  sd_setImageWithURL:[NSURL URLWithString:iconUrlStr] placeholderImage:[UIImage imageNamed:@"ico_loading_logo"]];
            }
            
            
            
            
        }
       
        
        
    }
    
    self.contentLabel.text = session.text;
    
    self.dateLabel.text = [self getDateDisplayString:session.dateTime];
    if (session.unreadCount == 0) {
        
        self.unReadLabel.hidden =YES;
    }else{
        
        self.unReadLabel.text = [NSString stringWithFormat:@"%d",session.unreadCount];
        self.unReadLabel.hidden =NO;
    }
    

}

//时间显示内容
-(NSString *)getDateDisplayString:(long long) miliSeconds{
    
    NSTimeInterval tempMilli = miliSeconds;
    NSTimeInterval seconds = tempMilli/1000.0;
    NSDate *myDate = [NSDate dateWithTimeIntervalSince1970:seconds];
    
    NSCalendar *calendar = [ NSCalendar currentCalendar ];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear ;
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[ NSDate date ]];
    NSDateComponents *myCmps = [calendar components:unit fromDate:myDate];
    
    NSDateFormatter *dateFmt = [[ NSDateFormatter alloc ] init ];
    if (nowCmps.year != myCmps.year) {
        dateFmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    }
    else
    {
        if (nowCmps.day==myCmps.day) {
            dateFmt.dateFormat = @"今天 HH:mm:ss";
        }
        else if((nowCmps.day-myCmps.day)==1)
        {
            dateFmt.dateFormat = @"昨天 HH:mm:ss";
        }
        else{
            dateFmt.dateFormat = @"MM-dd HH:mm:ss";
        }
    }
    return [dateFmt stringFromDate:myDate];
}


-(void)getUserInfo:(ECSession*)session{
    
    WEAK_SELF(self);
    TLUserViewRequestDTO *userViewRequest = [[TLUserViewRequestDTO alloc] init];
    userViewRequest.loginId = session.sessionId;

    [GTLModuleDataHelper getUserView:userViewRequest requestArray:[NSMutableArray array] block:^(id obj, BOOL ret) {
        
        if (ret) {
            TLUserViewResultDTO *userInfo  = obj;
            [weakSelf setUpViews:userInfo session:session];
        }else{
            ResponseDTO *resDTO = obj;
            [GHUDAlertUtils toggleMessage:resDTO.resultDesc];
        }
    }];
    
    
//    NSString *txt=[NSString stringWithFormat:@"%@/action/userView?loginId=%@",TL_SERVER_BASE_URL,session.sessionId];
//    //创建url对象
//    NSURL *url=[NSURL URLWithString:txt];
//    //创建请求对象
//    NSURLRequest *req=[NSURLRequest requestWithURL:url];
//    //发起同步，赶回数据给data
//    NSData *data=[NSURLConnection sendSynchronousRequest:req returningResponse:nil error:nil];
//    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"个人信息%@",string);
//    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
//    NSDictionary *userInfoDic = [jsonParser objectWithString:string];
//
//
//    
//    
//    
//    NSDictionary *result =  [userInfoDic valueForKey:@"result"];
//    if (result!=nil) {
//        iconUrlStr = [NSString stringWithFormat:@"%@%@",TL_SERVER_BASE_URL,[result valueForKey:@"userIcon"]];
//    }

}

-(void)setUpViews:(TLUserViewResultDTO*)userInfo session:(ECSession*)session{
    NSString * iconUrlStr = [NSString stringWithFormat:@"%@%@",TL_SERVER_BASE_URL,userInfo.userIcon];
                NSLog(@"session 头像：%@",iconUrlStr);
    [self.portraitImg  sd_setImageWithURL:[NSURL URLWithString:iconUrlStr] placeholderImage:[UIImage imageNamed:@"ico_loading_logo"]];
 
    self.contentLabel.text = session.text;
    self.nameLabel.text = userInfo.userName;
    
    self.dateLabel.text = [self getDateDisplayString:session.dateTime ];
    if (session.unreadCount == 0) {
        
        self.unReadLabel.hidden =YES;
    }else{
        
        self.unReadLabel.text = [NSString stringWithFormat:@"%d",session.unreadCount];
        self.unReadLabel.hidden =NO;
    }
    
    [self setNeedsDisplay];
}
@end
