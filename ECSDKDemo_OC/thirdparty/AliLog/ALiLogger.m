//
//  ALiLogger.m
//  NSLogTester
//
//  Created by Rainbow on 4/24/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "ALiLogger.h"
static ALiLogger *sharedInstance;

@interface ALiLogger(){
    UITextView *logContentTextView;
    UIButton *clearBtn;
    UIButton *closeBtn;
    NSString *allLogString;
    NSMutableAttributedString *allLogAttributeString;
    BOOL isHidden;
    
}

@end

@implementation ALiLogger

+ (instancetype)sharedInstance {
    static dispatch_once_t DDASLLoggerOnceToken;
    
    dispatch_once(&DDASLLoggerOnceToken, ^{
        sharedInstance = [[[self class] alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init {
    if (sharedInstance != nil) {
        return nil;
    }
    
    if ((self = [super init])) {        
       [self initLogViews];
        isHidden = YES;
        self.colors = @[[UIColor redColor],[UIColor purpleColor],[UIColor blueColor],[UIColor grayColor],[UIColor grayColor]];
        allLogAttributeString = [[NSMutableAttributedString alloc] initWithString:@"" attributes:@{NSForegroundColorAttributeName:[UIColor redColor]}];
        
    }
    
    return self;
}



- (void)logMessage:(DDLogMessage *)logMessage {
    // Skip captured log messages
    if ([logMessage->_fileName isEqualToString:@"DDASLLogCapture"]) {
        return;
    }
    
    /*
     DDLogFlagError      = (1 << 0), // 0...00001
     DDLogFlagWarning    = (1 << 1), // 0...00010
     DDLogFlagInfo       = (1 << 2), // 0...00100
     DDLogFlagDebug      = (1 << 3), // 0...01000
     DDLogFlagVerbose    = (1 << 4)  // 0...10000
     */
    
    if (!([logMessage flag]&[logMessage level])) {
//        dispatch_async(dispatch_get_main_queue(), ^(){
//            [self showLogView];
//        });
        return;
    }
    
    
    UIColor *logColor = self.colors[4];
    switch ([logMessage flag]) {
        case 1:
            logColor = self.colors[0];
            break;
        case 2:
            logColor = self.colors[1];
            break;
        case 8:
            logColor = self.colors[2];
            break;
        case 4:
            logColor = self.colors[3];
            break;
        case 16:
            logColor = self.colors[4];
            break;
        default:
            break;
    }
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *currentDateStr = [dateFormatter stringFromDate: [logMessage timestamp]];
    NSString *logInfo = [NSString stringWithFormat:@"【%@】,%@,line-%d,flag:%d,level:%d",currentDateStr,[logMessage function],[logMessage line],[logMessage flag],[logMessage level]];
    
    NSString * message = _logFormatter ? [_logFormatter formatLogMessage:logMessage] : logMessage->_message;
    
//    if (YES) {
//        dispatch_async(dispatch_get_main_queue(), ^(){
//            [self showLogView];
//        });
//
//    }
    
    
    
    
    
    
    NSString *logStr = [NSString stringWithFormat:@"%@:\n%@\n",logInfo,message];
    NSMutableAttributedString *muString = [[NSMutableAttributedString alloc] initWithString:logStr attributes:@{NSForegroundColorAttributeName:logColor}];
    [allLogAttributeString appendAttributedString:muString];
    if (logContentTextView!=nil) {
        dispatch_async(dispatch_get_main_queue(), ^(){
            logContentTextView.attributedText = allLogAttributeString;
        });
    }

    
    
    //NSLog(@"alilogger  ....................... ........ ........");
}

- (void)clearBtnHandler:(id)btn{
    allLogString = @"";
    dispatch_async(dispatch_get_main_queue(), ^(){
        logContentTextView.text = allLogString;
    });
}

- (void)closeBtnHandler:(id)btn{
    isHidden = YES;
    if (self.logView!=nil) {
        [self.logView removeFromSuperview];
    }
}

- (void)longPressToDo:(id)sender{
    isHidden = YES;
    if (self.logView!=nil) {
        [self.logView removeFromSuperview];
    }
}



- (void)showLogView{
    isHidden = NO;
    if (self.logParentView!=nil) {
        if (self.logView!=nil) {
            [self.logView removeFromSuperview];
        }
        self.logView.frame = self.logParentView.bounds;
        logContentTextView.frame = CGRectMake(0.f,40.f+20.f ,self.logView.frame.size.width, self.logView.frame.size.height-40.f-20.f);
        if (self.logView!=nil) {
            [self.logParentView addSubview:self.logView];
        }else{
            [self initLogViews];
            [self.logParentView addSubview:self.logView];
        }
    }
}

-(void)initLogViews{
    self.logView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 320.f, 640.f)];
    self.logView.backgroundColor = [UIColor blackColor];
    clearBtn = [[UIButton alloc] initWithFrame:CGRectMake(10.f, 20.f+5.f, 80.f, 30.f)];
    clearBtn.backgroundColor = [UIColor grayColor];
    clearBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [clearBtn setTitle:@"清除日志" forState:UIControlStateNormal];
    [clearBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.logView addSubview:clearBtn];
    [clearBtn addTarget:self action:@selector(clearBtnHandler:) forControlEvents:UIControlEventTouchUpInside];
    
    closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(100.f, 20.f+5.f, 80.f, 30.f)];
    closeBtn.backgroundColor = [UIColor grayColor];
    closeBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [closeBtn setTitle:@"关闭日志" forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.logView addSubview:closeBtn];
    [closeBtn addTarget:self action:@selector(closeBtnHandler:) forControlEvents:UIControlEventTouchUpInside];
    
    logContentTextView = [[UITextView alloc] initWithFrame:CGRectMake(0.f,40.f+20.f ,self.logView.frame.size.width, self.logView.frame.size.height-40.f-20.f)];
    logContentTextView.textColor = [UIColor blackColor];
    logContentTextView.editable = NO;
    [self.logView addSubview:logContentTextView];
    allLogString = @"";
    UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
    longPressGr.minimumPressDuration = 1.0;
    [self.logView addGestureRecognizer:longPressGr];

}

- (NSString *)loggerName {
    return @"com.alijk.aliLogger";
}


@end
