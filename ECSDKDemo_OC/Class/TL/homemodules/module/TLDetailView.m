//
//  TLDetailView.m
//  TL
//
//  Created by Rainbow on 2/10/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "TLDetailView.h"
#import "ImagePlayerView.h"
#import "RIconTextBtn.h"
#import "TLTuleAdView.h"
#import "TLTripDetailDTO.h"
#import "TLImageDTO.h"
#import "TLHelper.h"
#import "CMenuView.h"
#import "UserDataHelper.h"
#import "TLModuleDataHelper.h"
#import "TLIsTopRequestDTO.h"
#import "TLIsTopResponseDTO.h"
#import "TLNewStrategyViewController.h"
#import "TLNewTripNoteViewController.h"
#import "TLNewWayBookViewController.h"
#import "TLNewWaybookNodeViewController.h"
#import "RUtiles.h"
@interface TLDetailView()<ImagePlayerViewDelegate,CMenuViewDelegate>{
    CGFloat maxUserImageY;
    RIconTextBtn *isTopButton ;
    BOOL isTop;//是否置顶
}
@property (nonatomic,strong) ImagePlayerView *imagePlayerView;
@property (nonatomic,strong) NSArray *imageURLs;


@end
@implementation TLDetailView


//1-图片 2-名称 3-发布时间 4-分类 5-好评 6-评论 7-人气  8-用户  9-文字内容  10-分享 11-收藏 12-下载图片 13-聊天

- (instancetype)initWithFrame:(CGRect)frame viewData:(id)viewData type:(NSString*)type
{
    self = [super initWithFrame:frame];
    if (self) {
        _type = type;
        _viewData = viewData;
        _yOffSet = 0.f;
        _viewContentScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0.f, 0.f, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        [self addSubview:_viewContentScroll];
        _viewContentScroll.contentSize = CGSizeMake(CGRectGetWidth(self.frame), _yOffSet);
        [self setUpViews];

        
        _viewContentScroll.contentSize = CGSizeMake(CGRectGetWidth(self.frame), _yOffSet);
    }
    return self;
}

-(void)setUpViews{
    [self addImageView];
    [self addUserIcon];
    [self addTitle];
    [self addPublishDate];
    [self addCity];
    [self addInfoView];
    
    [self validateYOffSet];
    [self addOperButtons];
    [self addTextContent];
            //        [self addTLAdView];
}

-(void)validateYOffSet{
    self.yOffSet = MAX(self.yOffSet, maxUserImageY);
}

//添加图片/*****************************************************************************************************/
-(void)addImageView{
    TLTripDetailDTO *detailDto = self.viewData;
    
    if (detailDto.images.count<=0) {
        return;
    }
    
    //默认图片区域
    //UIView *imagePlayerViewFrame = [[UIView alloc] initWithFrame:CGRectMake(0.f ,NAVIGATIONBAR_HEIGHT+STATUSBAR_HEIGHT, CGRectGetWidth(self.view.frame), ImagePlayerView_Height)];
    
    
    
    
    //@"IMAGES":@[@{@"IMAGENAME":@"PHOTO_20150101",@"IMAGE_URL":@"http://hiphotos.baidu.com/lvpics/pic/item/902397dda144ad345098d664d0a20cf431ad8529.jpg"},@{@"IMAGENAME":@"PHOTO_20150102",@"IMAGE_URL":@"http://hiphotos.baidu.com/lvpics/pic/item/73ca5910b8217aa4c3ce79a8.jpg"}]
    
    self.imageURLs = detailDto.images;
    /*self.imageURLs = @[[NSURL URLWithString:@"http://www.51scjf.com/UploadFiles/FCK/2014-07/20140726848LL824XZ.jpg"],
     [NSURL URLWithString:@"http://img1.xcarimg.com/parts/10631/12306/608_456_20140824223503896075.jpg"],
     [NSURL URLWithString:@"http://bbra.cn/Uploadfiles/imgs/20110303/fengjin/039.jpg"],
     [NSURL URLWithString:@"http://bbra.cn/Uploadfiles/imgs/20110303/fengjin0/030.jpg"]];
     
     */
    self.imagePlayerView = [[ImagePlayerView alloc] initWithFrame:CGRectMake(0.f ,_yOffSet,CGRectGetWidth(self.frame) ,TLDETAILVIEW_IMAGE_BANNER_HEIGHT)];
    [_viewContentScroll addSubview:self.imagePlayerView];
    _yOffSet = _yOffSet+CGRectGetHeight(self.imagePlayerView.frame);
    
    
    
    [self.imagePlayerView initWithCount:self.imageURLs.count delegate:self];
    self.imagePlayerView.scrollInterval = 4.0f;
    // adjust pageControl position
    self.imagePlayerView.pageControlPosition = ICPageControlPosition_BottomRight;
    // hide pageControl or not
    self.imagePlayerView.hidePageControl = YES;
    
    
    
}




