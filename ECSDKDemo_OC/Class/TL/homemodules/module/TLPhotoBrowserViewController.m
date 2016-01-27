//
//  TLPhotoBrowserViewController.m
//  TL
//
//  Created by Rainbow on 2/15/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "TLPhotoBrowserViewController.h"

@interface TLPhotoBrowserViewController ()<MWPhotoBrowserDelegate>
@property (nonatomic,strong) NSMutableArray *photos;
@property (nonatomic,strong) NSMutableArray *thumbs;
@property (nonatomic,strong) NSMutableArray *selections;
@end

@implementation TLPhotoBrowserViewController


-(id)initWithTLPhotos:(NSMutableArray*)photos{
    if ((self = [self initWithDelegate:self])) {
        
        self.photos = photos;
        self.thumbs = photos;
        
        BOOL displayActionButton = YES;
        BOOL displaySelectionButtons = NO;
        BOOL displayNavArrows = NO;
        BOOL enableGrid = YES;
        BOOL startOnGrid = NO;

        self.displayActionButton = displayActionButton;
        self.displayNavArrows = displayNavArrows;
        self.displaySelectionButtons = displaySelectionButtons;
        self.alwaysShowControls = displaySelectionButtons;
        self.zoomPhotosToFill = NO;
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
        self.wantsFullScreenLayout = NO;
#endif
        self.enableGrid = enableGrid;
        self.startOnGrid = startOnGrid;
        self.enableSwipeToDismiss = YES;
        [self setCurrentPhotoIndex:0];
        // Reset selections
        if (displaySelectionButtons) {
            _selections = [NSMutableArray new];
            for (int i = 0; i < _photos.count; i++) {
                [_selections addObject:[NSNumber numberWithBool:NO]];
            }
        }
        
        
//        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
//        nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//        [self presentViewController:nc animated:YES completion:nil];
        
        
        // Test reloading of data after delay
        double delayInSeconds = 3;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            //        // Test removing an object
            //        [_photos removeLastObject];
            //        [browser reloadData];
            //
            //        // Test all new
            //        [_photos removeAllObjects];
            //        [_photos addObject:[MWPhoto photoWithFilePath:[[NSBundle mainBundle] pathForResource:@"photo3" ofType:@"jpg"]]];
            //        [browser reloadData];
            //
            //        // Test changing photo index
            //        [browser setCurrentPhotoIndex:9];
            
            //        // Test updating selections
            //        _selections = [NSMutableArray new];
            //        for (int i = 0; i < [self numberOfPhotosInPhotoBrowser:browser]; i++) {
            //            [_selections addObject:[NSNumber numberWithBool:YES]];
            //        }
            //        [browser reloadData];
            
        });

        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    
    // Create browser

    
    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - MWPhotoBrowserDelegate
#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
    if (index < _thumbs.count)
        return [_thumbs objectAtIndex:index];
    return nil;
}

//- (MWCaptionView *)photoBrowser:(MWPhotoBrowser *)photoBrowser captionViewForPhotoAtIndex:(NSUInteger)index {
//    MWPhoto *photo = [self.photos objectAtIndex:index];
//    MWCaptionView *captionView = [[MWCaptionView alloc] initWithPhoto:photo];
//    return [captionView autorelease];
//}

//- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser actionButtonPressedForPhotoAtIndex:(NSUInteger)index {
//    NSLog(@"ACTION!");
//}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index {
    NSLog(@"Did start viewing photo at index %lu", (unsigned long)index);
}

- (BOOL)photoBrowser:(MWPhotoBrowser *)photoBrowser isPhotoSelectedAtIndex:(NSUInteger)index {
    return [[_selections objectAtIndex:index] boolValue];
}

//- (NSString *)photoBrowser:(MWPhotoBrowser *)photoBrowser titleForPhotoAtIndex:(NSUInteger)index {
//    return [NSString stringWithFormat:@"Photo %lu", (unsigned long)index+1];
//}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index selectedChanged:(BOOL)selected {
    [_selections replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:selected]];
    NSLog(@"Photo at index %lu selected %@", (unsigned long)index, selected ? @"YES" : @"NO");
}

- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser {
    // If we subscribe to this method we must dismiss the view controller ourselves
    NSLog(@"Did finish modal presentation");
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
