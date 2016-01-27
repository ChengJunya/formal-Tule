//
//  TLModuleDataHelper.m
//  TL
//
//  Created by Rainbow on 3/17/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "TLModuleDataHelper.h"
#import "TLTripListRequestDTO.h"
#import "TLAddTripRequestDTO.h"
#import "TLAddBookNodeRequestDTO.h"
#import "TLTripDetailRequestDTO.h"
#import "TLWayBookDetailRequestDTO.h"
#import "TLCommentListRequestDTO.h"
#import "TLCommentRequestDTO.h"

#import "TLIsTopRequestDTO.h"
#import "TLCommonCodeRequestDTO.h"
#import "TLActivitySaveRequestDTO.h"
#import "TLActivityListRequestDTO.h"
#import "TLActivityDetailRequestDTO.h"
#import "TLActivityParticipateRequestDTO.h"
#import "TLCarListRequestDTO.h"


#import "TLTripListResponseDTO.h"
#import "TLAddTripResponseDTO.h"
#import "TLAddBookNodeResponseDTO.h"
#import "TLTripDetailResponseDTO.h"
#import "TLWaybookDetailResponseDTO.h"
#import "TLCommentListResponseDTO.h"
#import "TLCommontResponseDTO.h"

#import "TLIsTopResponseDTO.h"
#import "TLCommonCodeResponseDTO.h"
#import "TLActivitySaveResponseDTO.h"
#import "TLActivityListResponseDTO.h"
#import "TLActivityDetailResponseDTO.h"
#import "TLActivityParticipateResponseDTO.h"
#import "TLCartListResponseDTO.h"
#import "TLCommentRequestDTO.h"
#import "TLSaveCollectResponseDTO.h"

#import "TLListCartResponseDTO.h"
#import "TLCarDetailResponseDTO.h"
#import "TLListCarEvelutionResponseDTO.h"
#import "TLCarEValDetailResponseDTo.h"
#import "TLListCarRectResponseDTO.h"
#import "TLSaveCarResponseDTO.h"
#import "TLViewCarRectResponseDTO.h"


#import "TLSaveCarServiceResponse.h"
#import "TLListCarServiceResponse.h"
#import "TLCarServiceDetailResponse.h"
#import "TLCarServiceMackScoreResponse.h"



#import "TLListMerchantResponseDTO.h"
#import "TLListMerchantDetailResponseDTO.h"
#import "TLSaveSecondGoodsResponse.h"
#import "TLListSecondGoodsResponse.h"
#import "TLSecondGoodsDetailResponse.h"


#import "TLEmergencyResponseDTO.h"
#import "TLUserViewResponseDTO.h"

#import "CoreData+MagicalRecord.h"
#import "TLTripDataEntity.h"
#import "TLTripTravelEntity.h"
#import "TLTripDetailEntity.h"
#import "TLTripUserEntity.h"
#import "TLImageEntity.h"
#import "TLActivityEntity.h"
#import "TLActivityDetailEntity.h"
#import "TLSecondGoodsEntity.h"
#import "TLSecondGoodsDetailEntity.h"

#import "TLStoreEntity.h"
#import "TLStoreDetailEntity.h"
#import "TLListCarEntity.h"
#import "TLCarDetailEntity.h"
#import "TLCarEvalDetailEntity.h"
#import "TLCarEvalutionEntity.h"
#import "TLCarRectEntity.h"
#import "TLCarRectDetailEntity.h"
#import "TLCarServiceEntity.h"
#import "TLCarServiceDetailEntity.h"


#import "TLOpenVipResponseDTO.h"
#import "TLBuyTLBResponseDTO.h"
#import "TLMyFriendsListResponseDTO.h"
#import "TLAddFriendApplyResponseDTO.h"
#import "TLAddGrowResponseDTO.h"
#import <AlipaySDK/AlipaySDK.h>


#import "TLListOrgResponseDTO.h"
#import "TLViewOrgResponseDTO.h"
#import "TLListGroupResponseDTO.h"

#import "TLResponseDTO.h"
#import "TLSaveGroupResponseDTO.h"
#import "TLViewGroupResponseDTO.h"
#import "TLNewsListResponseDTO.h"

#import "TLListOrgMessageResponseDTO.h"
#import "TLSendOrgMessageResponseDTO.h"


#import "TLReportBlackResponseDTO.h"
#import "TLSaveMarchantResponseDTO.h"

#import "TLMerchantErrorResponseDTO.h"

#import "TLSysMessageListResponseDTO.h"

#import "TLUploadChatFileRequest.h"

#import "TLHiddenSetting.h"

#import "TLRemoveFriendRequest.h"
#import "TLComfirmAddFriendResponseDTO.h"

#import "TLInviteGroupUser.h"
#import "TLTlbChanrgeResponseDTO.h"


@interface TLModuleDataHelper()
@property (nonatomic,strong) NSMutableDictionary *userViewResultData;
@property (nonatomic,strong) NSMutableDictionary *orderDictionary;//
@end

@implementation TLModuleDataHelper
ZX_IMPLEMENT_SINGLETON(TLModuleDataHelper)
- (id)init
{
    if (self = [super init]) {
        
    }
    
    return self;
}



/*
 *已发表攻略,路书，游记列表查询 分页获取
 @param orderByTime 是否按照时间顺序
  @param orderByViewCount 是否热度
  @param cityId 地市id
  @param type   类型//1-攻略 2-路数 3-游记
 */
- (void)getTripList:(TLTripListRequestDTO*)tripRequestDto requestArr:(__weak NSMutableArray*)requestArr block:(DataHelper_Block_Page)block;{
    
    NSLog(@"TripList---------------------------------:%@",tripRequestDto.dataType);
    if (tripRequestDto.dataType.integerValue == 5) {
        if (tripRequestDto.currentPage.integerValue>1) {
            block([NSArray array], YES, 1);
            return;
        }
        
        
        NSString *orderBy;
        if (tripRequestDto.orderBy.integerValue==1) {
            orderBy = @"createTime";
        }else if (tripRequestDto.orderBy.integerValue==2) {
            orderBy = @"viewCount";
        }else{
            orderBy = @"createTime";
        }
        
        
        
        NSPredicate *ca;

        if (tripRequestDto.cityId.length>0) {
            ca = [NSPredicate predicateWithFormat:@"type == %@ AND cityId=%@",tripRequestDto.type,tripRequestDto.cityId];
        }else{
            ca = [NSPredicate predicateWithFormat:@"type == %@",tripRequestDto.type];
        }
        
        
        
        
        
        NSArray *tlTripDataArray = [TLTripDataEntity MR_findAllSortedBy:orderBy ascending:YES withPredicate:ca];
        
        NSMutableArray *tripArray = [NSMutableArray array];
        
        [tlTripDataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            TLTripDataEntity *itemDTO = obj;
            TLTripDataDTO *tripDataEndity = [[TLTripDataDTO alloc] init];
            tripDataEndity.travelId = itemDTO.travelId;
            tripDataEndity.cityId = itemDTO.cityId;
            tripDataEndity.cityName = itemDTO.cityName;
            tripDataEndity.title = itemDTO.title;
            tripDataEndity.createTime = itemDTO.createTime;
            tripDataEndity.viewCount = itemDTO.viewCount;
            tripDataEndity.userIcon = itemDTO.userIcon;
            tripDataEndity.userPic = itemDTO.userPic;
            
            NSMutableArray *travelArray = [NSMutableArray array];
            
            [itemDTO.travel enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
                TLTripTravelEntity *nodeDto = obj;
                TLTripTravelDTO *tlTripTravelEntity = [[TLTripTravelDTO alloc] init];
                tlTripTravelEntity.lsNodeId = nodeDto.lsNodeId;
                tlTripTravelEntity.travelId = nodeDto.travelId;
                tlTripTravelEntity.cityId = nodeDto.cityId;
                tlTripTravelEntity.cityName = nodeDto.cityName;
                tlTripTravelEntity.content = nodeDto.content;
                tlTripTravelEntity.createTime = nodeDto.createTime;
                tlTripTravelEntity.createUser = nodeDto.createUser;
                tlTripTravelEntity.modifyTime = nodeDto.modifyTime;
                [travelArray addObject:tlTripTravelEntity];
            }];
            
            tripDataEndity.travel = (NSArray<TLTripTravelDTO>*)travelArray;
            
            
            
            
            
            [tripArray addObject:tripDataEndity];
            
            
            
            
            
        }];
        
        block(tripArray, YES, [tripRequestDto.currentPage intValue]);
        
        

        return;
    }
    
    //返回请求标记tag
    NSNumber *requestTag = [GDataManager asyncRequestByType:NetAdapter_TripList andObject:tripRequestDto success:^(TLTripListResponseDTO* responseDTO) {
        
        
        if (block) {
            block(responseDTO.result.data, YES, [tripRequestDto.currentPage intValue]);
        }
    } failure:^(id responseDTO) {
        if (block) {
            block(responseDTO, NO, 0);
        }
    }];
    [requestArr addObject:requestTag];
    
    
    
}


/*
 * 刷新获取
 */
- (void)getMyTripList:(TLTripListRequestDTO*)tripRequestDto requestArr:(__weak NSMutableArray*)requestArr block:(DataHelper_Block_Page)block{


    
    
    //返回请求标记tag
    NSNumber *requestTag = [GDataManager asyncRequestByType:NetAdapter_MyTripList andObject:tripRequestDto success:^(TLTripListResponseDTO* responseDTO) {
        
        
        if (block) {
            block(responseDTO.result.data, YES, tripRequestDto.currentPage.intValue);
        }
    } failure:^(id responseDTO) {
        if (block) {
            block(responseDTO, NO, 0);
        }
    }];
    [requestArr addObject:requestTag];
}

/*
 *攻略，路书（主题），游记录入
 */
- (void)addTrip:(TLAddTripRequestDTO*)requestDTO  requestArray:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block{
    
    //返回请求标记tag
    NSNumber *requestTag = [GDataManager asyncRequestByType:NetAdapter_AddTrip andObject:requestDTO success:^(TLAddTripResponseDTO* responseDTO) {
        block(responseDTO, YES);
    } failure:^(id responseDTO) {
        block(responseDTO, NO);
    }];
    [requestArr addObject:requestTag];
}
/*
 *路书节点录入
 */