#pragma mark - ImagePlayerViewDelegate
- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView loadImageForImageView:(UIImageView *)imageView index:(NSInteger)index
{
    
    TLImageDTO *imageDto = self.imageURLs[index];
    
     NSString *imageUrl = [NSString stringWithFormat:@"%@%@",TL_SERVER_BASE_URL,imageDto.imageUrl];
    //NSString *url = [NSString stringWithFormat:@"%@",[[self.imageURLs objectAtIndex:index] valueForKey:@"IMAGE_URL"]];
    NSLog(@"DetailImageUrl:%@",imageUrl);
    [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"ico_loading_logo"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
         imageView.image = [RUtiles changeImage:image height:imagePlayerView.height width:imagePlayerView.width];
    }];
    
    
    
}

- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView didTapAtIndex:(NSInteger)index
{
    NSLog(@"点击详情图片");
    if (self.MoreImageBlock) {
        self.MoreImageBlock();
    }
}


/*********************************************************************************************************/


-(void)addUserIcon{
    TLTripDetailDTO *detailDto = self.viewData;
    NSDictionary *timeDic = [NSDictionary dictionaryWithObjectsAndKeys:FONT_14,NSFontAttributeName ,nil];
    if (detailDto.user==nil) {
        return;
    }
    //*****end add userImage ******
    NSString *userIconUrl = [NSString stringWithFormat:@"%@%@",TL_SERVER_BASE_URL,detailDto.user.userIcon];
    if (userIconUrl) {
        
        UIImageView *userImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)-TLDETAILVIEW_USER_IMAGE_HEIGHT-TLDETAILVIEW_H_GAP, _yOffSet+TLDETAILVIEW_V_GAP, TLDETAILVIEW_USER_IMAGE_HEIGHT, TLDETAILVIEW_USER_IMAGE_HEIGHT)];
        userImageView.layer.borderWidth = 0.5f;
        userImageView.layer.borderColor = [UIColor grayColor].CGColor;
        userImageView.layer.cornerRadius = TLDETAILVIEW_USER_IMAGE_HEIGHT/2;
        [_viewContentScroll addSubview:userImageView];
        userImageView.layer.masksToBounds = YES;
        
        [userImageView sd_setImageWithURL:[NSURL URLWithString:userIconUrl] placeholderImage:[UIImage imageNamed:@"ico_loading_logo"]];
        
        userImageView.onTouchTapBlock = ^(UIImageView *imageView){
             [RTLHelper gotoUserInfoView:detailDto.user.loginId];
            
        };

        
        
    }
    
    NSString *userName = detailDto.user.userName;
    CGSize userNameSize = [userName sizeWithAttributes:timeDic];
    UILabel *userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)-TLDETAILVIEW_H_GAP-TLDETAILVIEW_USER_IMAGE_HEIGHT/2-userNameSize.width/2, _yOffSet+TLDETAILVIEW_V_GAP*2+TLDETAILVIEW_USER_IMAGE_HEIGHT, userNameSize.width, userNameSize.height)];
    userNameLabel.font = FONT_14;
    userNameLabel.text = userName;
    userNameLabel.textColor = COLOR_MAIN_TEXT;
    [_viewContentScroll addSubview:userNameLabel];
    
    maxUserImageY = CGRectGetMaxY(userNameLabel.frame)+TLDETAILVIEW_V_GAP;
    
    //*****end userImage ******
    
    //添加纠错按钮
    
    
}

