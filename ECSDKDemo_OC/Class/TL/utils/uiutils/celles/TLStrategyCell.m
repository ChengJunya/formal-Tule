//
//  TLStrategyCell.m
//  TL
//
//  Created by Rainbow on 2/8/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "TLStrategyCell.h"
#import "ZXUIHelper.h"
#import "TLTripDataDTO.h"

@interface TLStrategyCell()
@end
@implementation TLStrategyCell

-(void)initContent{
    //titlebox
    //contentbox
    TLTripDataDTO *cellDTO = self.cellData;
    CGFloat cellTempHeight = 200.f;
    
    if (self.cellContentView) {
        [self.cellContentView removeFromSuperview];
        self.cellContentView = nil;
    }

    self.cellContentView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:self.cellContentView];
    
    NSString *cityStr = cellDTO.cityName;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:FONT_18,NSFontAttributeName ,nil];
    CGSize cityStrSize = [cityStr sizeWithAttributes:dic];
    
   
    
    /*
     @{@"ID":@"101",@"TYPE":@"1",@"CITY":@"杭州",@"TITLE":@"离别有期，相聚有时",@"PUBLISHTIME":@"2014-1-12",@"SCOUNT":@"1243",@"COMMENT_COUNT":@"1232",@"COLLECT_COUNT":@"1211",@"CONTENT":@"这一次简短的攻略，你也许看累了冰冷的大片，看类了刻意的摆拍。。。这一次我们尝试用一种及时的公路片，，，，这么多，我在测试呢。。。",@"IMAGES":@[@{@"IMAGENAME":@"PHOTO_20150101",@"IMAGE_URL":@"http://hiphotos.baidu.com/lvpics/pic/item/902397dda144ad345098d664d0a20cf431ad8529.jpg"},@{@"IMAGENAME":@"PHOTO_20150102",@"IMAGE_URL":@"http://hiphotos.baidu.com/lvpics/pic/item/73ca5910b8217aa4c3ce79a8.jpg"}],@"USER":@{@"USER_NAME":@"途乐MAN",@"USER_ID":@"20151001",@"USER_ICON":@"http://hiphotos.baidu.com/lvpics/pic/item/1cd4147b4e3bbaad0ad187aa.jpg"}}    
     */
     
    //1-添加背景图 2-添加城市文字 3-添加用户头像 4-添加攻略名称 5-添加时间 6-添加人气文字

    NSString *bgImageUrl = cellDTO.userPic;
    bgImageUrl = [NSString stringWithFormat:@"%@%@",TL_SERVER_BASE_URL,bgImageUrl];
//    CGFloat imageHeight = self.cellContentView.height;
//    CGFloat imageWidth = self.cellContentView.width;
    if (bgImageUrl.length>0) {
        UIImageView *cellImage = [[UIImageView alloc] initWithFrame:self.cellContentView.bounds];
        [self.cellContentView addSubview:cellImage];
        //cellImage.backgroundColor = UIColorFromRGBA(0x000000, 0.5);
        //cellImage.alpha = 0.f;
        [cellImage sd_setImageWithURL:[NSURL URLWithString:bgImageUrl] placeholderImage:[UIImage imageNamed:@"ico_loading_logo"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            cellImage.image = [RUtiles changeImage:image height:cellImage.height width:cellImage.width];
        }];
        
        
        
        
        
        //cellImage.image = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([cellImage.image CGImage], CGRectMake(0.f, 0.f, newImageWidth, newImageHeight))];
        
        
        
        
        
//        [cellImage sd_setImageWithURL:[NSURL URLWithString:bgImageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            
//            
//            
//            
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                float quality = .00001f;
//                float blurred = .2f;
//                NSData *imageData = UIImageJPEGRepresentation(image, quality);
//                UIImage *blurredImage = [[UIImage imageWithData:imageData] drn_boxblurImageWithBlur:blurred withTintColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]];
//                if (blurredImage==nil) {
//                    blurredImage = [UIImage imageNamed:@"ico_loading_logo_1x2.jpg"];
//                }
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    cellImage.image = blurredImage;
//                    [UIView animateWithDuration:0.5 animations:^{
//                        cellImage.alpha = 1.f;
//                    } completion:^(BOOL finished) {
//                        
//                    }];
//                    
//                });
//                
//                
//            });
//            
//            
//            
//            
//        }];
        cellImage.height = cellTempHeight;
       

        
        CALayer *bottomBgLayer = [CALayer layer];
        bottomBgLayer.frame = CGRectMake(0.f, cellImage.height-60.f, cellImage.width, 60.f);
        bottomBgLayer.backgroundColor = UIColorFromRGBA(0x000000, 0.5).CGColor;
        [cellImage.layer addSublayer:bottomBgLayer];
        
        
        CALayer *topBgLayer = [CALayer layer];
        topBgLayer.frame = CGRectMake(-10.f, 8.f, cityStrSize.width+30, cityStrSize.height+4);
        topBgLayer.backgroundColor = UIColorFromRGBA(0x000000, 0.5).CGColor;
        topBgLayer.cornerRadius = 5.f;
        [cellImage.layer addSublayer:topBgLayer];

    }
    
   
    
   
    
