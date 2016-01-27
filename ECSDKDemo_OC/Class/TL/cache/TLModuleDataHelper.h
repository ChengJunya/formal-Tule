//
//  TLModuleDataHelper.h
//  TL
//
//  Created by Rainbow on 3/17/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SuperDataHelper.H"
#import "TLTripListRequestDTO.h"
#import "TLAddTripRequestDTO.h"
#import "TLTripDetailRequestDTO.h"
#import "TLCommentListRequestDTO.h"
#import "TLCommentRequestDTO.h"
#import "TLSaveCollectRequestDTO.h"
#import "TLIsTopRequestDTO.h"
#import "TLAddBookNodeRequestDTO.h"
#import "TLWayBookDetailRequestDTO.h"
#import "TLActivityListRequestDTO.h"
#import "TLCommonCodeRequestDTO.h"
#import "TLActivitySaveRequestDTO.h"
#import "TLActivityDetailRequestDTO.h"
#import "TLActivityParticipateRequestDTO.h"
#import "TLListCarRequestDTO.h"
#import "TLListCarEvalutionRequestDTO.h"
#import "TLListCarRectRequestDTO.h"
#import "TLReportBlackRequestDTO.h"
#import "TLCarDetailRequestDTO.h"
#import "TLCarEvalDetailRequestDTO.h"
#import "TLViewCarRentRequestDTO.h"

#import "TLSaveCarRectRequestDTO.h"

#import "TLSaveCarServiceRequest.h"
#import "TLListCarServiceRequest.h"
#import "TLCarServiceDetailRequest.h"
#import "TLCarServiceMackScoreRequest.h"

#import "TLListMerchantRequestDTO.h"
#import "TLListMerchantDetailRequestDTO.h"
#import "TLSaveSecondGoodsRequest.h"
#import "TLListSecondGoodsRequest.h"
#import "TLSecondGoodsDetailRequest.h"


#import "TLUserEditRequestDTO.h"
#import "TLUserViewRequestDTO.h"

#import "TLAppealRequestDTO.h"


#import "TLAuthorityRequestDTO.h"
#import "TLOpenVipRequestDTO.h"
#import "TLBuyTLBRequestDTO.h"
#import "TLAddGrowRequestDTO.h"
#import "TLNewsListRequestDTO.h"
#import "TLMyFriendListRequestDTO.h"
#import "TLAddFriendApplyRequestDTO.h"
#import "TLComfirmAddFrinedRequestDTO.h"


#import "TLListOrgRequestDTO.h"
#import "TLViewOrgRequestDTO.h"
#import "TLOperOrgRequestDTO.h"
#import "TLListGroupRequestDTO.h"
#import "TLSendOrgMessageRequestDTO.h"


#import "TLGroupJoinApplyRequestDTO.h"
#import "TLSaveGroupRequestDTO.h"
#import "TLViewGroupRequestDTO.h"
#import "UserDataHelper.h"

#import "TLListOrgMesssageRequestDTO.h"
#import "TLRenameFriendRequestDTO.h"

#import "TLModifyPasswordRequestDTO.h"
#import "TLSaveMarchantRequestDTO.h"

#import "TLMerchantErrorRequestDTO.h"
#import "TLSysMessageListRequestDTO.h"

#import "TLTlbChargeRequestDTO.h"


typedef enum {
    PayResult_PaySuccess = 7,                   // 支付成功
    PayResult_PayWaiting = 8,                   // 支付等待
    PayResult_PayPayFaild = 9,                  // 支付失败
    PayResult_PayPayCancel = 10,                // 支付取消
    
    PayResult_Validate_OrderUnExist = 2,        // 订单不存在
    PayResult_Validate_OrderAlreadyPay = 3,     // 订单已经支付
    PayResult_Validate_OrderUnusual = 4,        // 订单状态异
    PayResult_Validate_OrderError = 5,          // 订单状态错误
    
    PayResult_Validate_CouponError = 6,         // 优惠卷过期
    PayResult_Validate_StoreNOAliPay = -1,      // 药店支付宝支付未开通请改用现金支付
    PayResult_UnknowFaild = 1                   // 请稍后重试
} PayResultType;

