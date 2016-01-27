//
//  TLWayBookCell.m
//  TL
//
//  Created by Rainbow on 2/15/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "TLWayBookCell.h"
#import "ZXImageUtils.h"
#import "UIImage+ImageEffects.h"
#import "TLTripDataDTO.h"
#import "TLTripTravelDTO.h"

@implementation TLWayBookCell


-(void)initContent{
        TLTripDataDTO *cellDTO = self.cellData;
    //titlebox
    //contentbox
//    self.backgroundColor = UIColorFromRGBA(0x000000, 0.5);
    CGFloat cellTempHeight = 200.f;
    
    if (self.cellContentView) {
        [self.cellContentView removeFromSuperview];
        self.cellContentView = nil;
    }
    
    self.cellContentView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:self.cellContentView];
    
   
    
    
    
    /*
     @{@"ID":@"101",@"TYPE":@"1",@"CITY":@"杭州",@"TITLE":@"离别有期，相聚有时",@"PUBLISHTIME":@"2014-1-12",@"SCOUNT":@"1243",@"COMMENT_COUNT":@"1232",@"COLLECT_COUNT":@"1211",@"CONTENT":@"这一次简短的攻略，你也许看累了冰冷的大片，看类了刻意的摆拍。。。这一次我们尝试用一种及时的公路片，，，，这么多，我在测试呢。。。",@"IMAGES":@[@{@"IMAGENAME":@"PHOTO_20150101",@"IMAGE_URL":@"http://hiphotos.baidu.com/lvpics/pic/item/902397dda144ad345098d664d0a20cf431ad8529.jpg"},@{@"IMAGENAME":@"PHOTO_20150102",@"IMAGE_URL":@"http://hiphotos.baidu.com/lvpics/pic/item/73ca5910b8217aa4c3ce79a8.jpg"}],@"USER":@{@"USER_NAME":@"途乐MAN",@"USER_ID":@"20151001",@"USER_ICON":@"http://hiphotos.baidu.com/lvpics/pic/item/1cd4147b4e3bbaad0ad187aa.jpg"}}
     */
    
    //1-添加背景图 2-添加城市文字 3-添加用户头像 4-添加攻略名称 5-添加时间 6-添加人气文字


    
    
    NSString *bgImageUrl = [NSString stringWithFormat:@"%@%@",TL_SERVER_BASE_URL,cellDTO.userPic];
    //    CGFloat imageHeight = self.cellContentView.height;
    //    CGFloat imageWidth = self.cellContentView.width;
    if (bgImageUrl) {
        UIImageView *cellImage = [[UIImageView alloc] initWithFrame:self.cellContentView.bounds];
        cellImage.backgroundColor = UIColorFromRGBA(0x000000, 0.5);
        cellImage.alpha = 0.f;
        [self.cellContentView addSubview:cellImage];
        //[cellImage sd_setImageWithURL:[NSURL URLWithString:bgImageUrl] placeholderImage:[UIImage imageNamed:@"ico_loading_logo"]];
        [cellImage sd_setImageWithURL:[NSURL URLWithString:bgImageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            

            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                float quality = .00001f;
                float blurred = .2f;
                NSData *imageData = UIImageJPEGRepresentation(image, quality);
                UIImage *blurredImage = [[UIImage imageWithData:imageData] drn_boxblurImageWithBlur:blurred withTintColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]];
                dispatch_async(dispatch_get_main_queue(), ^{
//                    cellImage.image = blurredImage;
                    cellImage.image = [RUtiles changeImage:blurredImage height:cellImage.height width:cellImage.width];
                    [UIView animateWithDuration:0.5 animations:^{
                        cellImage.alpha = 1.f;
                    } completion:^(BOOL finished) {
                        
                    }];
                    
                });
                

            });
            
            
            
            
        }];
        
        
        
        
        cellImage.height = cellTempHeight;
        
        
        