-(void)addIsTopView:(RIconTextBtn*)btn{
    TLTripDetailDTO *detailDto = self.viewData;
    TLIsTopRequestDTO *request = [[TLIsTopRequestDTO alloc] init];
    request.objId = detailDto.travelId;
    request.type = [self.type substringToIndex:1];
    

    [GHUDAlertUtils toggleLoadingInView:self];
    [GTLModuleDataHelper isTop:request requestArray:[NSMutableArray array] block:^(id obj, BOOL ret) {
        [GHUDAlertUtils hideLoadingInView:self];
        if (ret) {
            TLIsTopResultDTO *dto = obj;

            NSLog(@"%@",dto);
            if (dto.isTop.integerValue==1) {
                btn.hidden = NO;
                isTop = YES;
                [btn setTitle:dto.topEndTime.length>9?[dto.topEndTime substringToIndex:10]:dto.topEndTime forState:UIControlStateNormal];
            }else{
                btn.hidden = YES;
                isTop = NO;
            }
            
        }else{
            ResponseDTO *response = obj;
            [GHUDAlertUtils toggleMessage:response.resultDesc];
        }
        
    }];
}


-(void)addOperButtons{
    TLTripDetailDTO *detailDto = self.viewData;
    if (![GUserDataHelper isLoginUser:detailDto.user.loginId]) {
        return;
    }
    
    
    CGFloat menuHeight = 50.f;
    CMenuView *menuView = [[CMenuView alloc] initWithFrame:CGRectMake(0.0, self.yOffSet, self.width,menuHeight)];
    menuView.delegate = self;
    menuView.columnCount = 3;
    menuView.rowCount = 1;
    menuView.alpha = 1;
    menuView.backgroundColor = COLOR_WHITE_BG;
    [_viewContentScroll addSubview:menuView];
    
    
    [menuView randerViewWithData:@[
   @{@"ID":@"1",@"NAME":@"重新置顶",@"IMG":@"stick_set",@"VCNAME":@"TLStrategyListViewController",@"TYPE":@"1",@"DATATYPE":@"1"},
   @{@"ID":@"2",@"NAME":@"编辑发布",@"IMG":@"modification",@"VCNAME":@"TLWayBookListViewController",@"TYPE":@"2",@"DATATYPE":@"1"},
   @{@"ID":@"3",@"NAME":@"删除发布",@"IMG":@"delete",@"VCNAME":@"TLTripNoteListViewController",@"TYPE":@"3",@"DATATYPE":@"1"}]];
    
    
    _yOffSet = _yOffSet+TLDETAILVIEW_V_GAP+menuHeight;
}


-(void)itemClick:(NSDictionary *)itemData{
    NSString *itemId = [itemData valueForKey:@"ID"];
    switch (itemId.integerValue) {
        case 1:
        {
            [self toTop];
            break;
        }
        case 2:
        {
            [self toUpdate];
            break;
        }
        case 3:
        {
            WEAK_SELF(self);
            [GHUDAlertUtils showZXColorAlert:@"是否确定删除？" subTitle:@"" cancleButton:MultiLanguage(comCancel) sureButtonTitle:MultiLanguage(comSure)  COLORButtonType:(RED_BUTTON_TYPE) buttonHeight:35 clickedBlock:^(ZXColorAlert *alert, NSUInteger index) {
                if (index == 1) {
                    
                    if (weakSelf.DeleteBlock) {
                        weakSelf.DeleteBlock();
                    }
                    
                }
            }];
            

            break;
        }
        default:
            break;
    }
}



