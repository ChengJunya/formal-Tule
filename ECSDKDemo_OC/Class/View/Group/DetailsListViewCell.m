//
//  DetailsListViewCell.m
//  ECSDKDemo_OC
//
//  Created by lrn on 14/12/12.
//  Copyright (c) 2014年 ronglian. All rights reserved.
//

#import "DetailsListViewCell.h"

@implementation DetailsListViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _headImage = [[UIImageView alloc] initWithFrame:CGRectMake(20.0f, 10.0f, 45.0f, 45.0f)];
        _headImage.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_headImage];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(80.0f, 17.5f, self.frame.size.width-80.0f-60.0f, 30.0f)];
        _nameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.contentView addSubview:_nameLabel];
        
        _removeBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width-60.0f, 15.0f, 60.0f, 35.0f)];
        [_removeBtn setTitle:@"踢出" forState:UIControlStateNormal];
        [_removeBtn setTitleColor:[UIColor colorWithRed:0.04f green:0.75f blue:0.40f alpha:1.00f] forState:UIControlStateNormal];
        _removeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_removeBtn];
    }
    return self;
}
@end
