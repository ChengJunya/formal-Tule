//
//  RUtiles.m
//  HiddenTalk
//
//  Created by Rainbow on 8/21/13.
//  Copyright (c) 2013 MST. All rights reserved.
//

#import "RUtiles.h"

@implementation RUtiles
+(void)alert:(NSString*)title info:(NSString*)info{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:info delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

/*
-(void)commonAlert:(NSString*)title info:(NSString*)info{
    NSMutableDictionary *alertData = [[NSMutableDictionary alloc] init];
    
    [alertData setValue:info forKey:@"content"];
    RCommonAlertView *savealert = [[RCommonAlertView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) alertData:alertData];
    //savealert.SaveAlertDelegate = self;
    
    
    [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(timerFireMethod:) userInfo:alertData repeats:NO];
    
    [savealert show];
    
}


-(void)timerFireMethod:(NSTimer *)theTimer
{
    RCommonAlertView *promptAlert = (RCommonAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
    promptAlert = NULL;
}

*/



+ (UIImage*) getImage:(UIImage*)originImg inRect:(CGRect)rect{
    //参加尺寸
    CGImageRef subImageRef = CGImageCreateWithImageInRect(originImg.CGImage, rect);
    //创建一个bitmap的context并设置成为当前正在用的context
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, rect, subImageRef);//绘制图片
    UIImage* subImage = [UIImage imageWithCGImage:subImageRef];//获得图片
    UIGraphicsEndImageContext();
    return subImage;
}

+ (NSString *)getDateString:(NSDate *)olddate{
    
    //信息列表的时间需要处理通过一分钟前，三分钟前，10分钟前，30分钟前，1个小时前，3个小时前，半天前，一天前，三天前，具体时间
    
    //思路 获取当前时间的秒 减去 传入的时间的秒
    NSDate *datenow = [NSDate date];
    
    //long oldSeconds = [olddate timeIntervalSince1970]*1;
    //long currentSeconds = [datenow timeIntervalSince1970]*1;
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    //例如你在国内发布信息,用户在国外的另一个时区,你想让用户看到正确的发布时间就得注意时区设置,时间的换算.
    //例如你发布的时间为2010-01-26 17:40:50,那么在英国爱尔兰那边用户看到的时间应该是多少呢?
    //他们与我们有7个小时的时差,所以他们那还没到这个时间呢...那就是把未来的事做了
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    
    
    
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    [formatter2 setDateStyle:NSDateFormatterMediumStyle];
    [formatter2 setTimeStyle:NSDateFormatterShortStyle];
    [formatter2 setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    
    
    NSDateFormatter *formatter3 = [[NSDateFormatter alloc] init];
    [formatter3 setDateStyle:NSDateFormatterMediumStyle];
    [formatter3 setTimeStyle:NSDateFormatterShortStyle];
    [formatter3 setDateFormat:@"HH:mm"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter3 setTimeZone:timeZone];
    
    
    NSString *nowtimeStr = [formatter2 stringFromDate:datenow];//----------将nsdate按formatter格式转成nsstring
    NSString *oldtimeStr = [formatter stringFromDate:olddate];
    
    NSString *oldTimeHM = [formatter3 stringFromDate:olddate];
    
    NSDate* oldDateSp = [formatter dateFromString:oldtimeStr];
    NSDate* nowDateSp = [formatter dateFromString:nowtimeStr];
    
    long oldSpSeconds = [oldDateSp timeIntervalSince1970]*1;
    long nowSpSeonds = [nowDateSp timeIntervalSince1970]*1;
    
    
    
    
    int timeOC = (nowSpSeonds-oldSpSeconds);
    //[RUtiles alert:@"--" info:[NSString stringWithFormat:@"%lD , %lD , %d , %@  %@ ",oldSpSeconds,currentSeconds,timeOC,oldtimeStr,nowtimeStr]];
    
    
    //一分钟前 60秒前
    
    
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    //[calendar setTimeZone:timeZone];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    //[comps setTimeZone:timeZone];
    NSInteger unitFlags = NSYearCalendarUnit |
    NSMonthCalendarUnit |
    NSDayCalendarUnit |
    NSWeekdayCalendarUnit |
    NSHourCalendarUnit |
    NSMinuteCalendarUnit |
    NSSecondCalendarUnit;
    //int week=0;
    comps = [calendar components:unitFlags fromDate:oldDateSp];
    int week = [comps weekday];
    /*int year=[comps year];
    int month = [comps month];
    int day = [comps day];
    //[formatter setDateStyle:NSDateFormatterMediumStyle];
    //This sets the label with the updated time.
    int hour = [comps hour];
    int min = [comps minute];
    int sec = [comps second];
    */
    
    NSString *weekStr = @"";
    switch (week) {
        case 7:
            weekStr = @"周日";
            break;
        case 1:
            weekStr = @"周一";
            break;
        case 2:
            weekStr = @"周二";
            break;
        case 3:
            weekStr = @"周三";
            break;
        case 4:
            weekStr = @"周四";
            break;
        case 5:
            weekStr = @"周五";
            break;
        case 6:
            weekStr = @"周六";
            break;
            
        default:
            break;
    }
    
    
    if (0<timeOC&&timeOC<60) {
        return @"刚刚";
    }
    
    if (60<timeOC&&timeOC<180) {
        return @"1分钟前";
    }
    
    //3分钟前 180秒
    if (180<timeOC&&timeOC<600) {
        return @"3分钟前";
    }
    
    //10分钟前 600秒
    if (600<timeOC&&timeOC<1800) {
        return @"10分钟前";
    }
    //30分钟前 1800秒
    if (1800<timeOC&&timeOC<3600) {
        return @"30分钟前";
    }
    //1个小时前 3600秒
    if (3600<timeOC&&timeOC<10800) {
        return @"1小时前";
    }
    //3个小时前 10800秒
    if (10800<timeOC&&timeOC<43200) {
        return @"3小时前";
    }
    //12小时天前 43200秒
    if (43200<timeOC&&timeOC<85600) {
        return @"12小时前";
    }
    //昨天  85600秒
    if (85600<timeOC&&timeOC<256800) {
        return [NSString stringWithFormat:@"昨天 %@",oldTimeHM];
    }
    //三天前    256800
    if (256800<timeOC&&timeOC<1190400) {
        return [NSString stringWithFormat:@"%@ %@",weekStr,oldTimeHM];//@"3天前";
    }
    //一周前   599200  1190400
    /*if (599200<timeOC&&timeOC<1190400) {
        return @"一周前";
    }*/
    
    
   
    
    return [NSString stringWithFormat:@"%@ %@",weekStr,oldtimeStr];//oldtimeStr;
    //具体时间
    
}

- (void) getdd{
    //得到当前的日期
    NSDate *date = [NSDate date];
    NSLog(@"date:%@",date);
    
    //得到(24 * 60 * 60)即24小时之前的日期，dateWithTimeIntervalSinceNow:
    NSDate *yesterday = [NSDate dateWithTimeIntervalSinceNow: -(24 * 60 * 60)];
    NSLog(@"yesterday:%@",yesterday);
    
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    //NSDate *date = [NSDate date];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit |
    NSMonthCalendarUnit |
    NSDayCalendarUnit |
    NSWeekdayCalendarUnit |
    NSHourCalendarUnit |
    NSMinuteCalendarUnit |
    NSSecondCalendarUnit;
    //int week=0;
    comps = [calendar components:unitFlags fromDate:date];
    int week = [comps weekday];
    int year=[comps year];
    int month = [comps month];
    int day = [comps day];
    //[formatter setDateStyle:NSDateFormatterMediumStyle];
    //This sets the label with the updated time.
    int hour = [comps hour];
    int min = [comps minute];
    int sec = [comps second];
    NSLog(@"week%d",week);
    NSLog(@"year%d",year);
    NSLog(@"month%d",month);
    NSLog(@"day%d",day);
    NSLog(@"hour%d",hour);
    NSLog(@"min%d",min);
    NSLog(@"sec%d",sec);
    
    //得到毫秒
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    //[dateFormatter setDateFormat:@"hh:mm:ss"]
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    NSLog(@"Date%@", [dateFormatter stringFromDate:[NSDate date]]);
    
}


+ (UIColor *)colorWithHexString:(NSString *)stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    
    if ([cString length] < 6)
        return [UIColor whiteColor];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor whiteColor];
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}