- (void)addWayBookNode:(TLAddBookNodeRequestDTO*)request requestArray:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block{
    //请求数据对象
    
    
    //返回请求标记tag
    NSNumber *requestTag = [GDataManager asyncRequestByType:NetAdapter_AddBookNode andObject:request success:^(TLAddBookNodeResponseDTO* responseDTO) {
        
        
        if (block) {
            block(responseDTO.result, YES);
        }
    } failure:^(id responseDTO) {
        if (block) {
            block(responseDTO, NO);
        }
    }];
    [requestArr addObject:requestTag];
}

/*
 *游记，攻略详情
 */
- (void)getTripDetail:(TLTripDetailRequestDTO*)requestDTO requestArray:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block{
    //请求数据对象
    
    
    if (requestDTO.dataType.integerValue==5) {
        
            TLTripDetailEntity *detailDto = [TLTripDetailEntity MR_findFirstByAttribute:@"travelId" withValue:requestDTO.travelId];
            
            TLTripDetailDTO *tripDetailEntity = [[TLTripDetailDTO alloc] init];
            tripDetailEntity.travelId = detailDto.travelId;
            tripDetailEntity.cityId = detailDto.cityId;
            tripDetailEntity.cityName = detailDto.cityName;
            tripDetailEntity.title = detailDto.title;
            tripDetailEntity.createTime = detailDto.createTime;
            tripDetailEntity.viewCount = detailDto.viewCount;
            tripDetailEntity.commentCount = detailDto.commentCount;
            tripDetailEntity.collectCount = detailDto.collectCount;
            tripDetailEntity.content = detailDto.content;
            
            
            TLTripUserDTO *userEntity = [[TLTripUserDTO alloc] init];
            userEntity.userIcon  = detailDto.user.userIcon;
            userEntity.userIndex = detailDto.user.userIndex;
            userEntity.userName = detailDto.user.userName;
            userEntity.visitTime = detailDto.user.visitTime;
            userEntity.loginId = detailDto.user.loginId;
            tripDetailEntity.user = userEntity;
            
            NSMutableArray *imageArray = [NSMutableArray array];
            [detailDto.images enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
                TLImageEntity *imageDto = obj;
                TLImageDTO *image = [[TLImageDTO alloc] init];
                image.imageName = imageDto.imageName;
                image.imageUrl = imageDto.imageUrl;
                [imageArray addObject:image];
            }];
            tripDetailEntity.images = (NSArray<TLImageDTO>*)imageArray;
            block(tripDetailEntity, YES);
        return;
    }
    
   
    
    //返回请求标记tag
    NSNumber *requestTag = [GDataManager asyncRequestByType:NetAdapter_TripDetail andObject:requestDTO success:^(TLTripDetailResponseDTO* responseDTO) {
        if (block) {
            block(responseDTO.result, YES);
        }
    } failure:^(id responseDTO) {
        if (block) {
            block(responseDTO, NO);
        }
    }];
    [requestArr addObject:requestTag];

}
/*
 *路书详情
 */
- (void)getWayBookDetail:(TLWayBookDetailRequestDTO*)requestDTO requestArray:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block{
    //请求数据对象
    
    if (requestDTO.dataType.integerValue==5) {

           TLTripDetailEntity *detailDto = [TLTripDetailEntity MR_findFirstByAttribute:@"travelId" withValue:requestDTO.travelId];
        
            TLWayBookDetailDTO *tripDetailEntity = [[TLWayBookDetailDTO alloc] init];
            tripDetailEntity.travelId = detailDto.travelId;
            tripDetailEntity.cityId = detailDto.cityId;
            tripDetailEntity.cityName = detailDto.cityName;
            tripDetailEntity.title = detailDto.title;
            tripDetailEntity.createTime = detailDto.createTime;
            tripDetailEntity.viewCount = detailDto.viewCount;
            tripDetailEntity.commentCount = detailDto.commentCount;
            tripDetailEntity.collectCount = detailDto.collectCount;
            tripDetailEntity.content = detailDto.content;
            
            
            TLTripUserDTO *userEntity = [[TLTripUserDTO alloc] init];
            userEntity.userIcon  = detailDto.user.userIcon;
            userEntity.userIndex = detailDto.user.userIndex;
            userEntity.userName = detailDto.user.userName;
            userEntity.visitTime = detailDto.user.visitTime;
            userEntity.loginId = detailDto.user.loginId;
            tripDetailEntity.user = userEntity;
            
            NSMutableArray *imageArray = [NSMutableArray array];
            [detailDto.images enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
                TLImageEntity *imageDto = obj;
                TLImageDTO *image = [[TLImageDTO alloc] init];
                image.imageName = imageDto.imageName;
                image.imageUrl = imageDto.imageUrl;
                [imageArray addObject:image];
            }];
            tripDetailEntity.images = (NSArray<TLImageDTO>*)imageArray;

            
            NSMutableArray *tNodeArray = [NSMutableArray array];
            [detailDto.travel enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
                TLTripTravelEntity *nodeDto = obj;
                TLWayBookNodeDTO *tlTripTravelEntity = [[TLWayBookNodeDTO alloc] init];
                tlTripTravelEntity.lsNodeId = nodeDto.lsNodeId;
                tlTripTravelEntity.travelId = nodeDto.travelId;
                tlTripTravelEntity.cityId = nodeDto.cityId;
                tlTripTravelEntity.cityName = nodeDto.cityName;
                tlTripTravelEntity.content = nodeDto.content;
                tlTripTravelEntity.createTime = nodeDto.createTime;
                tlTripTravelEntity.createUser = nodeDto.createUser;
                tlTripTravelEntity.modifyTime = nodeDto.modifyTime;
                NSMutableArray *tImageArray = [NSMutableArray array];
                [nodeDto.images enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
                    TLImageEntity *imageDto = obj;
                    TLImageDTO *image = [[TLImageDTO alloc] init];
                    image.imageName = imageDto.imageName;
                    image.imageUrl = imageDto.imageUrl;
                    [tImageArray addObject:image];
                }];
                tlTripTravelEntity.images = (NSArray<TLImageDTO>*)tImageArray;
                [tNodeArray addObject:tlTripTravelEntity];
                
                
                
            }];
            tripDetailEntity.travel = (NSArray<TLWayBookNodeDTO>*)tNodeArray;
            block(tripDetailEntity, YES);
        return;
    }
    
    //返回请求标记tag
    NSNumber *requestTag = [GDataManager asyncRequestByType:NetAdapter_Waybook andObject:requestDTO success:^(TLWaybookDetailResponseDTO* responseDTO) {
        
        
        if (block) {
            block(responseDTO.result, YES);
        }
    } failure:^(id responseDTO) {
        if (block) {
            block(responseDTO, NO);
        }
    }];
    [requestArr addObject:requestTag];
}


/*
 *攻略，路书，游记评论查询 分页
 */
- (void)getCommentList:(TLCommentListRequestDTO*)request requestArr:(__weak NSMutableArray*)requestArr block:(DataHelper_Block_Page)block{
    
    
    //返回请求标记tag
    NSNumber *requestTag = [GDataManager asyncRequestByType:NetAdapter_CommentList andObject:request success:^(TLCommentListResponseDTO* responseDTO) {
        
        
        if (block) {
            block(responseDTO.result.data, YES, request.currentPage.intValue);
        }
    } failure:^(id responseDTO) {
        if (block) {
            block(responseDTO, NO, 0);
        }
    }];
    [requestArr addObject:requestTag];
}
/*
 *攻略，路书，游记评论
 */
- (void)addComment:(TLCommentRequestDTO*)request requestArr:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block{
    //请求数据对象
    
    
    //返回请求标记tag
    NSNumber *requestTag = [GDataManager asyncRequestByType:NetAdapter_Commont andObject:request success:^(TLCommontResponseDTO* responseDTO) {
        
        
        if (block) {
            block(responseDTO.result, YES);
        }
    } failure:^(id responseDTO) {
        if (block) {
            block(responseDTO, NO);
        }
    }];
    [requestArr addObject:requestTag];
}



/*
 *获取当前游记，攻略，路书，活动是否置顶
 */
- (void)isTop:(TLIsTopRequestDTO*)request requestArray:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block{
    //请求数据对象
    
    //返回请求标记tag
    NSNumber *requestTag = [GDataManager asyncRequestByType:NetAdapter_IsTop andObject:request success:^(TLIsTopResponseDTO* responseDTO) {
        
        if (block) {
            block(responseDTO.result, YES);
        }
    } failure:^(id responseDTO) {
        if (block) {
            block(responseDTO, NO);
        }
    }];
    [requestArr addObject:requestTag];
}

/*
 *获取当前游记，攻略，路书，活动 置顶
 */
- (void)doTop:(TLIsTopRequestDTO*)request requestArray:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block{
    //请求数据对象
    
    //返回请求标记tag
    NSNumber *requestTag = [GDataManager asyncRequestByType:NetAdapter_DoTop andObject:request success:^(TLIsTopResponseDTO* responseDTO) {
        
        if (block) {
            block(responseDTO.result, YES);
        }
    } failure:^(id responseDTO) {
        if (block) {
            block(responseDTO, NO);
        }
    }];
    [requestArr addObject:requestTag];
}
/*
 *码表获取
 */
- (void)commonCode:(TLCommonCodeRequestDTO*)request  requestArray:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block{
    //请求数据对象
    NSLog(@"获取码表数据：%@",request);
    
    //返回请求标记tag
    NSNumber *requestTag = [GDataManager asyncRequestByType:NetAdapter_CommonCode andObject:request success:^(TLCommonCodeResponseDTO* responseDTO) {
        
        
        if (block) {
            block(responseDTO.result.data, YES);
        }
    } failure:^(id responseDTO) {
        if (block) {
            block(responseDTO, NO);
        }
    }];
    [requestArr addObject:requestTag];
}
/*
 *活动录入
 */
- (void)activitySave:(TLActivitySaveRequestDTO*)request requestArray:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block{
    //请求数据对象
    
    
    //返回请求标记tag
    NSNumber *requestTag = [GDataManager asyncRequestByType:NetAdapter_ActivitySave andObject:request success:^(TLActivitySaveResponseDTO* responseDTO) {
        
        
        if (block) {
            block(responseDTO.result, YES);
        }
    } failure:^(id responseDTO) {
        if (block) {
            block(responseDTO, NO);
        }
    }];
    [requestArr addObject:requestTag];
}
/*
 *活动列表
 */
