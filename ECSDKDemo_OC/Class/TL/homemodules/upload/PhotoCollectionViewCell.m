//
//  PhotoCollectionViewCell.m
//
//  Created by dkhamsing on 3/20/14.
//
//

#import "PhotoCollectionViewCell.h"

static CGFloat PhotoShowImageSpaceOffset = 10.f;

@interface PhotoCollectionViewCell () {
    UIImageView *_showImageView;
    UIButton *_closeButton;
}

@end

@implementation PhotoCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
        self.contentView.userInteractionEnabled = YES;
        
        CGRect imageRect = self.bounds;
        imageRect.origin.y = PhotoShowImageSpaceOffset;
        imageRect.size.width = CGRectGetWidth(imageRect) - PhotoShowImageSpaceOffset;
        imageRect.size.height = CGRectHeight(imageRect) - PhotoShowImageSpaceOffset;
        UIImageView *showImageView = [[UIImageView alloc] initWithFrame:imageRect];
        showImageView.contentMode = UIViewContentModeScaleAspectFill;
        showImageView.clipsToBounds = YES;
        [self.contentView addSubview:showImageView];
        _showImageView = showImageView;
        
        UIImage *closeImage = [UIImage imageNamed:@"ico_delete"];
        UIButton *closeButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [closeButton setBackgroundImage:closeImage forState:(UIControlStateNormal)];
        closeButton.frame = CGRectMake(0.f, 0.f, 21.5f, 21.5f);
        closeButton.center = CGPointMake(CGRectGetWidth(imageRect)-3.f, CGRectGetMinY(imageRect)+3.f);
        [self.contentView addSubview:closeButton];
        _closeButton = closeButton;
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    _showImageView.image = nil;
}

@end