-(void)toTop{

    if (isTop) {
        [GHUDAlertUtils toggleMessage:@"已经置顶，请置顶过期后重新置顶！"];
        return;
    }
    
    WEAK_SELF(self);
    [GHUDAlertUtils showZXColorAlert:@"如果置顶需要扣除途乐币，是否置顶？" subTitle:@"" cancleButton:MultiLanguage(comCancel) sureButtonTitle:MultiLanguage(comSure)  COLORButtonType:(RED_BUTTON_TYPE) buttonHeight:35 clickedBlock:^(ZXColorAlert *alert, NSUInteger index) {
        if (index == 1) {
            [weakSelf doTop];
        }
    }];
}

-(void)doTop{
    
    
    
    
    TLTripDetailDTO *detailDto = self.viewData;
    TLIsTopRequestDTO *request = [[TLIsTopRequestDTO alloc] init];
    request.objId = detailDto.travelId;
    
    request.type = [self.type substringToIndex:1];
    
    [GHUDAlertUtils toggleLoadingInView:self];
    [GTLModuleDataHelper doTop:request requestArray:[NSMutableArray array] block:^(id obj, BOOL ret) {
        [GHUDAlertUtils hideLoadingInView:self];
        if (ret) {
            TLIsTopResultDTO *dto = obj;
            [isTopButton setTitle:dto.topEndTime.length>9?[dto.topEndTime substringToIndex:10]:dto.topEndTime forState:UIControlStateNormal];
            [GHUDAlertUtils toggleMessage:@"置顶成功！"];
            NSLog(@"%@",dto);
            isTopButton.hidden = NO;
            isTop = YES;
            
        }else{
            ResponseDTO *response = obj;
            [GHUDAlertUtils toggleMessage:response.resultDesc];
        }
        
    }];
}
-(void)toUpdate{
    switch (self.type.integerValue) {
        case 1://攻略
        {
            [RTLHelper pushViewControllerWithName:@"TLNewStrategyViewController" itemData:self.viewData block:^(TLNewStrategyViewController* obj) {
                obj.operateType = @"2";//修改
            }];
            break;
        }
        case 2://游记
        {
            [RTLHelper pushViewControllerWithName:@"TLNewTripNoteViewController" itemData:self.viewData block:^(TLNewTripNoteViewController* obj) {
                obj.operateType = @"2";//修改
            }];
            
            break;
        }
        case 21://路书
        case 31://攻略
        {
            [RTLHelper pushViewControllerWithName:@"TLNewWayBookViewController" itemData:self.viewData block:^(TLNewWayBookViewController* obj) {
                obj.operateType = @"2";//修改
                obj.type = self.type.length>1?[self.type substringToIndex:1]:self.type;
            }];
            
            break;
        }
        case 22://路书节点
        case 32://攻略节点
        {
            
            [RTLHelper pushViewControllerWithName:@"TLNewWaybookNodeViewController" itemData:self.viewData block:^(TLNewWaybookNodeViewController* obj) {
                obj.operateType = @"2";//修改
                obj.type = self.type.length>1?[self.type substringToIndex:1]:self.type;
            }];
            break;
        }
        default:
            break;
    }
}
-(void)toDelete{
    if (self.DeleteBlock) {
        self.DeleteBlock();
    }
//    switch (self.type.integerValue) {
//        case 1://攻略
//        {
//            if (self.DeleteBlock) {
//                self.DeleteBlock();
//            }
//            break;
//        }
//        case 2://游记
//        {
//            
//            if (self.DeleteBlock) {
//                self.DeleteBlock();
//            }
//            break;
//        }
//        case 21://路书
//        case 31://游记
//        {
//            
//            if (self.DeleteBlock) {
//                self.DeleteBlock();
//            }
//            break;
//        }
//        case 22://路书节点
//        case 32://游记节点节点
//        {
//            
//            if (self.DeleteBlock) {
//                self.DeleteBlock();
//            }
//            break;
//        }
//        default:
//            break;
//    }
}