- (void)getActivityList:(TLActivityListRequestDTO*)request requestArray:(__weak NSMutableArray*)requestArr block:(DataHelper_Block_Page)block{
    //请求数据对象
    NSLog(@"ActivityList---------------------------------:%@",request.dataType);
    
    if (request.dataType.integerValue == 5) {
        if (request.currentPage.integerValue>1) {
            block([NSArray array], YES, 1);
            return;
        }
        //NSArray *tlTripDataArray = [TLActivityEntity MR_findAllSortedBy:@"publishTime" ascending:YES];
        NSString *orderBy;
        if (request.orderBy.integerValue==1) {
            orderBy = @"publishTime";
        }else if (request.orderBy.integerValue==2) {
            orderBy = @"costAverage";
        }else if (request.orderBy.integerValue==3) {
            orderBy = @"viewCount";
        }else{
            orderBy = @"publishTime";
        }

        

        
        NSArray *tlTripDataArray;
        if (request.cityId.length>0) {
            //tlTripDataArray = [TLActivityEntity MR_findByAttribute:@"cityId" withValue:request.cityId andOrderBy:orderBy ascending:YES];
            tlTripDataArray = [TLActivityEntity MR_findAllSortedBy:orderBy ascending:YES];
        }else{
            tlTripDataArray = [TLActivityEntity MR_findAllSortedBy:orderBy ascending:YES];
        }
        
        NSMutableArray *tripArray = [NSMutableArray array];
        
        [tlTripDataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            TLActivityEntity *itemDTO = obj;
            TLActivityDTO *tripDataEndity = [[TLActivityDTO alloc] init];
            tripDataEndity.title = itemDTO.title;
            tripDataEndity.destnation = itemDTO.destnation;
            tripDataEndity.costAverage = itemDTO.costAverage;
            tripDataEndity.personNum = itemDTO.personNum;
            tripDataEndity.desc = itemDTO.desc;
            tripDataEndity.viewCount = itemDTO.viewCount;
            tripDataEndity.commentCount = itemDTO.commentCount;
            tripDataEndity.activityImage = itemDTO.activityImage;
            tripDataEndity.activityId = itemDTO.activityId;
            tripDataEndity.enrollCount = itemDTO.enrollCount;
            tripDataEndity.publishTime = itemDTO.publishTime;
            
            [tripArray addObject:tripDataEndity];
            
            
            
        }];
        
        block(tripArray, YES, [request.currentPage intValue]);
        
        

        return;
    }
    //返回请求标记tag
    NSNumber *requestTag = [GDataManager asyncRequestByType:NetAdapter_ActivityList andObject:request success:^(TLActivityListResponseDTO* responseDTO) {
        
        
        if (block) {
            block(responseDTO.result.data, YES,request.currentPage.intValue);
        }
    } failure:^(id responseDTO) {
        if (block) {
            block(responseDTO, NO,0);
        }
    }];
    [requestArr addObject:requestTag];
    
    
   
}
/*
 *活动详情
 */
- (void)getActivityDetail:(TLActivityDetailRequestDTO*)request requestArray:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block{
    //请求数据对象
    
    if (request.dataType.integerValue==5) {
        
            
            TLActivityDetailEntity *_detailDto = [TLActivityDetailEntity MR_findFirstByAttribute:@"activityId" withValue:request.activityId];
            TLActivityDetailDTO *tripDetailEntity = [[TLActivityDetailDTO alloc] init];
            tripDetailEntity.activityId = _detailDto.activityId;
            tripDetailEntity.title = _detailDto.title;
            tripDetailEntity.destnation = _detailDto.destnation;
            tripDetailEntity.costAverage = _detailDto.costAverage;
            tripDetailEntity.personNum = _detailDto.personNum;
            tripDetailEntity.desc = _detailDto.desc;
            tripDetailEntity.viewCount = _detailDto.viewCount;
            tripDetailEntity.commentCount = _detailDto.commentCount;
            tripDetailEntity.collectCount = _detailDto.collectCount;
            tripDetailEntity.publishTime = _detailDto.publishTime;
            tripDetailEntity.userPhone = _detailDto.userPhone;
            
            
            
            TLTripUserDTO *userEntity = [[TLTripUserDTO alloc] init];
            userEntity.userIcon  = _detailDto.user.userIcon;
            userEntity.userIndex = _detailDto.user.userIndex;
            userEntity.userName = _detailDto.user.userName;
            userEntity.visitTime = _detailDto.user.visitTime;
            userEntity.loginId = _detailDto.user.loginId;
            tripDetailEntity.user = userEntity;
            
            NSMutableArray *imageArray = [NSMutableArray array];
            [_detailDto.images enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
                TLImageEntity *imageDto = obj;
                TLImageDTO *image = [[TLImageDTO alloc] init];
                image.imageName = imageDto.imageName;
                image.imageUrl = imageDto.imageUrl;
                [imageArray addObject:image];
            }];
            tripDetailEntity.images = (NSArray<TLImageDTO>*)imageArray;
            
            NSMutableArray *enrolArray = [NSMutableArray array];
            [_detailDto.enrollUsers enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
                TLTripUserEntity *userDto = obj;
                TLTripUserDTO *userEntity = [[TLTripUserDTO alloc] init];
                userEntity.userIcon  = userDto.userIcon;
                userEntity.userIndex = userDto.userIndex;
                userEntity.userName = userDto.userName;
                userEntity.visitTime = userDto.visitTime;
                userEntity.loginId = userDto.loginId;
                [enrolArray addObject:userEntity];
            }];
            tripDetailEntity.enrollUsers = (NSArray<TLTripUserDTO>*)enrolArray;
            block(tripDetailEntity, YES);
        return;
            
    }
    //返回请求标记tag
    NSNumber *requestTag = [GDataManager asyncRequestByType:NetAdapter_ActivityDetail andObject:request success:^(TLActivityDetailResponseDTO* responseDTO) {
        
        
        if (block) {
            block(responseDTO.result.data, YES);
        }
    } failure:^(id responseDTO) {
        if (block) {
            block(responseDTO, NO);
        }
    }];
    [requestArr addObject:requestTag];
   
}
/*
 *报名活动
 */
- (void)activityParticipate:(TLActivityParticipateRequestDTO*)request  requestArray:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block{
    //请求数据对象
    
    
    //返回请求标记tag
    NSNumber *requestTag = [GDataManager asyncRequestByType:NetAdapter_ActivityParticipate andObject:request success:^(TLActivityParticipateResponseDTO* responseDTO) {
        
        
        if (block) {
            block(responseDTO.result, YES);
        }
    } failure:^(id responseDTO) {
        if (block) {
            block(responseDTO, NO);
        }
    }];
    [requestArr addObject:requestTag];
}




/*
 *攻略，路书，游记 收藏
 */
- (void)addCollect:(TLSaveCollectRequestDTO*)request requestArr:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block{
    
    //返回请求标记tag
    NSNumber *requestTag = [GDataManager asyncRequestByType:NetAdapter_SaveCollect andObject:request success:^(TLSaveCollectResponseDTO* responseDTO) {
        
        
        if (block) {
            block(responseDTO, YES);
        }
    } failure:^(id responseDTO) {
        if (block) {
            block(responseDTO, NO);
        }
    }];
    [requestArr addObject:requestTag];
}



/*
 29新车列表（已完成）
 访问地址:/action/listCar
 */
- (void)getNewCarList:(TLListCarRequestDTO*)request requestArray:(__weak NSMutableArray*)requestArr block:(DataHelper_Block_Page)block{
    NSLog(@"NewCarList---------------------------------:%@",request.dataType);
    
    if (request.dataType.integerValue==5) {
        if (request.currentPage.integerValue>1) {
            block([NSArray array], YES, 0);
            return;
        }
        NSArray *tlTripDataArray = [TLListCarEntity MR_findAllSortedBy:@"createTime" ascending:YES];
        
        NSMutableArray *tripArray = [NSMutableArray array];
        
        [tlTripDataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            TLListCarEntity *itemDTO = obj;
            TLListCarDTO *tripDataEndity = [[TLListCarDTO alloc] init];
            tripDataEndity.carId = itemDTO.carId;
            tripDataEndity.carType = itemDTO.carType;
            tripDataEndity.priceRange = itemDTO.priceRange;
            tripDataEndity.publishTime = itemDTO.publishTime;
            tripDataEndity.editor = itemDTO.editor;
            tripDataEndity.createTime = itemDTO.createTime;
            tripDataEndity.carImageUrl = itemDTO.carImageUrl;
            
            [tripArray addObject:tripDataEndity];
            
            
            
        }];
        
        block(tripArray, YES, [request.currentPage intValue]);
        
        return;
    }
    //返回请求标记tag
    NSNumber *requestTag = [GDataManager asyncRequestByType:NetAdapter_ListCart andObject:request success:^(TLListCartResponseDTO* responseDTO) {

        
        if (block) {
            block(responseDTO.result.data, YES,request.currentPage.intValue);
        }
    } failure:^(id responseDTO) {
        if (block) {
            block(responseDTO, NO,0);
        }
    }];
    [requestArr addObject:requestTag];
}
/*
 *车评列表 listCarEvaluation
 */
- (void)getCarEvalutionList:(TLListCarEvalutionRequestDTO*)request requestArray:(__weak NSMutableArray*)requestArr block:(DataHelper_Block_Page)block{
        NSLog(@"CarEvalutionList---------------------------------:%@",request.dataType);
    if (request.dataType.integerValue==5) {
        if (request.currentPage.integerValue>1) {
            block([NSArray array], YES, 0);
            return;
        }
        NSArray *tlTripDataArray = [TLCarEvalutionEntity MR_findAllSortedBy:@"createTime" ascending:YES];
        
        NSMutableArray *tripArray = [NSMutableArray array];
        
        [tlTripDataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            TLCarEvalutionEntity *itemDTO = obj;
            TLCarEvalutionDTO *tripDataEndity = [[TLCarEvalutionDTO alloc] init];
            tripDataEndity.carEvaId = itemDTO.carEvaId;
            tripDataEndity.carType = itemDTO.carType;
            tripDataEndity.oilCost = itemDTO.oilCost;
            tripDataEndity.evalText = itemDTO.evalText;
            tripDataEndity.editor = itemDTO.editor;
            tripDataEndity.createTime = itemDTO.createTime;
            tripDataEndity.carImageUrl = itemDTO.carImageUrl;
            
            [tripArray addObject:tripDataEndity];
            
            
            
        }];
        
        block(tripArray, YES, [request.currentPage intValue]);
        
        return;
    }
    
    //返回请求标记tag
    NSNumber *requestTag = [GDataManager asyncRequestByType:NetAdapter_ListCarEvalution andObject:request success:^(TLListCarEvelutionResponseDTO* responseDTO) {
        


        if (block) {
            block(responseDTO.result.data, YES,request.currentPage.intValue);
        }
    } failure:^(id responseDTO) {
        if (block) {
            block(responseDTO, NO,0);
        }
    }];
    [requestArr addObject:requestTag];
    
}


