//
//  TLAboutVipViewController.m
//  TL
//
//  Created by Rainbow on 4/22/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "TLAboutVipViewController.h"

@interface TLAboutVipViewController ()

@end

@implementation TLAboutVipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"会员功能说明";
    [self addAllUIResources];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navBarHidden = NO;
    self.navBackItemHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void) addAllUIResources
{
    
    //调用本地html文件
    UIWebView * _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,NAVIGATIONBAR_HEIGHT+STATUSBAR_HEIGHT,self.view.bounds.size.width,self.view.bounds.size.height-NAVIGATIONBAR_HEIGHT+STATUSBAR_HEIGHT)];
    _webView.backgroundColor = COLOR_DEF_BG;
    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"aboutvip" ofType:@"html"];
    NSString *htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    
    [_webView loadHTMLString:htmlString baseURL:baseURL];
    
    [self.view addSubview:_webView];
    
}@end