-(void)addTitle{
    TLTripDetailDTO *detailDto = self.viewData;
    NSString *title = detailDto.title;
    //addtitle ------
    NSString *titleStr = [NSString stringWithFormat:@"%@",title];
    NSDictionary *titleDic = [NSDictionary dictionaryWithObjectsAndKeys:FONT_14B,NSFontAttributeName ,nil];
    CGSize titleStrSize = [titleStr sizeWithAttributes:titleDic];
    
    
    
    //    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:titleStr];
    //
    //    NSRange start = [titleStr rangeOfString:@" - "];
    //
    //    [str addAttribute:NSForegroundColorAttributeName value:COLOR_MAIN_TEXT range:NSMakeRange(0,start.location+start.length)];
    //    [str addAttribute:NSForegroundColorAttributeName value:COLOR_BTN_SOLID_ORANGE_SUFACE range:NSMakeRange(start.location+3,titleStr.length-start.location-start.length)];
    
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(TLDETAILVIEW_H_GAP, _yOffSet+TLDETAILVIEW_V_GAP, titleStrSize.width, titleStrSize.height)];
    titleLabel.font = FONT_14B;
    titleLabel.text = titleStr;
    titleLabel.textColor = COLOR_MAIN_TEXT;
    [_viewContentScroll addSubview:titleLabel];
    
    
    //添加是否置顶图片
    
    isTopButton = [[RIconTextBtn alloc] initWithFrame:CGRectMake(titleLabel.maxX+TLDETAILVIEW_H_GAP, _yOffSet+TLDETAILVIEW_V_GAP/2, 100.f, 30.f)];
    [isTopButton setImage:[UIImage imageNamed:@"stick"] forState:UIControlStateNormal];
    [isTopButton setTitle:@"" forState:UIControlStateNormal];
    isTopButton.titleLabel.font = FONT_14;
    [isTopButton setTitleColor:COLOR_ORANGE_TEXT forState:UIControlStateNormal];
    [_viewContentScroll addSubview:isTopButton];
    isTopButton.hidden = YES;
    
    if ([GUserDataHelper isLoginUser:detailDto.user.loginId]) {
        [self addIsTopView:isTopButton];
    }
    
    
    _yOffSet = _yOffSet+TLDETAILVIEW_V_GAP+titleStrSize.height;
    //end add title -----
    
}


-(void)addPublishDate{
    TLTripDetailDTO *detailDto = self.viewData;
    NSDictionary *timeDic = [NSDictionary dictionaryWithObjectsAndKeys:FONT_14,NSFontAttributeName ,nil];
    NSString *publish = detailDto.createTime;
    //add publish str
    NSString *publishStr = [NSString stringWithFormat:@"%@",publish];
    CGSize publishStrSize = [publishStr sizeWithAttributes:timeDic];
    //    NSMutableAttributedString *publishColorStr = [[NSMutableAttributedString alloc] initWithString:publishStr];
    
    //    NSRange publishStart = [publishStr rangeOfString:@"："];
    //
    //    [publishColorStr addAttribute:NSForegroundColorAttributeName value:COLOR_MAIN_TEXT range:NSMakeRange(0,publishStart.location+publishStart.length)];
    //    [publishColorStr addAttribute:NSForegroundColorAttributeName value:COLOR_BTN_SOLID_ORANGE_SUFACE range:NSMakeRange(publishStart.location+publishStart.length,publishStr.length-publishStart.location-publishStart.length)];
    //
    UILabel *publishLabel = [[UILabel alloc] initWithFrame:CGRectMake(TLDETAILVIEW_H_GAP, _yOffSet+TLDETAILVIEW_V_GAP, publishStrSize.width, publishStrSize.height)];
    publishLabel.font = FONT_14;
    publishLabel.text = publishStr;
    publishLabel.textColor = COLOR_MAIN_TEXT;
    [_viewContentScroll addSubview:publishLabel];
    
    _yOffSet = _yOffSet+TLDETAILVIEW_V_GAP+publishStrSize.height;
    //end add publish str
    
}