@interface TLModuleDataHelper : SuperDataHelper
//单例define
ZX_DECLARE_SINGLETON(TLModuleDataHelper)



/*
 *已发表攻略,路书，游记列表查询 分页获取
 @param orderByTime 是否按照时间顺序
 @param orderByViewCount 是否热度
 @param cityId 地市id
 @param type   类型//1-攻略 2-路数 3-游记
 */
- (void)getTripList:(TLTripListRequestDTO*)tripRequestDto requestArr:(__weak NSMutableArray*)requestArr block:(DataHelper_Block_Page)block;

/*
 * 刷新获取
 */
- (void)getMyTripList:(TLTripListRequestDTO*)tripRequestDto requestArr:(__weak NSMutableArray*)requestArr block:(DataHelper_Block_Page)block;
/*
 *攻略，路书（主题），游记录入
 */
- (void)addTrip:(TLAddTripRequestDTO*)requestDTO  requestArray:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block;
/*
 *路书节点录入
 */
- (void)addWayBookNode:(TLAddBookNodeRequestDTO*)request requestArray:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block;

/*
 *游记，攻略详情
 */
- (void)getTripDetail:(TLTripDetailRequestDTO*)requestDTO requestArray:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block;
/*
 *路书详情
 */
- (void)getWayBookDetail:(TLWayBookDetailRequestDTO*)requestDTO requestArray:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block;



/*
 *攻略，路书，游记评论查询 分页
 */
- (void)getCommentList:(TLCommentListRequestDTO*)request requestArr:(__weak NSMutableArray*)requestArr block:(DataHelper_Block_Page)block;
/*
 *攻略，路书，游记评论
 */
- (void)addComment:(TLCommentRequestDTO*)request requestArr:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block;



/*
 *获取当前游记，攻略，路书，活动是否置顶
 */
- (void)isTop:(TLIsTopRequestDTO*)request requestArray:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block;
/*
 *获取当前游记，攻略，路书，活动 置顶
 */
- (void)doTop:(TLIsTopRequestDTO*)request requestArray:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block;
/*
 *码表获取
 */
- (void)commonCode:(TLCommonCodeRequestDTO*)request  requestArray:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block;
/*
 *活动录入
 */
- (void)activitySave:(TLActivitySaveRequestDTO*)request requestArray:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block;
/*
 *活动列表
 */
- (void)getActivityList:(TLActivityListRequestDTO*)request requestArray:(__weak NSMutableArray*)requestArr block:(DataHelper_Block_Page)block;
/*
 *活动详情
 */
- (void)getActivityDetail:(TLActivityDetailRequestDTO*)request requestArray:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block;
/*
 *报名活动
 */
- (void)activityParticipate:(TLActivityParticipateRequestDTO*)request  requestArray:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block;

/*
 *攻略，路书，游记 收藏
 */
- (void)addCollect:(TLSaveCollectRequestDTO*)request requestArr:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block;





/*
 29新车列表（已完成）
 访问地址:/action/listCar
 */
- (void)getNewCarList:(TLListCarRequestDTO*)request requestArray:(__weak NSMutableArray*)requestArr block:(DataHelper_Block_Page)block;
/*
 *车评列表 listCarEvaluation
 */
- (void)getCarEvalutionList:(TLListCarEvalutionRequestDTO*)request requestArray:(__weak NSMutableArray*)requestArr block:(DataHelper_Block_Page)block;
/*
 *汽车租赁列表 listCarRent
 */
- (void)getCarRectList:(TLListCarRectRequestDTO*)request requestArray:(__weak NSMutableArray*)requestArr block:(DataHelper_Block_Page)block;