/*
 *汽车租赁列表 listCarRent
 */
- (void)getCarRectList:(TLListCarRectRequestDTO*)request requestArray:(__weak NSMutableArray*)requestArr block:(DataHelper_Block_Page)block{
    NSLog(@"CarRectList---------------------------------:%@",request.dataType);
    if (request.dataType.integerValue==5) {
        if (request.currentPage.integerValue>1) {
            block([NSArray array], YES, 0);
            return;
        }
        NSArray *tlTripDataArray = [TLCarRectEntity MR_findAllSortedBy:@"createTime" ascending:YES];
        
        NSMutableArray *tripArray = [NSMutableArray array];
        
        [tlTripDataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            TLCarRectEntity *itemDTO = obj;
            TLCarRectDTO *tripDataEndity = [[TLCarRectDTO alloc] init];
            tripDataEndity.rentId = itemDTO.rentId;
            tripDataEndity.carType = itemDTO.carType;
            tripDataEndity.rentType = itemDTO.rentType;
            tripDataEndity.driveDistance = itemDTO.driveDistance;
            tripDataEndity.editor = itemDTO.editor;
            tripDataEndity.createTime = itemDTO.createTime;
            tripDataEndity.carImageUrl = itemDTO.carImageUrl;
            
            [tripArray addObject:tripDataEndity];
            
            
            
        }];
        
        block(tripArray, YES, [request.currentPage intValue]);
        
        return;
    }
    //返回请求标记tag
    
    NSNumber *requestTag = [GDataManager asyncRequestByType:NetAdapter_ListCarRect andObject:request success:^(TLListCarRectResponseDTO* responseDTO) {

        
        if (block) {
            block(responseDTO.result.data, YES,request.currentPage.intValue);
        }
    } failure:^(id responseDTO) {
        if (block) {
            block(responseDTO, NO,0);
        }
    }];
    [requestArr addObject:requestTag];
    
}

/*
 *新车详情
 */
- (void)getNewCarDetail:(TLCarDetailRequestDTO*)request requestArray:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block{
    
    if (request.dataType.integerValue == 5) {
        TLCarDetailEntity *_detailDto = [TLCarDetailEntity MR_findFirstByAttribute:@"carId" withValue:request.carId];
        TLCarDEtailResultDTO *tripDetailEntity = [[TLCarDEtailResultDTO alloc] init];
        
        
        tripDetailEntity.carId = _detailDto.carId;
        tripDetailEntity.carType = _detailDto.carType;
        //tripDetailEntity.oilCost = _detailDto.oilCost;
        //tripDetailEntity.priceRange = _detailDto.priceRange;
        tripDetailEntity.publishTime = _detailDto.publishTime;
        tripDetailEntity.editor = _detailDto.editor;
        tripDetailEntity.createTime = _detailDto.createTime;
        tripDetailEntity.carDesc = _detailDto.carDesc;
        
        tripDetailEntity.carMaker = _detailDto.carMaker;
        tripDetailEntity.carBrand = _detailDto.carBrand;
        tripDetailEntity.seatCount = _detailDto.seatCount;
        tripDetailEntity.color = _detailDto.color;
        tripDetailEntity.price_low = _detailDto.price_low;
        tripDetailEntity.engine_low = _detailDto.engine_low;
        tripDetailEntity.gearBox_low = _detailDto.gearBox_low;
        tripDetailEntity.oilCost_low = _detailDto.oilCost_low;
        tripDetailEntity.drive_low = _detailDto.drive_low;
        tripDetailEntity.oilType_low = _detailDto.oilType_low;
        tripDetailEntity.price_high = _detailDto.price_high;
        tripDetailEntity.engine_high = _detailDto.engine_high;
        tripDetailEntity.gearBox_high = _detailDto.gearBox_high;
        tripDetailEntity.oilCost_high = _detailDto.oilCost_high;
        tripDetailEntity.drive_high = _detailDto.drive_high;
        tripDetailEntity.oilType_high = _detailDto.oilType_high;
        tripDetailEntity.viewCount = _detailDto.viewCount;
        tripDetailEntity.carEvalDesc = _detailDto.carEvalDesc;
        
        
        
        
        
        
        NSMutableArray *imageArray = [NSMutableArray array];
        [_detailDto.images enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
            TLImageEntity *imageDto = obj;
            TLImageDTO *image = [[TLImageDTO alloc] init];
            image.imageName = imageDto.imageName;
            image.imageUrl = imageDto.imageUrl;
            [imageArray addObject:image];
        }];
        tripDetailEntity.images = (NSArray<TLImageDTO>*)imageArray;
        
        
        block(tripDetailEntity, YES);
        return;
    }
    //返回请求标记tag
    NSNumber *requestTag = [GDataManager asyncRequestByType:NetAdapter_CartDetail andObject:request success:^(TLCarDetailResponseDTO* responseDTO) {

        if (block) {
            block(responseDTO.result, YES);
        }
    } failure:^(id responseDTO) {
        if (block) {
            block(responseDTO, NO);
        }
    }];
    [requestArr addObject:requestTag];
}
/*
 *车评详情
 */
- (void)getCarEvalutionDetail:(TLCarEvalDetailRequestDTO*)request requestArray:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block{
    if (request.dataType.integerValue == 5) {
        TLCarEvalDetailEntity *_detailDto = [TLCarEvalDetailEntity MR_findFirstByAttribute:@"carEvaId" withValue:request.carEvaId];
        TLCarEvalDetailResultDTO *tripDetailEntity = [[TLCarEvalDetailResultDTO alloc] init];

        tripDetailEntity.carEvaId = _detailDto.carEvaId;
        tripDetailEntity.carType = _detailDto.carType;
        tripDetailEntity.oilCost = _detailDto.oilCost;
        tripDetailEntity.publishTime = _detailDto.publishTime;
        tripDetailEntity.editor = _detailDto.editor;
        tripDetailEntity.createTime = _detailDto.createTime;
        tripDetailEntity.carEvalDesc = _detailDto.carEvalDesc;

        
        
        
        
        
        
        NSMutableArray *imageArray = [NSMutableArray array];
        [_detailDto.images enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
            TLImageEntity *imageDto = obj;
            TLImageDTO *image = [[TLImageDTO alloc] init];
            image.imageName = imageDto.imageName;
            image.imageUrl = imageDto.imageUrl;
            [imageArray addObject:image];
        }];
        tripDetailEntity.images = (NSArray<TLImageDTO>*)imageArray;
        
        
        block(tripDetailEntity, YES);
        return;
    }
    //返回请求标记tag
    NSNumber *requestTag = [GDataManager asyncRequestByType:NetAdapter_CarEvalDetail andObject:request success:^(TLCarEValDetailResponseDTo* responseDTO) {
        

        
        if (block) {
            block(responseDTO.result, YES);
        }
    } failure:^(id responseDTO) {
        if (block) {
            block(responseDTO, NO);
        }
    }];
    [requestArr addObject:requestTag];
}
/*
 *车辆租赁详情
 */
- (void)getCarRentDetail:(TLViewCarRentRequestDTO*)request requestArray:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block{
    
    if (request.dataType.integerValue == 5) {
        TLCarRectDetailEntity *_detailDto = [TLCarRectDetailEntity MR_findFirstByAttribute:@"rentId" withValue:request.rentId];
        TLViewCarRectResultDTO *tripDetailEntity = [[TLViewCarRectResultDTO alloc] init];
        tripDetailEntity.rentId = _detailDto.rentId;
        tripDetailEntity.title = _detailDto.title;
        tripDetailEntity.createTime = _detailDto.createTime;
        tripDetailEntity.viewCount = _detailDto.viewCount;
        tripDetailEntity.commentCount = _detailDto.commentCount;
        tripDetailEntity.carType = _detailDto.carType;
        tripDetailEntity.driveDistance = _detailDto.driveDistance;
        tripDetailEntity.rentType = _detailDto.rentType;
        tripDetailEntity.address = _detailDto.address;
        tripDetailEntity.carDesc = _detailDto.carDesc;
        tripDetailEntity.userPhone = _detailDto.userPhone;
        
        
        
        TLTripUserDTO *userEntity = [[TLTripUserDTO alloc] init];
        userEntity.userIcon  = _detailDto.user.userIcon;
        userEntity.userIndex = _detailDto.user.userIndex;
        userEntity.userName = _detailDto.user.userName;
        userEntity.visitTime = _detailDto.user.visitTime;
        userEntity.loginId = _detailDto.user.loginId;
        tripDetailEntity.user = userEntity;
        
        
        NSMutableArray *imageArray = [NSMutableArray array];
        [_detailDto.images enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
            TLImageEntity *imageDto = obj;
            TLImageDTO *image = [[TLImageDTO alloc] init];
            image.imageName = imageDto.imageName;
            image.imageUrl = imageDto.imageUrl;
            [imageArray addObject:image];
        }];
        tripDetailEntity.images = (NSArray<TLImageDTO>*)imageArray;
        
        
        block(tripDetailEntity, YES);
        return;
    }
    
    //返回请求标记tag
    NSNumber *requestTag = [GDataManager asyncRequestByType:NetAdapter_ViewCarRent andObject:request success:^(TLSaveCarResponseDTO* responseDTO) {

        
        if (block) {
            block(responseDTO.result, YES);
        }
    } failure:^(id responseDTO) {
        if (block) {
            block(responseDTO, NO);
        }
    }];
    [requestArr addObject:requestTag];
}

/*
 * 添加车辆租赁
 */
- (void)addCarRect:(TLSaveCarRectRequestDTO*)request requestArr:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block{
    //返回请求标记tag
    NSNumber *requestTag = [GDataManager asyncRequestByType:NetAdapter_SaveCarRent andObject:request success:^(TLViewCarRectResponseDTO* responseDTO) {
        
        if (block) {
            block(responseDTO, YES);
        }
    } failure:^(id responseDTO) {
        if (block) {
            block(responseDTO, NO);
        }
    }];
    [requestArr addObject:requestTag];
}


/*
 *汽车租赁列表 listCarRent
 */
