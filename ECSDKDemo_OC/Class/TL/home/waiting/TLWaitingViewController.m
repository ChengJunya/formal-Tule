//
//  TLWaitingViewController.m
//  TL
//
//  Created by YONGFU on 6/2/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "TLWaitingViewController.h"
#import "TLHelper.h"
#import "TLWaitingImageResponseDTO.h"
@interface TLWaitingViewController (){
    BOOL timerFinished;
    UIView *animationView;
}

@end

@implementation TLWaitingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    animationView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:animationView];
    NSString *chatBgImageName = [GUserDefault valueForKey:WAITING_BG_IMAGE_NAME];
//    if (chatBgImageName.length>0) {
//        self.view.backgroundColor = [UIColor colorWithPatternImage:[self getImageByfileName:chatBgImageName]];
//    }else{
//        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ico_loading_logo_1x1.jpg"]];
//    }
    
    UIImage *bgImage;
    if (chatBgImageName.length>0) {
        bgImage = [self getImageByfileName:chatBgImageName];
    }else{
        bgImage = [UIImage imageNamed:@"default-568"];
    }
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.image = bgImage;
    [self.view addSubview:imageView];
    
    UIButton *goBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width-60.f, 30.f, 60.f, 30.f)];
    [goBtn setTitle:@"跳过>>" forState:UIControlStateNormal];
    [goBtn setTitleColor:COLOR_ORANGE_TEXT forState:UIControlStateNormal];
    [self.view addSubview:goBtn];
    goBtn.titleLabel.font = FONT_16B;
    [goBtn addTarget:self action:@selector(goAction) forControlEvents:UIControlEventTouchUpInside];
    [self getWaitingImageAndSave];
    [self waitingAndGotoHome];
}

-(void)goAction{
    [RTLHelper gotoRootViewController];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navBarHidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)waitingAndGotoHome{

    
    [UIView animateWithDuration:3.f animations:^{
        animationView.alpha = 0;
    } completion:^(BOOL finished) {
        [RTLHelper gotoHomeViewController];

    }];
        
    
}

-(void)getWaitingImageAndSave{
    [GDataManager asyncRequestByType:NetAdapter_InitImage andObject:nil success:^(TLWaitingImageResponseDTO* responseDTO) {
        [self saveWaitingData:responseDTO.result.imageUrl];
    } failure:^(id responseDTO) {
        
    }];
}

-(void)saveWaitingData:(NSString*)url{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [animationView addSubview:imageView];
    //cellImage.backgroundColor = UIColorFromRGBA(0x000000, 0.5);
    //cellImage.alpha = 0.f;
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",TL_SERVER_BASE_URL,url]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [RTLHelper saveAndShowImage:image imageName:WAITING_BG_IMAGE_NAME];
    }];
}



#pragma mark-
#pragma mark- 聊天背景图片获取
//从服务端获取图片或者本地获取图片并设置图片信息的图片，调整位置
- (UIImage*)getImageByfileName:(NSString*)fileName{
    //[RUtiles alert:@"info2" info:msgId];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    
    //并给文件起个文件名
    NSString *imageDir = [[[paths objectAtIndex:0] stringByAppendingPathComponent:@"MST"] stringByAppendingPathComponent:@"images"];
    NSLog(@"imagedir:%@",imageDir);
    //存放图片的文件夹
    NSString *imagePath =[imageDir stringByAppendingPathComponent:fileName];
    NSLog(@"imagePath:%@",imagePath);
    NSData *data = nil;
    
    
    NSFileManager *file_manager = [NSFileManager defaultManager];
    
    //判断图片是否存在
    if([file_manager fileExistsAtPath:imagePath]){
        data=[NSData dataWithContentsOfFile:imagePath];
        NSLog(@"load image from local,image exist.");
    }
    
    if (data==nil) {
        nil;
    }
    
    //图片数据
    UIImage *msgImage = [UIImage imageWithData:data];
    return msgImage;
    
}




@end