/*
 *新车详情
 */
- (void)getNewCarDetail:(TLCarDetailRequestDTO*)request requestArray:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block;
/*
 *车评详情
 */
- (void)getCarEvalutionDetail:(TLCarEvalDetailRequestDTO*)request requestArray:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block;
/*
 *车辆租赁详情
 */
- (void)getCarRentDetail:(TLViewCarRentRequestDTO*)request requestArray:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block;

/*
 * 添加车辆租赁
 */
- (void)addCarRect:(TLSaveCarRectRequestDTO*)request requestArr:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block;


/*
 *汽车租赁列表 listCarRent
 */
- (void)getCarServiceList:(TLListCarServiceRequest*)request requestArray:(__weak NSMutableArray*)requestArr block:(DataHelper_Block_Page)block;

/*
 *新车详情
 */
- (void)getCarServiceDetail:(TLCarServiceDetailRequest*)request requestArray:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block;


/*
 * 添加车辆租赁
 */
- (void)addCarService:(TLSaveCarServiceRequest*)request requestArr:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block;

/*
 * 添加车辆租赁
 */
- (void)makeCarScore:(TLCarServiceMackScoreRequest*)request requestArr:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block;





/*
 *汽车租赁列表 listCarRent
 */
- (void)getSecondGoodsList:(TLListSecondGoodsRequest*)request requestArray:(__weak NSMutableArray*)requestArr block:(DataHelper_Block_Page)block;
/*
 *新车详情
 */
- (void)getSecondGoodsDetail:(TLSecondGoodsDetailRequest*)request requestArray:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block;
/*
 * 添加车辆租赁
 */
- (void)addSecondGoods:(TLSaveSecondGoodsRequest*)request requestArr:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block;


/*
 *汽车租赁列表 listCarRent
 */
- (void)getStoreList:(TLListMerchantRequestDTO*)request requestArray:(__weak NSMutableArray*)requestArr block:(DataHelper_Block_Page)block;
/*
 *新车详情
 */
- (void)getStoreDetail:(TLListMerchantDetailRequestDTO*)request requestArray:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block;



/*
 * 添加车辆租赁
 */
- (void)makeStoreScore:(TLCarServiceMackScoreRequest*)request requestArr:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block;


/*
 * sos 呼叫
 */
- (void)makeSos:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block;



/*
 *获取个人信息
 */
- (void)getUserView:(TLUserViewRequestDTO*)request requestArray:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block;



/*
 * 修改个人信息
 */
- (void)editUserInfo:(TLUserEditRequestDTO*)request requestArr:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block;


/*
 * 申诉
 */
- (void)saveAppeal:(TLAppealRequestDTO*)request requestArr:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block;



/*
 *  50,个人资料认证接口(已完成)
  访问地址:/action/authority
 */
- (void)authority:(TLAuthorityRequestDTO*)request requestArr:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block;

/*
 *  52,开通会员(已完成)
 访问地址:/action/openVip
 */
- (void)openVip:(TLOpenVipRequestDTO*)request requestArr:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block;

/*
 * 53,购买途乐币(已完成)
 访问地址:/action/buyTLB
 */
- (void)buyTLB:(TLBuyTLBRequestDTO*)request requestArr:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block;

/*
 * 54,增加成长值(已完成)(注：每天首次打开App的时候调用)
 访问地址:/action/addGrow
 */
- (void)addGrow:(TLAddGrowRequestDTO*)request requestArr:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block;

/*
 * 55,新闻列表(已完成)
 访问地址:/action/listNews
 */
- (void)listNews:(TLNewsListRequestDTO*)request requestArr:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block;

/*
 * 56,我的好友列表(已完成)
 访问地址:/action/myFriendList
 */
- (void)myFriendList:(TLMyFriendListRequestDTO*)request requestArr:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block;