- (void)getCarServiceList:(TLListCarServiceRequest*)request requestArray:(__weak NSMutableArray*)requestArr block:(DataHelper_Block_Page)block{
    NSLog(@"CarServiceList---------------------------------:%@",request.dataType);
    if (request.dataType.integerValue==5) {
        if (request.currentPage.integerValue>1) {
            block([NSArray array], YES, 0);
            return;
        }
        NSArray *tlTripDataArray = [TLCarServiceEntity MR_findAllSortedBy:@"createTime" ascending:YES];
        
        NSMutableArray *tripArray = [NSMutableArray array];
        
        [tlTripDataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            TLCarServiceEntity *itemDTO = obj;
            TLCarServiceDTO *tripDataEndity = [[TLCarServiceDTO alloc] init];
            tripDataEndity.serviceId = itemDTO.serviceId;
            tripDataEndity.title = itemDTO.title;
            tripDataEndity.rank = itemDTO.rank;
            tripDataEndity.serviceType = itemDTO.serviceType;
            tripDataEndity.address = itemDTO.address;
            tripDataEndity.createTime = itemDTO.createTime;
            tripDataEndity.serviceImageUrl = itemDTO.serviceImageUrl;
            
            [tripArray addObject:tripDataEndity];
            
            
            
        }];
        
        block(tripArray, YES, [request.currentPage intValue]);
        
        return;
    }
    //返回请求标记tag
    NSNumber *requestTag = [GDataManager asyncRequestByType:NetAdapter_ListCarService andObject:request success:^(TLListCarServiceResponse* responseDTO) {

        
        
        if (block) {
            block(responseDTO.result.data, YES,request.currentPage.intValue);
        }
    } failure:^(id responseDTO) {
        if (block) {
            block(responseDTO, NO,0);
        }
    }];
    [requestArr addObject:requestTag];
}

/*
 *新车详情
 */
- (void)getCarServiceDetail:(TLCarServiceDetailRequest*)request requestArray:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block{
    
    if (request.dataType.integerValue==5) {
        TLCarServiceDetailEntity *_detailDto = [TLCarServiceDetailEntity MR_findFirstByAttribute:@"serviceId" withValue:request.serviceId];
        TLCarServiceResult *tripDetailEntity = [[TLCarServiceResult alloc] init];
        
        tripDetailEntity.serviceId = _detailDto.serviceId;
        tripDetailEntity.title = _detailDto.title;
        tripDetailEntity.createTime = _detailDto.createTime;
        tripDetailEntity.viewCount = _detailDto.viewCount;
        tripDetailEntity.commentCount = _detailDto.commentCount;
        tripDetailEntity.serviceType = _detailDto.serviceType;
        tripDetailEntity.rank = _detailDto.rank;
        tripDetailEntity.address = _detailDto.address;
        tripDetailEntity.serviceDesc = _detailDto.serviceDesc;
        tripDetailEntity.userPhone = _detailDto.userPhone;

        
        
        TLTripUserDTO *userEntity = [[TLTripUserDTO alloc] init];
        userEntity.userIcon  = _detailDto.user.userIcon;
        userEntity.userIndex = _detailDto.user.userIndex;
        userEntity.userName = _detailDto.user.userName;
        userEntity.visitTime = _detailDto.user.visitTime;
        userEntity.loginId = _detailDto.user.loginId;
        tripDetailEntity.user = userEntity;
        
        
        
        NSMutableArray *imageArray = [NSMutableArray array];
        [_detailDto.images enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
            TLImageEntity *imageDto = obj;
            TLImageDTO *image = [[TLImageDTO alloc] init];
            image.imageName = imageDto.imageName;
            image.imageUrl = imageDto.imageUrl;
            [imageArray addObject:image];
        }];
        tripDetailEntity.images = (NSArray<TLImageDTO>*)imageArray;
        
        
        block(tripDetailEntity, YES);
        return;
    }
    //返回请求标记tag
    NSNumber *requestTag = [GDataManager asyncRequestByType:NetAdapter_ViewCarService andObject:request success:^(TLSaveCarServiceResponse* responseDTO) {
        
        
        if (block) {
            block(responseDTO.result, YES);
        }
    } failure:^(id responseDTO) {
        if (block) {
            block(responseDTO, NO);
        }
    }];
    [requestArr addObject:requestTag];
}


/*
 * 添加车辆租赁
 */
- (void)addCarService:(TLSaveCarServiceRequest*)request requestArr:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block{
    
    __block NSString *longitude;
    __block NSString *latitude;
    [GUserDataHelper getLocationInfo:^(id currentLongitude, id currentLatitude) {
        longitude = currentLongitude;
        latitude = currentLatitude;
    }];
    request.longtitude = longitude;
    request.latitude = latitude;
    
    //返回请求标记tag
    NSNumber *requestTag = [GDataManager asyncRequestByType:NetAdapter_SaveCarService andObject:request success:^(TLSaveCarServiceResponse* responseDTO) {
        


        if (block) {
            block(responseDTO, YES);
        }
    } failure:^(id responseDTO) {
        if (block) {
            block(responseDTO, NO);
        }
    }];
    [requestArr addObject:requestTag];
}

/*
 * 添加车辆租赁
 */
- (void)makeCarScore:(TLCarServiceMackScoreRequest*)request requestArr:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block{
    //返回请求标记tag
    NSNumber *requestTag = [GDataManager asyncRequestByType:NetAdapter_MakeScore andObject:request success:^(TLCarServiceMackScoreResponse* responseDTO) {

        if (block) {
            block(responseDTO, YES);
        }
    } failure:^(id responseDTO) {
        if (block) {
            block(responseDTO, NO);
        }
    }];
    [requestArr addObject:requestTag];
}



/*
 *汽车租赁列表 listCarRent
 */
- (void)getSecondGoodsList:(TLListSecondGoodsRequest*)request requestArray:(__weak NSMutableArray*)requestArr block:(DataHelper_Block_Page)block{
    NSLog(@"SecondGoodsList---------------------------------:%@",request.dataType);
    
    
    
    
    if (request.dataType.integerValue==5){
        
        if (request.currentPage.integerValue>1) {
            block([NSArray array], YES, 0);
            return;
        }
        NSArray *tlTripDataArray = [TLSecondGoodsEntity MR_findAllSortedBy:@"createTime" ascending:YES];
        
        NSMutableArray *tripArray = [NSMutableArray array];
        
        [tlTripDataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            TLSecondGoodsEntity *itemDTO = obj;
            TLSecondGoodsDTO *tripDataEndity = [[TLSecondGoodsDTO alloc] init];
            tripDataEndity.goodsId = itemDTO.goodsId;
            tripDataEndity.goodsName = itemDTO.goodsName;
            tripDataEndity.oldDesc = itemDTO.oldDesc;
            tripDataEndity.goodsDesc = itemDTO.goodsDesc;
            tripDataEndity.price = itemDTO.price;
            tripDataEndity.editor = itemDTO.editor;
            tripDataEndity.createTime = itemDTO.createTime;
            tripDataEndity.goodsImageUrl = itemDTO.goodsImageUrl;
            
            [tripArray addObject:tripDataEndity];
            
            
            
        }];
        
        block(tripArray, YES, [request.currentPage intValue]);
        
        return;
    }
    

        NSNumber *requestTag = [GDataManager asyncRequestByType:NetAdapter_ListSecondGoods andObject:request success:^(TLListSecondGoodsResponse* responseDTO) {
            
            
            
            if (block) {
                block(responseDTO.result.data, YES,request.currentPage.intValue);
            }
        } failure:^(id responseDTO) {
            if (block) {
                block(responseDTO, NO,0);
            }
        }];
        [requestArr addObject:requestTag];
    
    
}
/*
 *新车详情
 */
- (void)getSecondGoodsDetail:(TLSecondGoodsDetailRequest*)request requestArray:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block{
    
    if (request.dataType.integerValue==5){
        TLSecondGoodsDetailEntity *_detailDto = [TLSecondGoodsDetailEntity MR_findFirstByAttribute:@"goodsId" withValue:request.goodsId];
        TLSecondGoodsResult *tripDetailEntity = [[TLSecondGoodsResult alloc] init];
  
        tripDetailEntity.goodsId = _detailDto.goodsId;
        tripDetailEntity.title = _detailDto.title;
        tripDetailEntity.createTime = _detailDto.createTime;
        tripDetailEntity.viewCount = _detailDto.viewCount;
        tripDetailEntity.commentCount = _detailDto.commentCount;
        tripDetailEntity.goodsName = _detailDto.goodsName;
        tripDetailEntity.oldDesc = _detailDto.oldDesc;
        tripDetailEntity.price = _detailDto.price;
        tripDetailEntity.address = _detailDto.address;
        tripDetailEntity.goodsDesc = _detailDto.goodsDesc;
        tripDetailEntity.userPhone = _detailDto.userPhone;
        
        
        
        
        TLTripUserDTO *userEntity = [[TLTripUserDTO alloc] init];
        userEntity.userIcon  = _detailDto.user.userIcon;
        userEntity.userIndex = _detailDto.user.userIndex;
        userEntity.userName = _detailDto.user.userName;
        userEntity.visitTime = _detailDto.user.visitTime;
        userEntity.loginId = _detailDto.user.loginId;
        tripDetailEntity.user = userEntity;
        
        NSMutableArray *imageArray = [NSMutableArray array];
        [_detailDto.images enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
            TLImageEntity *imageDto = obj;
            TLImageDTO *image = [[TLImageDTO alloc] init];
            image.imageName = imageDto.imageName;
            image.imageUrl = imageDto.imageUrl;
            [imageArray addObject:image];
        }];
        tripDetailEntity.images = (NSArray<TLImageDTO>*)imageArray;
        
        block(tripDetailEntity, YES);
        return;
    }
    

        NSNumber *requestTag = [GDataManager asyncRequestByType:NetAdapter_ViewSecondGoods andObject:request success:^(TLSecondGoodsDetailResponse* responseDTO) {
            
            if (block) {
                block(responseDTO.result, YES);
            }
        } failure:^(id responseDTO) {
            if (block) {
                block(responseDTO, NO);
            }
        }];
        [requestArr addObject:requestTag];
    
    
   
}
/*
 * 添加车辆租赁
 */