+ (UIColor *)colorWithHexString:(NSString *)stringToConvert alpha:(float)alpha
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    
    if ([cString length] < 6)
        return [UIColor whiteColor];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor whiteColor];
    
    if (!alpha) {
        alpha = 1.0f;
    }
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:alpha];
}

+ (NSString *)formatYAxisLabel:(double)yValue{
    
    NSString *formatString = @"0";
    if (100000>yValue&&yValue>=1000) {
        formatString = [NSString stringWithFormat:@"%.1fk",yValue/1000];
    }else if (yValue>=100000) {
        formatString = [NSString stringWithFormat:@"%.1fm",yValue/1000000];
    }else{
        formatString = [NSString stringWithFormat:@"%.1f",yValue];
    }
    return formatString;
}



+(NSDate*) dateFromString:(NSString*)uiDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSDate *date=[formatter dateFromString:uiDate];
    return date;
}








+ (NSString *)stringFromDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    
    
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    
    //[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    
    
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    
    return destDateString;
    
}

+ (NSString *)stringFromDateWithFormat:(NSDate *)date format:(NSString*)format{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    
    
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    
    //[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    [dateFormatter setDateFormat:format];
    
    
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    
    return destDateString;

}
+(NSDate*) dateFromString:(NSString*)uiDate format:(NSString *)format{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:format];
    NSDate *date=[formatter dateFromString:uiDate];
    return date;

}


+(NSDateComponents *)getDateComponents:(NSDate *)date{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    comps = [calendar components:unitFlags fromDate:date];
    return  comps;
}


+(UIImage *)changeImage:(UIImage*)image height:(CGFloat)height width:(CGFloat)width{
    if (image==nil) {
        image = [UIImage imageNamed:@"ico_loading_logo_1x2.jpg"];
    }
    CGFloat imageWidth = image.size.width;
    CGFloat imageHeight = image.size.height;
    
    
    
    CGFloat newImageWidth = 0.f;
    CGFloat newImageHeight = 0.f;
    if (imageWidth/imageHeight>width/height) {
        newImageHeight = imageHeight;
        newImageWidth = imageHeight*width/height;
    }else{
        newImageHeight = imageWidth*height/width;
        newImageWidth = imageWidth;
    }
    
    
    return  [UIImage imageWithCGImage:CGImageCreateWithImageInRect([image CGImage], CGRectMake(0.f, 0.f, newImageWidth, newImageHeight))];
}

@end
