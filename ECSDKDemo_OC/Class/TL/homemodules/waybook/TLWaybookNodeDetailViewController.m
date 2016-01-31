//
//  TLWaybookNodeDetailViewController.m
//  TL
//
//  Created by Rainbow on 2/15/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "TLWaybookNodeDetailViewController.h"
#import "TLDetailView.h"
#import "TLPhotoBrowserViewController.h"
#import "TLTripDataDTO.h"
#import "TLModuleDataHelper.h"
#import "TLTripDetailDTO.h"
#import "TLWayBookNodeDTO.h"
#import "TLWayBookDetailDTO.h"

@interface TLWaybookNodeDetailViewController (){
    TLWayBookNodeDTO *nodeData;
}

@end

@implementation TLWaybookNodeDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    nodeData = [self.itemData valueForKey:@"dto"];
    TLWayBookDetailDTO *wayBookDetail = [self.itemData valueForKey:@"detailDto"];
    TLTripDetailDTO *detailDto = [[TLTripDetailDTO alloc] init];
    detailDto.travelId = nodeData.travelId;
    detailDto.cityId = nodeData.cityId;
    detailDto.cityName = nodeData.cityName;
    detailDto.createTime = nodeData.createTime;
    detailDto.viewCount = @"";
    detailDto.commentCount = @"";
    detailDto.collectCount = @"";
    detailDto.content = nodeData.content;
    detailDto.images = nodeData.images;
    detailDto.user = wayBookDetail.user;
    detailDto.title = wayBookDetail.title;
    
    TLDetailView *detailView = [[TLDetailView alloc] initWithFrame:CGRectMake(0.f, NAVIGATIONBAR_HEIGHT+STATUSBAR_HEIGHT, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-NAVIGATIONBAR_HEIGHT-STATUSBAR_HEIGHT) viewData:detailDto type:self.type];
    
    detailView.MoreImageBlock = ^(){
        [self initTLPhotoBrowser];
        
    };
    detailView.DeleteBlock = ^(){
        [self deleteAction];
        
    };
    detailView.CommentItemBlock = ^(){
        [self addComment];
    };
    [self.view addSubview:detailView];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navBarHidden = NO;
    self.navBackItemHidden = NO;
}


-(void)deleteAction{
    TLAddTripRequestDTO *tripRequestDTO = [[TLAddTripRequestDTO alloc] init];
    
    tripRequestDTO.operateType = @"3";
    tripRequestDTO.type = self.type;
    tripRequestDTO.objId = nodeData.lsNodeId.length>0?nodeData.lsNodeId:@"";
    
    WEAK_SELF(self);
    
    [GHUDAlertUtils toggleLoadingInView:self.view];
    [GTLModuleDataHelper addTrip:tripRequestDTO requestArray:self.requestArray block:^(id obj, BOOL ret) {
        [GHUDAlertUtils hideLoadingInView:self.view];
        ResponseDTO *response = obj;
        if (ret) {
            [GHUDAlertUtils toggleMessage:@"删除成功"];
            [weakSelf gobackAction];
        }else{
            [GHUDAlertUtils toggleMessage:response.resultDesc];
            
        }
    }];
    
}

-(void)gobackAction{
    [self.navigationController popViewControllerAnimated:YES];
}



-(void)addComment{
    [self pushViewControllerWithName:@"TLCommentViewController" block:^(id obj) {
        
    }];
}

-(void)initTLPhotoBrowser{
    
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    NSArray *imageURLs = nodeData.images;
    [imageURLs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        TLImageDTO *imageDto = obj;
        NSString *imageUrl = [NSString stringWithFormat:@"%@%@",TL_SERVER_BASE_URL,imageDto.imageUrl];
        [photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:imageUrl]]];
    }];
    TLPhotoBrowserViewController *browser = [[TLPhotoBrowserViewController alloc] initWithTLPhotos:photos];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:nc animated:YES completion:nil];
    
    
}
@end