- (void)addSecondGoods:(TLSaveSecondGoodsRequest*)request requestArr:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block{
    NSNumber *requestTag = [GDataManager asyncRequestByType:NetAdapter_SaveSecondGoods andObject:request success:^(TLSaveSecondGoodsResponse* responseDTO) {
        
        

        if (block) {
            block(responseDTO, YES);
        }
    } failure:^(id responseDTO) {
        if (block) {
            block(responseDTO, NO);
        }
    }];
    [requestArr addObject:requestTag];
}


/*
 *汽车租赁列表 listCarRent
 */
- (void)getStoreList:(TLListMerchantRequestDTO*)request requestArray:(__weak NSMutableArray*)requestArr block:(DataHelper_Block_Page)block{
    NSLog(@"StoreList---------------------------------:%@",request.dataType);
    
    
    if(request.dataType.integerValue==5){
        
        if (request.currentPage.integerValue>1) {
            block([NSArray array], YES, 0);
            return;
        }
        NSArray *tlTripDataArray = [TLStoreEntity MR_findAllSortedBy:@"createTime" ascending:YES];
        
        NSMutableArray *tripArray = [NSMutableArray array];
        
        [tlTripDataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            TLStoreEntity *itemDTO = obj;
            
            TLStoreDTO *tripDataEndity = [[TLStoreDTO alloc] init];
            tripDataEndity.merchantId = itemDTO.merchantId;
            tripDataEndity.merchantName = itemDTO.merchantName;
            tripDataEndity.rank = itemDTO.rank;
            tripDataEndity.merchantType = itemDTO.merchantType;
            tripDataEndity.editor = itemDTO.editor;
            tripDataEndity.createTime = itemDTO.createTime;
            tripDataEndity.merchantImageUrl = itemDTO.merchantImageUrl;
            tripDataEndity.distance = itemDTO.distance;
            
            [tripArray addObject:tripDataEndity];
            
        }];
        
        block(tripArray, YES, [request.currentPage intValue]);

        
        return;
    }
    

        NSNumber *requestTag = [GDataManager asyncRequestByType:NetAdapter_ListMerchant andObject:request success:^(TLListMerchantResponseDTO* responseDTO) {
            
            
            
            
            if (block) {
                block(responseDTO.result.data, YES,request.currentPage.intValue);
            }
        } failure:^(id responseDTO) {
            if (block) {
                block(responseDTO, NO,0);
            }
        }];
        [requestArr addObject:requestTag];
    
}
/*
 *新车详情
 */
- (void)getStoreDetail:(TLListMerchantDetailRequestDTO*)request requestArray:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block{
    
    if (request.dataType.integerValue==5){
        
        TLStoreDetailEntity *_detailDto = [TLStoreDetailEntity MR_findFirstByAttribute:@"merchantId" withValue:request.merchantId];
        TLListMerchantDetailResultDTO *tripDetailEntity = [[TLListMerchantDetailResultDTO alloc] init];
        tripDetailEntity.merchantId = _detailDto.merchantId;
        tripDetailEntity.merchantName = _detailDto.merchantName;
        tripDetailEntity.createTime = _detailDto.createTime;
        tripDetailEntity.viewCount = _detailDto.viewCount;
        tripDetailEntity.commentCount = _detailDto.commentCount;
        tripDetailEntity.rank = _detailDto.rank;
        tripDetailEntity.openTime = _detailDto.openTime;
        tripDetailEntity.address = _detailDto.address;
        tripDetailEntity.park = _detailDto.park;
        tripDetailEntity.merchantDesc = _detailDto.merchantDesc;
        tripDetailEntity.merchantIcon = _detailDto.merchantIcon;
        


        
       
        
        NSMutableArray *imageArray = [NSMutableArray array];
        [_detailDto.images enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
            TLImageEntity *imageDto = obj;
            TLImageDTO *image = [[TLImageDTO alloc] init];
            image.imageName = imageDto.imageName;
            image.imageUrl = imageDto.imageUrl;
            [imageArray addObject:image];
        }];
        tripDetailEntity.images = (NSArray<TLImageDTO>*)imageArray;
        
        
        block(tripDetailEntity, YES);
        return;
    }
    

        NSNumber *requestTag = [GDataManager asyncRequestByType:NetAdapter_ViewMerchant andObject:request success:^(TLListMerchantDetailResponseDTO* responseDTO) {
            
            
            if (block) {
                block(responseDTO.result, YES);
            }
        } failure:^(id responseDTO) {
            if (block) {
                block(responseDTO, NO);
            }
        }];
        [requestArr addObject:requestTag];

    
    
}



/*
 * 添加车辆租赁
 */
- (void)makeStoreScore:(TLCarServiceMackScoreRequest*)request requestArr:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block{
    NSNumber *requestTag = [GDataManager asyncRequestByType:NetAdapter_MakeMerchantScore andObject:request success:^(TLCarServiceMackScoreResponse* responseDTO) {
        
        if (block) {
            block(responseDTO, YES);
        }
    } failure:^(id responseDTO) {
        if (block) {
            block(responseDTO, NO);
        }
    }];
    [requestArr addObject:requestTag];
}


/*
 * sos 呼叫
 */
- (void)makeSos:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block{
    RequestDTO *request = [[RequestDTO alloc] init];
    NSNumber *requestTag = [GDataManager asyncRequestByType:NetAdapter_MakeSOS andObject:request success:^(TLEmergencyResponseDTO* responseDTO) {
        
        if (block) {
            block(responseDTO, YES);
        }
    } failure:^(id responseDTO) {
        if (block) {
            block(responseDTO, NO);
        }
    }];
    [requestArr addObject:requestTag];
}


/*
 *获取个人信息
 */
- (void)getUserView:(TLUserViewRequestDTO*)request requestArray:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block{
    
    if (self.userViewResultData==nil) {
        self.userViewResultData = [NSMutableDictionary dictionary];
    }
    
    if ([self.userViewResultData valueForKey:request.loginId]!=nil) {
        block([self.userViewResultData valueForKey:request.loginId], YES);
        return;
    }
    
    NSNumber *requestTag = [GDataManager asyncRequestByType:NetAdapter_UserView andObject:request success:^(TLUserViewResponseDTO* responseDTO) {
        
        if (block) {
            [self.userViewResultData setValue:responseDTO.result forKey:request.loginId];
            block(responseDTO.result, YES);
        }
    } failure:^(id responseDTO) {
        if (block) {
            block(responseDTO, NO);
        }
    }];
    [requestArr addObject:requestTag];
}



/*
 * 修改个人信息
 */
- (void)editUserInfo:(TLUserEditRequestDTO*)request requestArr:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block{
    NSNumber *requestTag = [GDataManager asyncRequestByType:NetAdapter_UserEdit andObject:request success:^(TLResponseDTO* responseDTO) {
        
        if (block) {
            TLUserViewRequestDTO *userViewRequest = [[TLUserViewRequestDTO alloc] init];
            userViewRequest.loginId = request.loginId;

                [self.userViewResultData removeObjectForKey:request.loginId];
            [self getUserView:userViewRequest requestArray:[NSMutableArray array] block:^(id obj, BOOL ret) {
                
            }];
            block(responseDTO, YES);
        }
    } failure:^(id responseDTO) {
        if (block) {
            block(responseDTO, NO);
        }
    }];
    [requestArr addObject:requestTag];
}


- (void)saveAppeal:(TLAppealRequestDTO*)request requestArr:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block{
    NSNumber *requestTag = [GDataManager asyncRequestByType:NetAdapter_SaveAppeal andObject:request success:^(TLEmergencyResponseDTO* responseDTO) {
        
        if (block) {
            block(responseDTO, YES);
        }
    } failure:^(id responseDTO) {
        if (block) {
            block(responseDTO, NO);
        }
    }];
    [requestArr addObject:requestTag];
}





/*
 *  50,个人资料认证接口(已完成)
 访问地址:/action/authority
 */
- (void)authority:(TLAuthorityRequestDTO*)request requestArr:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block{
    NSNumber *requestTag = [GDataManager asyncRequestByType:NetAdapter_Authority andObject:request success:^(TLResponseDTO* responseDTO) {

        [self.userViewResultData removeObjectForKey:GUserDataHelper.tlUserInfo.loginId];
        if (block) {
            block(responseDTO, YES);
        }
    } failure:^(id responseDTO) {
        if (block) {
            block(responseDTO, NO);
        }
    }];
    [requestArr addObject:requestTag];
}

/*
 *  52,开通会员(已完成)
 访问地址:/action/openVip
 */
- (void)openVip:(TLOpenVipRequestDTO*)request requestArr:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block{
    NSNumber *requestTag = [GDataManager asyncRequestByType:NetAdapter_OpenVip andObject:request success:^(TLOpenVipResponseDTO* responseDTO) {
        
        if (block) {
            /**
             *  删除缓存重新获取数据
             */
            self.userViewResultData = nil;
            block(responseDTO.result, YES);
        }
    } failure:^(id responseDTO) {
        if (block) {
            block(responseDTO, NO);
        }
    }];
    [requestArr addObject:requestTag];
}

/*
 * 53,购买途乐币(已完成)
 访问地址:/action/buyTLB
 */
