//
//  CycleScrollView.m
//  PagedScrollView
//
//  Created by YF on 14-1-23.
//  Copyright (c) 2014年 Apple Inc. All rights reserved.
//

#import "CycleScrollView.h"
#import "NSTimer+Addition.h"

@interface CycleScrollView () <UIScrollViewDelegate>

@property (nonatomic , assign) NSInteger currentPageIndex;
@property (nonatomic , assign) NSInteger totalPageCount;
@property (nonatomic , strong) NSMutableArray *contentViews;
@property (nonatomic , strong) UIScrollView *scrollView;
@property (nonatomic , strong) GrayPageControl *myPageControl;

@property (nonatomic , strong) NSTimer *animationTimer;
@property (nonatomic , assign) NSTimeInterval animationDuration;
@property (nonatomic , assign) BOOL isPlaying;

@end

@implementation CycleScrollView

- (void)setTotalPagesCount:(NSInteger (^)(void))totalPagesCount
{
    _totalPageCount = totalPagesCount();
    if (_totalPageCount==1) {
        [self configContentOneView];
        return;
    }
    if (_totalPageCount > 0) {
        [self configContentViews];
        [self resumeAutoScrollAnim];
        [self createPageControler];
    }
}

- (id)initWithFrame:(CGRect)frame animationDuration:(NSTimeInterval)animationDuration
{
    if (self = [self initWithFrame:frame]) {
        self.animationDuration = animationDuration;
    }

    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizesSubviews = YES;
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.scrollView.autoresizingMask = 0xFF;
        self.scrollView.contentMode = UIViewContentModeCenter;
        self.scrollView.contentSize = CGSizeMake(3 * CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame));
        self.scrollView.delegate = self;
        self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.scrollView.frame), 0);
        self.scrollView.pagingEnabled = YES;
        [self addSubview:self.scrollView];
        self.currentPageIndex = 0;
    }
    return self;
}

-(void)createPageControler{
    float pageControlHeight = 18.0;
    CGRect pageViewRect = [self bounds];
    pageViewRect.size.height = pageControlHeight;
    pageViewRect.origin.y = self.scrollView.frame.size.height-pageControlHeight;
    
    self.myPageControl = [[GrayPageControl alloc] initWithFrame:pageViewRect];
    self.myPageControl.numberOfPages = _totalPageCount;
    self.myPageControl.currentPage = 0;
    [self addSubview:self.myPageControl];
    
}

- (void)stopAutoScrollAnim {
    if (!self.isPlaying) {
        return;
    }
    self.isPlaying = NO;
    [self.animationTimer pauseTimer];
    
    NSInteger offsetX = self.scrollView.contentOffset.x;
    NSInteger width = CGRectWidth(self.scrollView.frame);
    if (0 != offsetX % width) {
        offsetX = width * (offsetX / width);
        CGPoint newOffset = CGPointMake(offsetX, self.scrollView.contentOffset.y);
        [self.scrollView setContentOffset:newOffset animated:NO];
    }
}

- (void)resumeAutoScrollAnim {
    if (self.isPlaying) {
        return;
    }
    self.isPlaying = YES;
    if (self.totalPageCount > 1 && self.animationDuration > 0.0f) {
        self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:self.animationDuration
                                                               target:self
                                                             selector:@selector(animationTimerDidFired:)
                                                             userInfo:nil
                                                              repeats:YES];
        [self.animationTimer resumeTimerAfterTimeInterval:self.animationDuration];
    }
}

#pragma mark -
#pragma mark - 私有函数

- (void)configContentViews
{
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self setScrollViewContentDataSource];
    
    NSInteger counter = 0;
    for (UIView *contentView in self.contentViews) {
        contentView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentViewTapAction:)];
        [contentView addGestureRecognizer:tapGesture];
        CGRect rightRect = contentView.frame;
        rightRect.origin = CGPointMake(CGRectGetWidth(self.scrollView.frame) * (counter ++), 0);
        
        contentView.frame = rightRect;
        [self.scrollView addSubview:contentView];
    }
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0)];

    
}

- (void)configContentOneView
{
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    
    if (self.contentViews == nil) {
        self.contentViews = [@[] mutableCopy];
    }
    [self.contentViews removeAllObjects];
    
    if (self.fetchContentViewAtIndex) {
        [self.contentViews addObject:self.fetchContentViewAtIndex(0)];
    }
    
    
    NSInteger counter = 0;
    for (UIView *contentView in self.contentViews) {
        contentView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentViewTapAction:)];
        [contentView addGestureRecognizer:tapGesture];
        CGRect rightRect = contentView.frame;
        rightRect.origin = CGPointMake(CGRectGetWidth(self.scrollView.frame) * (counter ++), 0);
        
        contentView.frame = rightRect;
        [self.scrollView addSubview:contentView];
    }
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.frame),CGRectGetHeight(self.scrollView.frame));
    [_scrollView setContentOffset:CGPointMake(0, 0)];
    
    [self.animationTimer pauseTimer];
}

