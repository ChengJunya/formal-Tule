//
//  UserGuideViewController.m
//  alijk
//
//  Created by litianying on 14-9-22.
//  Copyright (c) 2014年 zhongxin. All rights reserved.
//

#import "UserGuideViewController.h"
#import "TLHelper.h"

#define K_GuidePageCount 1

@interface UserGuideViewController ()
{
    UIScrollView            *_scrollView;
    UIPageControl           *_pageControl;
}
@end

@implementation UserGuideViewController

- (id)init
{
    self = [super init];
    if (self)
    {
        // Custom initialization
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initContentView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navBarHidden = YES;
}

- (void)initContentView
{
    
    self.view.frame = [[UIScreen mainScreen] bounds];

    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), DEVICE_HEIGHT)];
    _scrollView.backgroundColor = COLOR_DEF_BG;
    _scrollView.contentSize = CGSizeMake(DEVICE_WIDTH*K_GuidePageCount, DEVICE_HEIGHT);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    for (int i=0; i<K_GuidePageCount; i++)
    {
        NSString *imgName = [NSString stringWithFormat:@"userGuide%d.png", i];
        UIImage *image = [UIImage imageNamed:imgName];
        int offsetY = (DEVICE_HEIGHT == 480)?44:0;
        CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(0, offsetY, DEVICE_WIDTH*SCREEN_SCALE, DEVICE_HEIGHT*SCREEN_SCALE));
        UIImageView *guideImgView = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:imageRef]];
        
        guideImgView.frame = CGRectMake(i*DEVICE_WIDTH, 0, DEVICE_WIDTH, DEVICE_HEIGHT);
        [_scrollView addSubview:guideImgView];
        
        if (i == K_GuidePageCount-1)
        {
            guideImgView.userInteractionEnabled = YES;
            
            UIButton *enterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            enterBtn.frame = CGRectMake(0, 0.f, 147, 40);
            enterBtn.center = CGPointMake(DEVICE_WIDTH / 2.f, DEVICE_HEIGHT - 60.f);
            [enterBtn setBackgroundImage:[UIImage imageNamed:@"btn_guide.png"] forState:UIControlStateNormal];
            [enterBtn addTarget:self action:@selector(enterBtnCliked) forControlEvents:UIControlEventTouchUpInside];
            [guideImgView addSubview:enterBtn];
        }
    }

    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, DEVICE_HEIGHT-35, DEVICE_WIDTH, 20)];
    _pageControl.backgroundColor = [UIColor clearColor];
    _pageControl.currentPage = 0;
    _pageControl.numberOfPages = K_GuidePageCount;
    [self.view addSubview:_pageControl];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)enterBtnCliked
{
    [RTLHelper gotoRootViewController];

}

#pragma mark UIScrollViewDelegate
#pragma mark - UIScrollView delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)sender
{
    int xOffset = sender.contentOffset.x;
    _pageControl.currentPage = (xOffset)/DEVICE_WIDTH;
}


@end