- (void)buyTLB:(TLBuyTLBRequestDTO*)request requestArr:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block{
    
    NSLog(@"pay === 准备支付");
    NSNumber *requestTag = [GDataManager asyncRequestByType:NetAdapter_BuyTLB andObject:request success:^(TLBuyTLBResponseDTO* responseDTO) {
//            NSLog(@"pay === 获取支付订单信息%@",responseDTO);
//            [self.userViewResultData removeObjectForKey:GUserDataHelper.tlUserInfo.loginId];
//        
//            [[AlipaySDK defaultService] payOrder:responseDTO.result.iosAlipaycreateOrderUrl fromScheme:UMSOCIAL_WXAPP_ID callback:^(NSDictionary *resultDic) {
//                NSLog(@"pay === 支付完毕%@",resultDic);
//                NSLog(@"reslut = %@",resultDic);
//                //NSString *memo = resultDic[@"memo"];
//                NSString *result = resultDic[@"result"];
//                NSNumber *resultStatus = resultDic[@"resultStatus"];
//                
//                //partner="2088911301538700"&seller_id="itulesh@126.com"&out_trade_no="TL15072023153600008"&subject="购买10途乐币"&body="购买10途乐币,订单编号:TL15072023153600008"&total_fee="0.01"&notify_url="http://121.42.208.158:8080/travel//action/alipayBackNotify"&service="mobile.securitypay.pay"&payment_type="1"&_input_charset="utf-8"&it_b_pay="30m"&return_url="m.alipay.com"
//
//                
//                
//                
//                //            _input_charset="utf-8"&body="药品"&it_b_pay="2m"&notify_url="http://118.194.241.218:18080/ErxCloud/restservices/payPrice/payPriceBackOnLine"&out_trade_no="9e41a1c729914119a63557e947bc7acc"&partner="2088101568353491"&payment_type="1"&seller_id="alipay-test07@alipay.com"&service="mobile.securitypay.pay"&subject="线上支付,订单编号:5852edf3d29d495793272a090e83ae92"&total_fee="0.01"&success="true"&sign_type="RSA"&sign="J259bQkMBb/eK+9g40DWikHd1DBs82NnHY9rVC5/a8orkrL0VstDABXwFkOcIdbA2C/kT/GLAA4HH6Kpr7QYquzsN3jGKTQboEcOT143ekVd2SMeiXz2Oyu1V0tZpleWCe0zJHHBM/U0d9ve6efya6bYZOPmYoO7NxzW7pmiFvI="
//                
//                // 判断resultStatus 为“9000”则代表支付成功，具体状态码代表含义可参考接口文档
//                BOOL isSuccess = [result rangeOfString:@"success=\"true\""].location != NSNotFound;
//                if (resultStatus.integerValue == 9000 && isSuccess) {
//                    // resultStatus=9000,并且 success="true"以及 sign="xxx"校验通过的情况下,较低安全级别的场合,也可以只通过检查 resultStatus 以及 success="true"来判定支付结果
//                    
//                    {
//                        // 缓存支付状态
//                        //                        request.outTradeNo = responseDTO.outTradeNo;
//                        //                        request.tradeNo = responseDTO.tradeNo;
//                        //                        request.payStatus = @"1";
//                        //                        [self cachePayOrader:request];
//                    }
//                    
//                    responseDTO.resultDesc = @"支付成功";
//                    block(responseDTO, YES);
//                }
//                else {
//                    if (resultStatus.integerValue == 8000) {
//                        // 判断resultStatus 为非“9000”则代表可能支付失败
//                        // “8000”代表支付结果因为支付渠道原因或者系统原因还在等待支付结果确认，最终交易是否成功以服务端异步通知为准（小概率状态）
//                        
//                        
//                        responseDTO.resultDesc = @"支付确认中";
//                        responseDTO.resultCode = [NSString stringWithFormat:@"%d",PayResult_PayWaiting];
//                        block(responseDTO, NO);
//                    }
//                    else if (resultStatus.integerValue == 6001) {
//                        responseDTO.resultDesc = @"支付取消";
//                        responseDTO.resultCode = [NSString stringWithFormat:@"%d",PayResult_PayPayCancel];
//                        block(responseDTO, NO);
//                    }
//                    else {
//                        responseDTO.resultDesc = @"支付失败";
//                        responseDTO.resultCode = [NSString stringWithFormat:@"%d",PayResult_PayPayFaild];
//                        block(responseDTO, NO);
//                    }
//                }
//            }];
        
        
        if (block) {
            block(responseDTO, YES);
        }
        
        } failure:^(id responseDTO) {
            NSLog(@"pay === 获取订单失败");
            if (block) {
                block(responseDTO, NO);
            }
        }];
    [requestArr addObject:requestTag];
}

/*
 * 54,增加成长值(已完成)(注：每天首次打开App的时候调用)
 访问地址:/action/addGrow
 */
- (void)addGrow:(TLAddGrowRequestDTO*)request requestArr:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block{
    NSNumber *requestTag = [GDataManager asyncRequestByType:NetAdapter_AddGrow andObject:request success:^(TLAddGrowResponseDTO* responseDTO) {
        
        if (block) {
            block(responseDTO.result, YES);
        }
    } failure:^(id responseDTO) {
        if (block) {
            block(responseDTO, NO);
        }
    }];
    [requestArr addObject:requestTag];
}




/*
 * 55,新闻列表(已完成)
 访问地址:/action/listNews
 */
- (void)listNews:(TLNewsListRequestDTO*)request requestArr:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block{
    NSNumber *requestTag = [GDataManager asyncRequestByType:NetAdapter_ListNews andObject:request success:^(TLNewsListResponseDTO* responseDTO) {
        
        if (block) {
            block(responseDTO.result.data, YES);
        }
    } failure:^(id responseDTO) {
        if (block) {
            block(responseDTO, NO);
        }
    }];
    [requestArr addObject:requestTag];
}

/*
 * 56,我的好友列表(已完成)
 访问地址:/action/myFriendList
 */
- (void)myFriendList:(TLMyFriendListRequestDTO*)request requestArr:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block{
    NSNumber *requestTag = [GDataManager asyncRequestByType:NetAdapter_MyFriendList andObject:request success:^(TLMyFriendsListResponseDTO* responseDTO) {
        
        if (block) {
            block(responseDTO.result.data, YES);
        }
    } failure:^(id responseDTO) {
        if (block) {
            block(responseDTO, NO);
        }
    }];
    [requestArr addObject:requestTag];
}

/*
 * 57,添加好友(已完成)
 访问地址:/action/addFriendApply
 */
- (void)addFriendApply:(TLAddFriendApplyRequestDTO*)request requestArr:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block{
    NSNumber *requestTag = [GDataManager asyncRequestByType:NetAdapter_AddFriendApply andObject:request success:^(TLAddFriendApplyResponseDTO* responseDTO) {
        
        if (block) {
            block(responseDTO, YES);
        }
    } failure:^(id responseDTO) {
        if (block) {
            block(responseDTO, NO);
        }
    }];
    [requestArr addObject:requestTag];
}

/*
 * 58,添加好友确认(已完成)
 访问地址:/action/confirmAddFriend
 */
- (void)confirmAddFriend:(TLComfirmAddFrinedRequestDTO*)request requestArr:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block{
    NSNumber *requestTag = [GDataManager asyncRequestByType:NetAdapter_ConfirmAddFriend andObject:request success:^(TLComfirmAddFriendResponseDTO* responseDTO) {
        
        if (block) {
            block(responseDTO, YES);
        }
    } failure:^(id responseDTO) {
        if (block) {
            block(responseDTO, NO);
        }
    }];
    [requestArr addObject:requestTag];
}



/*
 * 59，我加入的组织/全部组织(已完成)
 访问地址:/action/listOrganization TLListOrgRequestDTO TLListOrgResponseDTO TLListOrgResultDTO TLOrgDataDTO
 */
- (void)listOrganization:(TLListOrgRequestDTO*)request requestArr:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block{
    NSNumber *requestTag = [GDataManager asyncRequestByType:NetAdapter_ListOrganization andObject:request success:^(TLListOrgResponseDTO* responseDTO) {
        
        if (block) {
            block(responseDTO.result.data, YES);
        }
    } failure:^(id responseDTO) {
        if (block) {
            block(responseDTO, NO);
        }
    }];
    [requestArr addObject:requestTag];
}

/*
 * 60，组织详情(已完成)
 访问地址:/action/viewOrganization TLViewOrgRequestDTO TLViewOrgResponseDTO TLViewOrgResultDTO
 */
- (void)viewOrganization:(TLViewOrgRequestDTO*)request requestArr:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block{
    NSNumber *requestTag = [GDataManager asyncRequestByType:NetAdapter_ViewOrganization andObject:request success:^(TLViewOrgResponseDTO* responseDTO) {
        
        if (block) {
            block(responseDTO.result, YES);
        }
    } failure:^(id responseDTO) {
        if (block) {
            block(responseDTO, NO);
        }
    }];
    [requestArr addObject:requestTag];
}

/*
 * 61，加入组织/退出组织(已完成)
 访问地址:/action/operateOrganization TLOperOrgRequestDTO
 */
- (void)operateOrganization:(TLOperOrgRequestDTO*)request requestArr:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block{
    NSNumber *requestTag = [GDataManager asyncRequestByType:NetAdapter_OperateOrganization andObject:request success:^(TLResponseDTO* responseDTO) {
        
        if (block) {
            block(responseDTO.result, YES);
        }
    } failure:^(id responseDTO) {
        if (block) {
            block(responseDTO, NO);
        }
    }];
    [requestArr addObject:requestTag];
}
/*
 * 62，我加入的群组
 访问地址:/action/listGroup TLListGroupRequestDTO TLListGroupResponseDTO TLListGroupResultDTO TLGroupDataDTO
 */
- (void)listGroup:(TLListGroupRequestDTO*)request requestArr:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block{
    NSNumber *requestTag = [GDataManager asyncRequestByType:NetAdapter_ListGroup andObject:request success:^(TLListGroupResponseDTO* responseDTO) {
        
        if (block) {
            block(responseDTO.result.data, YES);
        }
    } failure:^(id responseDTO) {
        if (block) {
            block(responseDTO, NO);
        }
    }];
    [requestArr addObject:requestTag];
}



/*
 * 63，发送小喇叭消息
 访问地址:/action/sendOrgMessage TLSendOrgMessageRequestDTO
 */
- (void)sendOrgMessage:(TLSendOrgMessageRequestDTO*)request requestArr:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block{
    NSNumber *requestTag = [GDataManager asyncRequestByType:NetAdapter_SendOrgMessage andObject:request success:^(TLSendOrgMessageResponseDTO* responseDTO) {
        
        if (block) {
            block(responseDTO, YES);
        }
    } failure:^(id responseDTO) {
        if (block) {
            block(responseDTO, NO);
        }
    }];
    [requestArr addObject:requestTag];
}



/*
 * 组织消息列表(已完成)
 访问地址:/action/listOrgMessage TLListOrgMesssageRequestDTO TLListOrgMessageResponseDTO TLListOrgMessageResultDTO TLOrgMessageDTO
 请求参数
 */
- (void)listOrgMessage:(TLListOrgMesssageRequestDTO*)request requestArr:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block{
    NSNumber *requestTag = [GDataManager asyncRequestByType:NetAdapter_ListOrgMessage andObject:request success:^(TLListOrgMessageResponseDTO* responseDTO) {
        
        if (block) {
            block(responseDTO.result.data, YES);
        }
    } failure:^(id responseDTO) {
        if (block) {
            block(responseDTO, NO);
        }
    }];
    [requestArr addObject:requestTag];
}


/*
 64，群组加入申请/群组加入群组退出
 访问地址:/action/groupJoinApply TLGroupJoinApplyRequestDTO
 */