/**
 *  设置scrollView的content数据源，即contentViews
 */
- (void)setScrollViewContentDataSource
{
    NSInteger previousPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex - 1];
    NSInteger rearPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex + 1];
    if (self.contentViews == nil) {
        self.contentViews = [@[] mutableCopy];
    }
    [self.contentViews removeAllObjects];
    
    if (self.fetchContentViewAtIndex) {
        [self.contentViews addObject:self.fetchContentViewAtIndex(previousPageIndex)?self.fetchContentViewAtIndex(previousPageIndex):[UIView new]];
        [self.contentViews addObject:self.fetchContentViewAtIndex(_currentPageIndex)?self.fetchContentViewAtIndex(_currentPageIndex):[UIView new]];
        [self.contentViews addObject:self.fetchContentViewAtIndex(rearPageIndex)?self.fetchContentViewAtIndex(rearPageIndex):[UIView new]];
    }
}

- (NSInteger)getValidNextPageIndexWithPageIndex:(NSInteger)currentPageIndex;
{
    if(currentPageIndex == -1) {
        return self.totalPageCount - 1;
    } else if (currentPageIndex == self.totalPageCount) {
        return 0;
    } else {
        return currentPageIndex;
    }
}

#pragma mark -
#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.animationTimer pauseTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.animationTimer resumeTimerAfterTimeInterval:self.animationDuration];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_totalPageCount==1) {
        return;
    }
    int contentOffsetX = scrollView.contentOffset.x;
    if(contentOffsetX >= (2 * CGRectGetWidth(scrollView.frame))) {
        self.currentPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex + 1];

        [self configContentViews];
    }
    if(contentOffsetX <= 0) {
        self.currentPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex - 1];

        [self configContentViews];
    }
    
    self.myPageControl.currentPage = self.currentPageIndex;
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [scrollView setContentOffset:CGPointMake(CGRectGetWidth(scrollView.frame), 0) animated:YES];
}

#pragma mark -
#pragma mark - 响应事件

- (void)animationTimerDidFired:(NSTimer *)timer
{
    CGPoint newOffset = CGPointMake(self.scrollView.contentOffset.x + CGRectGetWidth(self.scrollView.frame), self.scrollView.contentOffset.y);
    
    if (newOffset.x>=2 * CGRectGetWidth(self.scrollView.frame)) {
        newOffset = CGPointMake(CGRectGetWidth(self.scrollView.frame)*2, self.scrollView.contentOffset.y);
    }
    
    [self.scrollView setContentOffset:newOffset animated:YES];
    
}

- (void)contentViewTapAction:(UITapGestureRecognizer *)tap
{
    if (self.TapActionBlock) {
        self.TapActionBlock(self.currentPageIndex);
    }
}


@end



@implementation GrayPageControl

-(id) initWithFrame:(CGRect)frame

{
    self = [super initWithFrame:frame];

    activeImage = [UIImage imageNamed:@"ico_jdt1"];
    
    inactiveImage = [UIImage imageNamed:@"ico_jdt2"];

    return self;
    
}
- (void)awakeFromNib
{
    self.pageIndicatorTintColor = [UIColor clearColor];
    self.currentPageIndicatorTintColor = [UIColor clearColor];
}

-(void) updateDots
{
    for (int i = 0; i < [self.subviews count]; i++)
    {
        UIImageView * dot = [self imageViewForSubview:  [self.subviews objectAtIndex: i]];
        if (i == self.currentPage) dot.image = activeImage;
        else dot.image = inactiveImage;
    }
}
- (UIImageView *) imageViewForSubview: (UIView *) view
{
    UIImageView * dot = nil;
    if ([view isKindOfClass: [UIView class]])
    {
        for (UIView* subview in view.subviews)
        {
            if ([subview isKindOfClass:[UIImageView class]])
            {
                dot = (UIImageView *)subview;
                break;
            }
        }
        if (dot == nil)
        {
            dot = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, view.frame.size.width, view.frame.size.height)];
            [view addSubview:dot];
        }
    }
    else
    {
        dot = (UIImageView *) view;
    }
    
    return dot;
}

-(void)setCurrentPage:(NSInteger)page
{
    [super setCurrentPage:page];
    [self updateDots];
}


@end