-(void)addCity{
    TLTripDetailDTO *detailDto = self.viewData;
    NSDictionary *timeDic = [NSDictionary dictionaryWithObjectsAndKeys:FONT_14,NSFontAttributeName ,nil];
    NSString *city = detailDto.cityName;
    if (city.length<=0) {
        return;
    }
    //*****add type str ******
    NSString *typeStr = [NSString stringWithFormat:@"景点：%@",city];
    CGSize typeStrSize = [typeStr sizeWithAttributes:timeDic];
    NSMutableAttributedString *typeColorStr = [[NSMutableAttributedString alloc] initWithString:typeStr];
    
    NSRange typeStart = [typeStr rangeOfString:@"："];
    
    [typeColorStr addAttribute:NSForegroundColorAttributeName value:COLOR_MAIN_TEXT range:NSMakeRange(0,typeStart.location+typeStart.length)];
    [typeColorStr addAttribute:NSForegroundColorAttributeName value:COLOR_BTN_SOLID_ORANGE_SUFACE range:NSMakeRange(typeStart.location+typeStart.length,typeStr.length-typeStart.location-typeStart.length)];
    
    UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(TLDETAILVIEW_H_GAP, _yOffSet+TLDETAILVIEW_V_GAP, typeStrSize.width, typeStrSize.height)];
    typeLabel.font = FONT_14;
    typeLabel.attributedText = typeColorStr;
    [_viewContentScroll addSubview:typeLabel];
    
    _yOffSet = _yOffSet+TLDETAILVIEW_V_GAP+typeStrSize.height;
    //*****end add type str ******
    
    
}
//添加名称 发布时间 分类 评论 用户图片等
-(void)addInfoView{
    TLTripDetailDTO *detailDto = self.viewData;
    NSDictionary *timeDic = [NSDictionary dictionaryWithObjectsAndKeys:FONT_14,NSFontAttributeName ,nil];
    
    //"praiseCount":2221,                 --点赞次数
//    "viewCount":1234,                  --浏览次数
//    "commentCount":1232,          --评论次数
    
    
    NSString *favorableCountStr = detailDto.viewCount;
    CGSize favorableCountSize = [favorableCountStr sizeWithAttributes:timeDic];
    
    NSString *commentCountStr = detailDto.commentCount;
    CGSize commentCountSize = [commentCountStr sizeWithAttributes:timeDic];
    
    NSString *viewCountStr = detailDto.collectCount;
    CGSize viewCountSize = [viewCountStr sizeWithAttributes:timeDic];
    
    NSString *curUserCount = nil;//detailDto.commentCount;//@TODO
    NSString *curUserCountStr = [NSString stringWithFormat:@"已报名 %@",curUserCount];
    CGSize curUserCountStrSize = [curUserCountStr sizeWithAttributes:timeDic];
    
    
    CGFloat xOffSet = 0;
    CGFloat btnHeight = 0.f;
    
    if (favorableCountStr.length>0) {
        RIconTextBtn *favorableImageTextBtn = [[RIconTextBtn alloc] initWithFrame:CGRectMake(xOffSet+TLDETAILVIEW_H_GAP, _yOffSet+TLDETAILVIEW_V_GAP, 20.0+commentCountSize.width+10.f, 20.f)];
        [favorableImageTextBtn setImage:[UIImage imageNamed:@"btn_popularity"] forState:UIControlStateNormal];
        [favorableImageTextBtn setTitle:favorableCountStr forState:UIControlStateNormal];
        favorableImageTextBtn.titleLabel.font = FONT_14;
        [favorableImageTextBtn setTitleColor:COLOR_MAIN_TEXT forState:UIControlStateNormal];
        //favorableImageTextBtn.layer.borderColor = [UIColor orangeColor].CGColor;
        //favorableImageTextBtn.layer.borderWidth = 0.5f;
        [_viewContentScroll addSubview:favorableImageTextBtn];
        
        
        
        xOffSet = xOffSet + CGRectGetWidth(favorableImageTextBtn.frame)+TLDETAILVIEW_H_GAP;
        btnHeight = CGRectGetHeight(favorableImageTextBtn.frame);
    }if (commentCountStr.length>0) {
        
        
        RIconTextBtn *commentImageTextBtn = [[RIconTextBtn alloc] initWithFrame:CGRectMake(xOffSet+ TLDETAILVIEW_H_GAP, _yOffSet+TLDETAILVIEW_V_GAP, 20.0+favorableCountSize.width+10.f, 20.f)];
        [commentImageTextBtn setImage:[UIImage imageNamed:@"btn_comment"] forState:UIControlStateNormal];
        [commentImageTextBtn setTitle:commentCountStr forState:UIControlStateNormal];
        commentImageTextBtn.titleLabel.font = FONT_14;
        [commentImageTextBtn setTitleColor:COLOR_MAIN_TEXT forState:UIControlStateNormal];
        //favorableImageTextBtn.layer.borderColor = [UIColor orangeColor].CGColor;
        //favorableImageTextBtn.layer.borderWidth = 0.5f;
        //[commentImageTextBtn addTarget:self action:@selector(commentImageBtnHandler:) forControlEvents:UIControlEventTouchUpInside];
        [_viewContentScroll addSubview:commentImageTextBtn];
        
        xOffSet = xOffSet + CGRectGetWidth(commentImageTextBtn.frame)+TLDETAILVIEW_H_GAP;
        btnHeight = CGRectGetHeight(commentImageTextBtn.frame);
    }if (viewCountStr.length>0) {
        
        
        RIconTextBtn *viewCountImageTextBtn = [[RIconTextBtn alloc] initWithFrame:CGRectMake(xOffSet+TLDETAILVIEW_H_GAP, _yOffSet+TLDETAILVIEW_V_GAP, 20.0+viewCountSize.width+10.f, 20.f)];
        [viewCountImageTextBtn setImage:[UIImage imageNamed:@"btn_download"] forState:UIControlStateNormal];
        [viewCountImageTextBtn setTitle:viewCountStr forState:UIControlStateNormal];
        viewCountImageTextBtn.titleLabel.font = FONT_14;
        [viewCountImageTextBtn setTitleColor:COLOR_MAIN_TEXT forState:UIControlStateNormal];
        //favorableImageTextBtn.layer.borderColor = [UIColor orangeColor].CGColor;
        //favorableImageTextBtn.layer.borderWidth = 0.5f;
        [_viewContentScroll addSubview:viewCountImageTextBtn];
        
        
        xOffSet = xOffSet + CGRectGetWidth(viewCountImageTextBtn.frame)+TLDETAILVIEW_H_GAP;
        btnHeight = CGRectGetHeight(viewCountImageTextBtn.frame);
    }if(curUserCount.length>0){
        UILabel *curUserCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(xOffSet+TLDETAILVIEW_H_GAP*2, _yOffSet+TLDETAILVIEW_V_GAP, curUserCountStrSize.width, curUserCountStrSize.height)];
        curUserCountLabel.font = FONT_14;
        curUserCountLabel.textColor = COLOR_MAIN_TEXT;
        curUserCountLabel.text = curUserCountStr;
        [_viewContentScroll addSubview:curUserCountLabel];

        xOffSet = xOffSet + CGRectGetWidth(curUserCountLabel.frame)+TLDETAILVIEW_H_GAP*2;
        btnHeight = CGRectGetHeight(curUserCountLabel.frame);
    }else{
        _yOffSet = _yOffSet + TLDETAILVIEW_V_GAP;
    }
    
    if (btnHeight!=0) {
        _yOffSet = _yOffSet + TLDETAILVIEW_V_GAP*2 + btnHeight;
    }
    
    
    
    
    
    
    
}