//        CALayer *bottomBgLayer = [CALayer layer];
//        bottomBgLayer.frame = CGRectMake(0.f, 0.f, cellImage.width, 60.f);
//        bottomBgLayer.backgroundColor = UIColorFromRGBA(0x000000, 0.5).CGColor;
//        [cellImage.layer addSublayer:bottomBgLayer];
//        
//        
//        CALayer *topBgLayer = [CALayer layer];
//        topBgLayer.frame = CGRectMake(-10.f, 8.f, cityStrSize.width+30, cityStrSize.height+4);
//        topBgLayer.backgroundColor = UIColorFromRGBA(0x000000, 0.5).CGColor;
//        topBgLayer.cornerRadius = 5.f;
//        [cellImage.layer addSublayer:topBgLayer];
        
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
    
    
//    UILabel *cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.f, 10.f, cityStrSize.width+30.f, cityStrSize.height)];
//    cityLabel.text = [NSString stringWithFormat:@"%@",cityStr];
//    cityLabel.textColor = [UIColor whiteColor];
//    //cityLabel.strokeColor = [UIColor blackColor];
//    cityLabel.font = FONT_18;
//    //cityLabel.strokeSize = 0.5f;
//    [self.cellContentView addSubview:cityLabel];
    
    
    
    
    
    
    
    
    CGFloat userIconHeight = 40.f;
    NSString *userIconUrl = [NSString stringWithFormat:@"%@%@",TL_SERVER_BASE_URL,cellDTO.userIcon];
    if (userIconUrl) {
        
        UIImageView *userImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10.f, 10.f, userIconHeight, userIconHeight)];
        userImageView.layer.borderWidth = 1.f;
        userImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        [self.cellContentView addSubview:userImageView];
        
        [userImageView sd_setImageWithURL:[NSURL URLWithString:userIconUrl] placeholderImage:[UIImage imageNamed:@"ico_loading_logo"]];
        
        
        
    }
    
    NSString *titleStr = cellDTO.title;
    NSDictionary *titleDic = [NSDictionary dictionaryWithObjectsAndKeys:FONT_16,NSFontAttributeName ,nil];
    CGSize titleSize = [titleStr sizeWithAttributes:titleDic];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(userIconHeight+20.f, 10.f, titleSize.width+10.f, titleSize.height)];
    titleLabel.text = titleStr;
    titleLabel.textColor = [UIColor whiteColor];
    //titleLabel.strokeColor = [UIColor blackColor];
    titleLabel.font = FONT_16;
    //titleLabel.strokeSize = 0.5f;
    [self.cellContentView addSubview:titleLabel];
    
    
    
    NSString *infoStr = [NSString stringWithFormat:@"%@ · %@人气",cellDTO.createTime,cellDTO.viewCount];
    NSDictionary *infoDic = [NSDictionary dictionaryWithObjectsAndKeys:FONT_14,NSFontAttributeName ,nil];
    CGSize infoSize = [infoStr sizeWithAttributes:infoDic];
    
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(userIconHeight+20.f, 10.f+userIconHeight-infoSize.height, infoSize.width+10.f, infoSize.height)];
    infoLabel.text = infoStr;
    infoLabel.textColor = [UIColor whiteColor];
    //infoLabel.strokeColor = [UIColor blackColor];
    infoLabel.font = FONT_14;
    //infoLabel.strokeSize = 0.5f;
    [self.cellContentView addSubview:infoLabel];
    
    
    NSArray<TLTripTravelDTO> *wayNodeArray = cellDTO.travel;
    CGFloat nodePaddingLeft = 60.f;
    CGFloat nodePddingTop = userIconHeight + 50.f;
    CGFloat nodeVGap = 50.0f;
    CGFloat pointVGap = 7.f;
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:FONT_18,NSFontAttributeName ,nil];
    if (wayNodeArray.count>0) {
        TLTripTravelDTO *travelNode1 = wayNodeArray[0];
        NSString *cityStr =  travelNode1.cityName;
        
        CGSize cityStrSize = [cityStr sizeWithAttributes:dic];
        NSString *node1Contex = travelNode1.content;
        CGSize node1ContexSize = [node1Contex sizeWithAttributes:infoDic];
        
        UILabel *cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(nodePaddingLeft, nodePddingTop, cityStrSize.width, cityStrSize.height)];
        cityLabel.text = [NSString stringWithFormat:@"%@",cityStr];
        cityLabel.textColor = [UIColor orangeColor];
        //cityLabel.strokeColor = [UIColor blackColor];
        cityLabel.font = FONT_18;
        //cityLabel.strokeSize = 0.5f;
        [self.cellContentView addSubview:cityLabel];
        
        
        UILabel *node1ContexLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.f+cityStrSize.width+nodePaddingLeft, nodePddingTop+(cityStrSize.height-node1ContexSize.height)/2, CGRectGetWidth(self.cellContentView.frame)-30.f-cityStrSize.width-nodePaddingLeft, node1ContexSize.height)];
        node1ContexLabel.text = [NSString stringWithFormat:@"%@",node1Contex];
        node1ContexLabel.textColor = [UIColor whiteColor];
        //cityLabel.strokeColor = [UIColor blackColor];
        node1ContexLabel.font = FONT_14;
        //cityLabel.strokeSize = 0.5f;
        [self.cellContentView addSubview:node1ContexLabel];
        
        
    }
    if (wayNodeArray.count>1) {
    
        TLTripTravelDTO *travelNode2 = wayNodeArray[1];
        NSString *city2Str = travelNode2.cityName;
        CGSize city2StrSize = [city2Str sizeWithAttributes:dic];
        NSString *node2Contex = travelNode2.content;
        CGSize node2ContexSize = [node2Contex sizeWithAttributes:infoDic];
        
        

        
        UILabel *city2Label = [[UILabel alloc] initWithFrame:CGRectMake(nodePaddingLeft, nodePddingTop+nodeVGap, city2StrSize.width, city2StrSize.height)];
        city2Label.text = [NSString stringWithFormat:@"%@",city2Str];
        city2Label.textColor = [UIColor whiteColor];
        //cityLabel.strokeColor = [UIColor blackColor];
        city2Label.font = FONT_18;
        //cityLabel.strokeSize = 0.5f;
        [self.cellContentView addSubview:city2Label];
        
        
        UILabel *node2ContexLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.f+city2StrSize.width+nodePaddingLeft, nodePddingTop+nodeVGap+(city2StrSize.height-node2ContexSize.height)/2, CGRectGetWidth(self.cellContentView.frame)-30.f-city2StrSize.width-nodePaddingLeft, node2ContexSize.height)];
        node2ContexLabel.text = [NSString stringWithFormat:@"%@",node2Contex];
        node2ContexLabel.textColor = [UIColor whiteColor];
        //cityLabel.strokeColor = [UIColor blackColor];
        node2ContexLabel.font = FONT_14;
        //cityLabel.strokeSize = 0.5f;
        [self.cellContentView addSubview:node2ContexLabel];
        
        
        CALayer *startWhiteAnchor = [CALayer layer];
        startWhiteAnchor.frame = CGRectMake(nodePaddingLeft-10.f-pointVGap, nodePddingTop+pointVGap, 10.f, 10.f);
        startWhiteAnchor.cornerRadius = 5.f;
        startWhiteAnchor.backgroundColor = [[UIColor whiteColor] CGColor];
        CALayer *startRedAnchor = [CALayer layer];
        startRedAnchor.frame = CGRectMake(nodePaddingLeft-8.f-pointVGap, nodePddingTop+2+pointVGap, 6.f, 6.f);
        startRedAnchor.cornerRadius = 3.f;
        startRedAnchor.backgroundColor = [[UIColor redColor] CGColor];
        
        CALayer *endWhiteAnchor = [CALayer layer];
        endWhiteAnchor.frame = CGRectMake(nodePaddingLeft-8.f-pointVGap, nodePddingTop+nodeVGap+pointVGap, 6.f, 6.f);
        endWhiteAnchor.cornerRadius = 3.f;
        endWhiteAnchor.backgroundColor = [[UIColor whiteColor] CGColor];
        
        CALayer *vline = [CALayer layer];
        vline.frame = CGRectMake(CGRectGetMaxX(startWhiteAnchor.frame)-6.f, CGRectGetMaxY(startWhiteAnchor.frame)+pointVGap, 2.f, nodeVGap-city2StrSize.height-pointVGap+2);
        vline.backgroundColor = [[UIColor orangeColor] CGColor];
        
        
        [self.cellContentView.layer addSublayer:startWhiteAnchor];
        [self.cellContentView.layer addSublayer:startRedAnchor];
        [self.cellContentView.layer addSublayer:endWhiteAnchor];
        [self.cellContentView.layer addSublayer:vline];
        
    }
    
    
    
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