/*
 * 57,添加好友(已完成)
 访问地址:/action/addFriendApply
 */
- (void)addFriendApply:(TLAddFriendApplyRequestDTO*)request requestArr:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block;

/*
 * 58,添加好友确认(已完成)
 访问地址:/action/confirmAddFriend
 */
- (void)confirmAddFriend:(TLComfirmAddFrinedRequestDTO*)request requestArr:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block;



/*
 * 59，我加入的组织/全部组织(已完成)
 访问地址:/action/listOrganization TLListOrgRequestDTO TLListOrgResponseDTO TLListOrgResultDTO TLOrgDataDTO
 */
- (void)listOrganization:(TLListOrgRequestDTO*)request requestArr:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block;
/*
 * 60，组织详情(已完成)
 访问地址:/action/viewOrganization TLViewOrgRequestDTO TLViewOrgResponseDTO TLViewOrgResultDTO
 */
- (void)viewOrganization:(TLViewOrgRequestDTO*)request requestArr:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block;
/*
 * 61，加入组织/退出组织(已完成)
 访问地址:/action/operateOrganization TLOperOrgRequestDTO
 */
- (void)operateOrganization:(TLOperOrgRequestDTO*)request requestArr:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block;
/*
 * 62，我加入的群组
 访问地址:/action/listGroup TLListGroupRequestDTO TLListGroupResponseDTO TLListGroupResultDTO TLGroupDataDTO
 */
- (void)listGroup:(TLListGroupRequestDTO*)request requestArr:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block;
/*
 * 63，发送小喇叭消息
 访问地址:/action/sendOrgMessage TLSendOrgMessageRequestDTO
 */
- (void)sendOrgMessage:(TLSendOrgMessageRequestDTO*)request requestArr:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block;





/*
 * 组织消息列表(已完成)
 访问地址:/action/listOrgMessage TLListOrgMesssageRequestDTO TLListOrgMessageResponseDTO TLListOrgMessageResultDTO TLOrgMessageDTO
 请求参数
 */
- (void)listOrgMessage:(TLListOrgMesssageRequestDTO*)request requestArr:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block;


/*
 64，群组加入申请/群组加入群组退出
 访问地址:/action/groupJoinApply TLGroupJoinApplyRequestDTO
 */
- (void)operateGroup:(TLGroupJoinApplyRequestDTO*)request requestArr:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block;
/*
 65，创建群组(已完成)
 访问地址:/action/saveGroup TLSaveGroupRequestDTO TLSaveGroupResponseDTO TLSaveGroupResultDTO */
- (void)saveGroup:(TLSaveGroupRequestDTO*)request requestArr:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block;

/*
 66，群组详情(已完成)
 访问地址:/action/viewGroup TLViewGroupRequestDTO TLViewGroupResponseDTO TLViewGroupResultDTO
 */
- (void)viewGroup:(TLViewGroupRequestDTO*)request requestArr:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block;

/*
 拉黑(已完成)
 访问地址:/action/reportBlack TLReportBlackRequestDTO TLReportBlackResponseDTO TLReportBlackResultDTO
 */
- (void)reportBlack:(TLReportBlackRequestDTO*)request requestArr:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block;



/*
 58，修改好友备注(已完成)
 访问地址:/action/reNameFriend TLRenameFriendRequestDTO
 */
- (void)reNameFriend:(TLRenameFriendRequestDTO*)request requestArr:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block;

/*
 6 密码修改(已完成)
 访问地址:   /action/pwdModify (需要登陆后才可以进行操作)
 请求参数
 */
- (void)pwdModify:(TLModifyPasswordRequestDTO*)request requestArr:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block;


/*
 添加商户（已完成）
 访问地址:/action/saveMerchant TLSaveMarchantRequestDTO  TLSaveMarchantResponseDTO TLSaveMarchantResultDTO
 */
- (void)saveMerchant:(TLSaveMarchantRequestDTO*)request requestArr:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block;