-(void)addTLAdView{
    TLTuleAdView *tlAdView = [[TLTuleAdView alloc] initWithFrame:CGRectMake(0.f, _yOffSet, CGRectGetWidth(_viewContentScroll.frame), 160.f)];
    [_viewContentScroll addSubview:tlAdView];
    _yOffSet = _yOffSet + CGRectGetHeight(tlAdView.frame);
    
}
//添加文字内容
-(void)addTextContent{
    TLTripDetailDTO *detailDto = self.viewData;
    NSDictionary *timeDic = [NSDictionary dictionaryWithObjectsAndKeys:FONT_14,NSFontAttributeName ,nil];
    NSString *contentStr = detailDto.content;
    CGRect newContentStrFrame = [contentStr boundingRectWithSize:CGSizeMake(CGRectGetWidth(_viewContentScroll.frame)-TLDETAILVIEW_H_GAP*2, 1000) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin) attributes:timeDic context:nil];
    
    
    UIView *contentBGView = [[UIView alloc] initWithFrame:CGRectMake(0.f, _yOffSet, CGRectGetWidth(_viewContentScroll.frame), CGRectGetHeight(newContentStrFrame)+TLDETAILVIEW_V_GAP*2)];
    contentBGView.backgroundColor = UIColorFromRGBA(0xCCCCCC, 1.f);
    [_viewContentScroll addSubview:contentBGView];
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(TLDETAILVIEW_H_GAP, TLDETAILVIEW_V_GAP , CGRectGetWidth(newContentStrFrame), CGRectGetHeight(newContentStrFrame))];
    contentLabel.text = contentStr;
    contentLabel.textColor = COLOR_MAIN_TEXT;
    contentLabel.font = FONT_14;
    [contentLabel setNumberOfLines:0];
    
    contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [contentBGView addSubview:contentLabel];
    //
    //    UITextView *cotentTextView = [[UITextView alloc] initWithFrame:CGRectMake(TLDETAILVIEW_H_GAP, 0.f , CGRectGetWidth(newContentStrFrame), CGRectGetHeight(newContentStrFrame)+TLDETAILVIEW_V_GAP*3)];
    //
    //    cotentTextView.backgroundColor = [UIColor clearColor];
    //    cotentTextView.scrollEnabled = NO;
    //    cotentTextView.editable = NO;
    //    cotentTextView.text = contentStr;
    //    cotentTextView.textColor = COLOR_MAIN_TEXT;
    //    cotentTextView.font = FONT_14;
    //    [contentBGView addSubview:cotentTextView];
    //
    //    cotentTextView.scrollIndicatorInsets = UIEdgeInsetsMake(-1, -1, -1, -1);
    
    //    CGSize cc = cotentTextView.contentSize;
    //    cotentTextView.frame = CGRectMake(TLDETAILVIEW_H_GAP, 0.f , CGRectGetWidth(newContentStrFrame), cc.height+TLDETAILVIEW_V_GAP*4);
    //    contentBGView.frame = CGRectMake(0.f, _yOffSet, CGRectGetWidth(_viewContentScroll.frame), cc.height+TLDETAILVIEW_V_GAP*4);
    
    
    _yOffSet = _yOffSet + CGRectGetHeight(contentBGView.frame);
}
//添加其他图片
-(void)addOtherImages{
    
}

-(void)commentImageBtnHandler:(id)btn{
    if (self.CommentItemBlock) {
        self.CommentItemBlock();
    }
}





@end