- (void)operateGroup:(TLGroupJoinApplyRequestDTO*)request requestArr:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block{
    NSNumber *requestTag = [GDataManager asyncRequestByType:NetAdapter_GroupJoinApply andObject:request success:^(TLResponseDTO* responseDTO) {
        
        if (block) {
            block(responseDTO, YES);
        }
    } failure:^(id responseDTO) {
        if (block) {
            block(responseDTO, NO);
        }
    }];
    [requestArr addObject:requestTag];
}
/*
 65，创建群组(已完成)
 访问地址:/action/saveGroup TLSaveGroupRequestDTO TLSaveGroupResponseDTO TLSaveGroupResultDTO */
- (void)saveGroup:(TLSaveGroupRequestDTO*)request requestArr:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block{
    __block NSString *longitude;
    __block NSString *latitude;
    [GUserDataHelper getLocationInfo:^(id currentLongitude, id currentLatitude) {
        longitude = currentLongitude;
        latitude = currentLatitude;
    }];
    request.longtitude = longitude;
    request.latitude = latitude;
    
    NSNumber *requestTag = [GDataManager asyncRequestByType:NetAdapter_SaveGroup andObject:request success:^(TLSaveGroupResponseDTO* responseDTO) {
        
        if (block) {
            block(responseDTO.result, YES);
        }
    } failure:^(id responseDTO) {
        if (block) {
            block(responseDTO, NO);
        }
    }];
    [requestArr addObject:requestTag];
}


/*
 66，群组详情(已完成)
 访问地址:/action/viewGroup TLViewGroupRequestDTO TLViewGroupResponseDTO TLViewGroupResultDTO
 */
- (void)viewGroup:(TLViewGroupRequestDTO*)request requestArr:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block{
    NSNumber *requestTag = [GDataManager asyncRequestByType:NetAdapter_ViewGroup andObject:request success:^(TLViewGroupResponseDTO* responseDTO) {
        
        if (block) {
            block(responseDTO.result, YES);
        }
    } failure:^(id responseDTO) {
        if (block) {
            block(responseDTO, NO);
        }
    }];
    [requestArr addObject:requestTag];
}



/*
 58，修改好友备注(已完成)
 访问地址:/action/reNameFriend TLRenameFriendRequestDTO
 */
- (void)reNameFriend:(TLRenameFriendRequestDTO*)request requestArr:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block{
    NSNumber *requestTag = [GDataManager asyncRequestByType:NetAdapter_ReNameFriend andObject:request success:^(TLResponseDTO* responseDTO) {
        
        [self.userViewResultData removeObjectForKey:request.friendLoginId];

        
        if (block) {
            block(responseDTO, YES);
        }
    } failure:^(id responseDTO) {
        if (block) {
            block(responseDTO, NO);
        }
    }];
    [requestArr addObject:requestTag];
}

- (void)pwdModify:(TLModifyPasswordRequestDTO*)request requestArr:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block{
    NSNumber *requestTag = [GDataManager asyncRequestByType:NetAdapter_PwdModify andObject:request success:^(TLResponseDTO* responseDTO) {
        
        if (block) {
            block(responseDTO, YES);
        }
    } failure:^(id responseDTO) {
        if (block) {
            block(responseDTO, NO);
        }
    }];
    [requestArr addObject:requestTag];
}


/*
 拉黑(已完成)
 访问地址:/action/reportBlack TLReportBlackRequestDTO TLReportBlackResponseDTO TLReportBlackResultDTO
 */
- (void)reportBlack:(TLReportBlackRequestDTO*)request requestArr:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block{
    NSNumber *requestTag = [GDataManager asyncRequestByType:NetAdapter_ReportBlack andObject:request success:^(TLReportBlackResponseDTO* responseDTO) {
        
        if (block) {
            block(responseDTO.result, YES);
        }
    } failure:^(id responseDTO) {
        if (block) {
            block(responseDTO, NO);
        }
    }];
    [requestArr addObject:requestTag];
}
/*
 添加商户（已完成）
 访问地址:/action/saveMerchant TLSaveMarchantRequestDTO  TLSaveMarchantResponseDTO TLSaveMarchantResultDTO
 */
- (void)saveMerchant:(TLSaveMarchantRequestDTO*)request requestArr:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block{
    NSNumber *requestTag = [GDataManager asyncRequestByType:NetAdapter_SaveMerchant andObject:request success:^(TLSaveMarchantResponseDTO* responseDTO) {
        
        if (block) {
            block(responseDTO.result, YES);
        }
    } failure:^(id responseDTO) {
        if (block) {
            block(responseDTO, NO);
        }
    }];
    [requestArr addObject:requestTag];
}



/**
 *  商户纠错(已完成)
 访问地址:/action/merchantError TLMerchantErrorRequestDTO TLMerchantErrorResponseDTO TLMerchantResultDTO
 请求参数
 *
 *  @param request    <#request description#>
 *  @param requestArr <#requestArr description#>
 *  @param block      <#block description#>
 */
- (void)merchantError:(TLMerchantErrorRequestDTO*)request requestArr:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block{
    NSNumber *requestTag = [GDataManager asyncRequestByType:NetAdapter_MerchantError andObject:request success:^(TLMerchantErrorResponseDTO* responseDTO) {
        
        if (block) {
            block(responseDTO, YES);
        }
    } failure:^(id responseDTO) {
        if (block) {
            block(responseDTO, NO);
        }
    }];
    [requestArr addObject:requestTag];
}




/**
 *  消息列表(已完成)
 访问地址:/action/sysMessageList TLSysMessageListRequestDTO TLSysMessageListResponseDTO TLSysMEssageListResultDTO TLSysMessageDTO
 *
 *  @param request    <#request description#>
 *  @param requestArr <#requestArr description#>
 *  @param block      <#block description#>
 */
- (void)sysMessageList:(TLSysMessageListRequestDTO*)request requestArr:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block{
    NSNumber *requestTag = [GDataManager asyncRequestByType:NetAdapter_SysMessageList andObject:request success:^(TLSysMessageListResponseDTO* responseDTO) {
        
        if (block) {
            block(responseDTO.result.data, YES);
        }
    } failure:^(id responseDTO) {
        if (block) {
            block(responseDTO, NO);
        }
    }];
    [requestArr addObject:requestTag];
}

/**
 *  本地保存保存聊天记录
 *
 *  @param info
 */
-(void)saveUserChatInfo:(NSString *)info{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath= [documentsDirectory stringByAppendingPathComponent:@"chatLogData.txt"];
    
    NSFileManager *fileManager = [[NSFileManager alloc]init];
    
    
    
     NSString *string = [[NSString alloc]initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSString *allInfo = [NSString stringWithFormat:@"%@|%@",string,info];
    
    NSData *fileData = [allInfo dataUsingEncoding:NSUTF8StringEncoding];
    [fileManager createFileAtPath:filePath contents:fileData attributes:nil];
    
    
    

   
   
    
    
    

    
    //    通过指定的路径读取文本内容
    
  

   
    
    
    
    
    
    
}
/**
 *  上传聊天记录
 */
-(void)uploadUserChatInfo{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath= [documentsDirectory stringByAppendingPathComponent:@"chatLogData.txt"];
    
    NSFileManager *fileManager = [[NSFileManager alloc]init];
    
    
    NSString *string = [[NSString alloc]initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
   
    
    NSData *fileData = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    
    TLUploadChatFileRequest *request = [[TLUploadChatFileRequest alloc] init];
    request.chatFile = fileData;
    
   [GDataManager asyncRequestByType:NetAdapter_UploadChatFile andObject:request success:^(TLResponseDTO* responseDTO) {
       
       
       
       NSData *fileData = [@"" dataUsingEncoding:NSUTF8StringEncoding];
       [fileManager createFileAtPath:filePath contents:fileData attributes:nil];
    } failure:^(id responseDTO) {
        
    }];
    
    
    
    
}

- (void)settingHidden:(NSString*)isShow requestArr:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block{
    
    TLHiddenSetting *request = [[TLHiddenSetting alloc] init];
    request.showLocation = isShow;
    NSNumber *requestTag = [GDataManager asyncRequestByType:NetAdapter_HiddenSetting andObject:request success:^(TLSysMessageListResponseDTO* responseDTO) {
        
        if (block) {
            block(responseDTO, YES);
        }
    } failure:^(id responseDTO) {
        if (block) {
            block(responseDTO, NO);
        }
    }];
    [requestArr addObject:requestTag];
}
- (void)removeFreind:(NSString*)loginId requestArr:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block{
    TLRemoveFriendRequest *request = [[TLRemoveFriendRequest alloc] init];
    request.friendLoginId = loginId;
    
    
    
    NSNumber *requestTag = [GDataManager asyncRequestByType:NetAdapter_RemoveFriend andObject:request success:^(TLResponseDTO* responseDTO) {
        [self.userViewResultData removeObjectForKey:loginId];
        if (block) {
            block(responseDTO, YES);
        }
    } failure:^(id responseDTO) {
        if (block) {
            block(responseDTO, NO);
        }
    }];
    [requestArr addObject:requestTag];
}

- (void)inviteGroupUser:(NSString*)loginIds rlGroupId:(NSString *)rlGroupId requestArr:(NSMutableArray *__weak)requestArr block:(DataHelper_Block)block{
    

    TLInviteGroupUser *request = [[TLInviteGroupUser alloc] init];
    request.rlGroupId  = rlGroupId;
    request.loginIds = loginIds;
    
    
    
    NSNumber *requestTag = [GDataManager asyncRequestByType:NetAdapter_InviteGroupUser andObject:request success:^(TLResponseDTO* responseDTO) {

        if (block) {
            block(responseDTO, YES);
        }
    } failure:^(id responseDTO) {
        if (block) {
            block(responseDTO, NO);
        }
    }];
    [requestArr addObject:requestTag];
}


/*
 *IOS内购充值接口(已完成) /action/tlbCharge  TLTlbChargeRequestDTO TLTlbChanrgeResponseDTO TLTlbChargeResultDTO
 */
- (void)tlbCharge:(TLTlbChargeRequestDTO*)request requestArr:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block{
    NSNumber *requestTag = [GDataManager asyncRequestByType:NetAdapter_TlbCharge andObject:request success:^(TLTlbChanrgeResponseDTO* responseDTO) {
        
        if (block) {
            /**
             *  删除缓存重新获取数据
             */
            self.userViewResultData = nil;
            block(responseDTO, YES);
        }
    } failure:^(id responseDTO) {
        if (block) {
            block(responseDTO, NO);
        }
    }];
    [requestArr addObject:requestTag];
}


@end