/**
 *  商户纠错(已完成)
 访问地址:/action/merchantError TLMerchantErrorRequestDTO TLMerchantErrorResponseDTO TLMerchantResultDTO
 请求参数
 *
 *  @param request    <#request description#>
 *  @param requestArr <#requestArr description#>
 *  @param block      <#block description#>
 */
- (void)merchantError:(TLMerchantErrorRequestDTO*)request requestArr:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block;




/**
 *  消息列表(已完成)
 访问地址:/action/sysMessageList TLSysMessageListRequestDTO TLSysMessageListResponseDTO TLSysMEssageListResultDTO TLSysMessageDTO
 *
 *  @param request    <#request description#>
 *  @param requestArr <#requestArr description#>
 *  @param block      <#block description#>
 */
- (void)sysMessageList:(TLSysMessageListRequestDTO*)request requestArr:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block;


- (void)settingHidden:(NSString*)isShow requestArr:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block;

- (void)removeFreind:(NSString*)loginId requestArr:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block;

- (void)inviteGroupUser:(NSString*)loginIds rlGroupId:(NSString*)rlGroupId requestArr:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block;

//群主邀请好友加群(已完成)
//访问地址:/action/inviteGroupUser

/*
 6 密码修改(已完成)
 访问地址:   /action/pwdModify (需要登陆后才可以进行操作) TLModifyPasswordRequestDTO
 请求参数
 
13,已发表攻略,路书，游记列表查询      tripList        TLTripListRequest TLTripListResponse TLTripListResult
 14,我的攻略，路书，游记列表查询      myTripList
 15,攻略，路书（主题），游记录入      addTrip         TLAddTripRequest    TLAddTripResponse   TLAddTripResult
 16,路书节点录入                   addWayBookNode     TLAddBookNodeRequest    TLAddBookNodeResponse TLAddBookNodeResult
 17,游记，攻略详情                  tripDetail     TLTripDetailRequest TLTripDetailResponse    TLTripDetailResult
 18,路书详情                       waybookDetail    TLWayBookDetailRequest TLWaybookDetailResponse TLWaybookDetailResult
 19,攻略，路书，游记评论查询          commentList   TLCommentListRequest    TLCommentListResponse   TLCommentListResult
 20,攻略，路书，游记评论             comment  TLCommentRequest TLCommontResponse TLCommentResult
 
 
 21,获取当前游记，攻略，路书，活动是否置顶（注：需要在发表前调用）action/isTop  TLIsTopRequestDTO  TLIsTopResponseDTO TLIsTopResultDTO
 22,码表获取 action/commonCode  TLCommonCodeRequestDTO TLCommonCodeResponseDTO TLCommonCodeResultDTO
 23,活动录入 action/activitySave  TLActivitySaveRequestDTO TLActivitySaveResponseDTO TLActivitySaveResultDTO
 24,活动列表 action/activityList    TLActivityListRequestDTO TLActivityListResponseDTO TLActivityListResultDTO
 25,活动详情 action/activityDetail TLActivityDetailRequestDTO TLActivityDetailResponseDTO TLActivityDetailResultDTO
 26,报名活动(注：报名把人和活动关联起来     短信通知活动发起人      “短信模板再定”) action/activityParticipate TLActivityParticipateRequestDTO TLActivityParticipateResponseDTO TLActivityParticipateResultDTO
 27,新车列表 action/carList TLCarListRequestDTO TLCartListResponseDTO TLCarListResultDTO 
 28,
 
 
 
 20,收藏action/saveCollect TLSaveCollectRequestDTO TLSaveCollectResponseDTO TLSsaveCollectResultDTO
 

 
 29新车列表（已完成）
 访问地址:/action/listCar TLListCarRequestDTO TLListCartResponseDTO TLListCarResultDTO
 
 30新车详情（已完成）
 访问地址:/action/carDetail TLCarDetailRequestDTO TLCarDetailResponseDTO TLCarDEtailResultDTO
 
 31车评列表（已完成）
 访问地址:/action/listCarEvaluation TLListCarEvalutionRequestDTO TLListCarEvelutionResponseDTO TLListCartEvelutionResultDTO
 
 32车评详情（已完成）
 访问地址:/action/carEvalDetail TLCarEvalDetailRequestDTO TLCarEValDetailResponseDTo TLCarEvalDetailResultDTO
 
 33汽车租赁列表（已完成）
 访问地址:/action/listCarRent TLListCarRectRequestDTO TLListCarRectResponseDTO TLListCarRectResultDTO
 
 34，汽车租赁录入（已完成）
 访问地址:/action/saveCarRent TLSaveCarRectRequestDTO TLSaveCarResponseDTO TLSaveCarResultDTO
 
 35汽车租赁查看（已完成）
 访问地址:/action/viewCarRent TLViewCarRentRequestDTO TLViewCarRectResponseDTO TLViewCarRectResultDTO
 

 
 36汽车服务录入（已完成）
 访问地址:/action/saveCarService TLSaveCarServiceRequest TLSaveCarServiceResponse TLSaveCarServiceResult
 
 37汽车服务列表（已完成）
 访问地址:/action/listCarService TLListCarServiceRequest TLListCarServiceResponse TLListCarServiceResult
 
 38,汽车服务查看（已完成）
 访问地址:/action/viewCarService TLCarServiceDetailRequest TLCarServiceDetailResponse TLCarServiceResult
 
 39汽车服务评分（已完成）
 访问地址:/action/makeScore TLCarServiceMackScoreRequest TLCarServiceMackScoreResponse TLCarServiceMackScoreResult
 
 
 
40 二手商品录入
 访问地址:/action/saveSecondGoods TLSaveSecondGoodsRequest TLSaveSecondGoodsResponse TLSaveSecondGoodsResult
 
 41 二手物品列表
 访问地址:/action/listSecondGoods TLListSecondGoodsRequest TLListSecondGoodsResponse TLListSecondGoodsResult
 
 42 二手宝贝查看
 访问地址:/action/viewSecondGoods TLSecondGoodsDetailRequest TLSecondGoodsDetailResponse TLSecondGoodsResult
 
 
 43，商家列表（已完成）
 访问地址:/action/listMerchant TLListMerchantRequestDTO TLListMerchantResponseDTO TLListMerchantResultDTO
 
 44，商家查看（已完成）
 访问地址:/action/viewMerchant TLListMerchantDetailRequestDTO TLListMerchantDetailResponseDTO TLListMerchantDetailResultDTO
 
 45，商户服务评分（已完成）
 访问地址:/action/makeMerchantScore
 
 
 46发送SOS救援接口(已完成)
 访问地址:/action/makeSOS   TLEmergencyResponseDTO
 
 
 47,个人资料修改(已完成)
 访问地址:/action/userEdit TLUserEditRequestDTO
 
 
 48,个人资料查看(已完成)
 访问地址:/action/userView TLUserViewRequestDTO TLUserViewResponseDTO TLUserViewResultDTO
 
 ----
 50,个人资料认证接口(已完成)
 访问地址:/action/authority TLAuthorityRequestDTO
 
 
 51，申诉接口(已完成)
 访问地址:/action/saveAppeal TLAppealRequestDTO  
 
 
 -----
 52,开通会员(已完成)
 访问地址:/action/openVip TLOpenVipRequestDTO TLOpenVipResponseDTO TLOpenVipResultDTO
 
 53,购买途乐币(已完成)
 访问地址:/action/buyTLB TLBuyTLBRequestDTO TLBuyTLBResponseDTO TLBuyTLBResultDTO
 
 54,增加成长值(已完成)(注：每天首次打开App的时候调用)
 访问地址:/action/addGrow TLAddGrowRequestDTO TLAddGrowResponseDTO TLAddGrowResultDTO
 
 55,新闻列表(已完成)
 访问地址:/action/listNews  TLNewsListRequestDTO TLNewsListResponseDTO TLNewsListResultDTO TLNewsDataDTO
 
 56,我的好友列表(已完成)
 访问地址:/action/myFriendList TLMyFriendListRequestDTO TLMyFriendsListResponseDTO TLMyFriendsListResultDTO 
 
 57,添加好友(已完成)
 访问地址:/action/addFriendApply  TLAddFriendApplyRequestDTO TLAddFriendApplyResponseDTO TLAddFriendApplayResultDTO
 
 58,添加好友确认(已完成)
 访问地址:/action/confirmAddFriend TLComfirmAddFrinedRequestDTO TLComfirmAddFriendResponseDTO
 
 
 59，我加入的组织/全部组织(已完成)
 访问地址:/action/listOrganization TLListOrgRequestDTO TLListOrgResponseDTO TLListOrgResultDTO TLOrgDataDTO
 
 60，组织详情(已完成)
 访问地址:/action/viewOrganization TLViewOrgRequestDTO TLViewOrgResponseDTO TLViewOrgResultDTO
 
 61，加入组织/退出组织(已完成)
 访问地址:/action/operateOrganization TLOperOrgRequestDTO
 
 
 62，我加入的群组
 访问地址:/action/listGroup TLListGroupRequestDTO TLListGroupResponseDTO TLListGroupResultDTO TLGroupDataDTO
 
 63，发送小喇叭消息
 访问地址:/action/sendOrgMessage TLSendOrgMessageRequestDTO
 
 ---
 
 64，群组加入申请/群组加入群组退出
 访问地址:/action/groupJoinApply TLGroupJoinApplyRequestDTO
 
 65，创建群组(已完成)
 访问地址:/action/saveGroup TLSaveGroupRequestDTO TLSaveGroupResponseDTO TLSaveGroupResultDTO
 
 66，群组详情(已完成)
 访问地址:/action/viewGroup TLViewGroupRequestDTO TLViewGroupResponseDTO TLViewGroupResultDTO
 
 组织消息列表(已完成)
 
 组织消息列表(已完成)
 访问地址:/action/listOrgMessage TLListOrgMesssageRequestDTO TLListOrgMessageResponseDTO TLListOrgMessageResultDTO TLOrgMessageDTO
 请求参数
 

 
 58，修改好友备注(已完成)
 访问地址:/action/reNameFriend TLRenameFriendRequestDTO 
 
 
 
 拉黑(已完成)
 访问地址:/action/reportBlack TLReportBlackRequestDTO TLReportBlackResponseDTO TLReportBlackResultDTO
 
 
 添加商户（已完成）
 访问地址:/action/saveMerchant TLSaveMarchantRequestDTO  TLSaveMarchantResponseDTO TLSaveMarchantResultDTO
 
 
 
 商户纠错(已完成)
 访问地址:/action/merchantError TLMerchantErrorRequestDTO TLMerchantErrorResponseDTO TLMerchantResultDTO
 请求参数
 
 消息列表(已完成)
 访问地址:/action/sysMessageList TLSysMessageListRequestDTO TLSysMessageListResponseDTO TLSysMEssageListResultDTO TLSysMessageDTO
 
 */

/**
 *  本地保存保存聊天记录
 *
 *  @param info
 */
-(void)saveUserChatInfo:(NSString *)info;
/**
 *  上传聊天记录
 */
-(void)uploadUserChatInfo;



/*
 *IOS内购充值接口(已完成) /action/tlbCharge  TLTlbChargeRequestDTO TLTlbChanrgeResponseDTO TLTlbChargeResultDTO
 */
- (void)tlbCharge:(TLTlbChargeRequestDTO*)request requestArr:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block;


@end