//    CALayer *vlineLayer = [CALayer layer];
//    vlineLayer.frame = CGRectMake(12.f, 11.f, 1.5f, cityStrSize.height-2);
//    vlineLayer.backgroundColor = UIColorFromRGBA(0xf2d494, 0.5).CGColor;
//    vlineLayer.borderColor = [UIColor blackColor].CGColor;
//    vlineLayer.borderWidth = 0.5f;
//
//    [self.cellContentView.layer addSublayer:vlineLayer];
    self.cellContentView.height = cellTempHeight;
    //<font face='HelveticaNeue-CondensedBold' size=20 stroke=1>Text with strokes</font>
    UILabel *cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.f, 10.f, cityStrSize.width+30.f, cityStrSize.height)];
    cityLabel.text = [NSString stringWithFormat:@"%@",cityStr];
    cityLabel.textColor = [UIColor whiteColor];
    //cityLabel.strokeColor = [UIColor blackColor];
    cityLabel.font = FONT_18;
    //cityLabel.strokeSize = 0.5f;
    [self.cellContentView addSubview:cityLabel];
    
    
    
    
    
   
    
    
    CGFloat userIconHeight = 40.f;
    NSString *userIconUrl = cellDTO.userIcon;
     userIconUrl = [NSString stringWithFormat:@"%@%@",TL_SERVER_BASE_URL,userIconUrl];
    if (userIconUrl.length>0) {

        UIImageView *userImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.cellContentView.width-userIconHeight-10.f, self.cellContentView.height-userIconHeight-10.f, userIconHeight, userIconHeight)];
        userImageView.layer.borderWidth = 1.f;
        userImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        [self.cellContentView addSubview:userImageView];
        
        [userImageView sd_setImageWithURL:[NSURL URLWithString:userIconUrl] placeholderImage:[UIImage imageNamed:@"ico_loading_logo_1x1.jpg"]];
        
        
        
    }
    
    NSString *titleStr = cellDTO.title;
    NSDictionary *titleDic = [NSDictionary dictionaryWithObjectsAndKeys:FONT_16,NSFontAttributeName ,nil];
    CGSize titleSize = [titleStr sizeWithAttributes:titleDic];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.cellContentView.width-userIconHeight-20.f-titleSize.width, self.cellContentView.height-userIconHeight-10.f, titleSize.width+10.f, titleSize.height)];
    titleLabel.text = titleStr;
    titleLabel.textColor = [UIColor whiteColor];
    //titleLabel.strokeColor = [UIColor blackColor];
    titleLabel.font = FONT_16;
    //titleLabel.strokeSize = 0.5f;
    [self.cellContentView addSubview:titleLabel];
    
    
    
    NSString *infoStr = [NSString stringWithFormat:@"%@ · %@人气",cellDTO.createTime,cellDTO.viewCount];
    NSDictionary *infoDic = [NSDictionary dictionaryWithObjectsAndKeys:FONT_12,NSFontAttributeName ,nil];
    CGSize infoSize = [infoStr sizeWithAttributes:infoDic];
    
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.cellContentView.width-userIconHeight-20.f-infoSize.width, self.cellContentView.height-infoSize.height-10.f, infoSize.width+10.f, infoSize.height)];
    infoLabel.text = infoStr;
    infoLabel.textColor = [UIColor whiteColor];
    //infoLabel.strokeColor = [UIColor blackColor];
    infoLabel.font = FONT_12;
    //infoLabel.strokeSize = 0.5f;
    [self.cellContentView addSubview:infoLabel];

    
   
    
    
    self.cellHeight = self.cellContentView.height+10.f;
    
}






- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    
    // Configure the view for the selected state
    if (selected) {
        NSLog(@"selected");
        self.backgroundColor = [UIColor clearColor];
        
        //[self action];
        
    }else{
        NSLog(@"unSelected");
        self.backgroundColor = [UIColor clearColor];
    }
    
}

@end
