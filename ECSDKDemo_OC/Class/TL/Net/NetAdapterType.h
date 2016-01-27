//
//  NetAdapterType.h
//  alijk
//
//  Created by easy on 14/7/24.
//  Copyright (c) 2014年 zhongxin. All rights reserved.
//

#ifndef Alijk_NetAdapterType_h
#define Alijk_NetAdapterType_h

/* 网络接口类型列表
 */
typedef enum {
    NetAdapter_GetUpdateVersion = 0,                    // 获取最新应用版本0
    NetAdapter_User_ForgotPassword_GetUserKey,      // 忘记密码，获取验证码1
    NetAdapter_User_ForgotPassword_Certify,         // 忘记密码，验证用户和验证码2
    NetAdapter_User_Register_Provice_Getter,        //省份获取3
    NetAdapter_User_Register_City_Getter,           //地市获取4
    NetAdapter_User_Register_District_Getter,       //区县5
    NetAdapter_User_Register,                       // 用户注册6
    NetAdapter_User_Login,                          // 用户登录7
    //
    NetAdapter_Home_Image_List,                     // 首页图片8
    NetAdapter_Logout,                              //用户注销9
    NetAdapter_TripList,                            //已发表攻略,路书，游记列表查询
    NetAdapter_AddTrip,                             //攻略，路书（主题），游记录入
    NetAdapter_AddBookNode,                         //路书节点录入 
    NetAdapter_TripDetail,                          //游记，攻略详情
    NetAdapter_Waybook,                             //路书详情 
    NetAdapter_CommentList,                         //攻略，路书，游记评论查询 
    NetAdapter_Commont,                             //攻略，路书，游记评论
    NetAdapter_MyTripList,                          //我的攻略，路书，游记列表查询
    NetAdapter_IsTop,                               //获取当前游记，攻略，路书，活动是否置顶（注：需要在发表前调用）
    NetAdapter_CommonCode,                          //码表获取 
    NetAdapter_ActivitySave,                        //活动录入
    NetAdapter_ActivityList,                        //活动列表
    NetAdapter_ActivityDetail,                      //活动详情
    NetAdapter_ActivityParticipate,                 //报名活动
    NetAdapter_CartList,                            //新车列表
    
    NetAdapter_SaveCollect,                          //收藏
    
    
    
    //车辆详情
    NetAdapter_ListCart,                          //新车列表
    NetAdapter_CartDetail,                          //新车详情
    NetAdapter_ListCarEvalution,                        //车评列表
    NetAdapter_CarEvalDetail,                          //车评详情
    NetAdapter_ListCarRect,                          //租赁列表
    NetAdapter_SaveCarRent,                          //保存车辆信息
    NetAdapter_ViewCarRent,                          //租赁详情
    NetAdapter_SaveCarService,                          //保存
    NetAdapter_ListCarService,                          //列表
    NetAdapter_ViewCarService,                          //详情
    NetAdapter_MakeScore,                          //评分
    
    NetAdapter_SaveSecondGoods,                          //保存二手宝贝
    NetAdapter_ListSecondGoods,                          //获取二手列表
    NetAdapter_ViewSecondGoods,                          //二手详情
    NetAdapter_ListMerchant,                          //商家列表
    NetAdapter_ViewMerchant,                          //商家详情
    NetAdapter_MakeMerchantScore,                          //商家评分
    NetAdapter_MakeSOS,                                            //SOS呼叫
    NetAdapter_UserEdit,                                           //修改个人资料
    NetAdapter_UserView,                                           //查询个人资料
    NetAdapter_SaveAppeal,                                   //申诉
    
    
    NetAdapter_Authority,                                   //用户认证
    NetAdapter_OpenVip,                                   //开通VIP、
    NetAdapter_BuyTLB,                                   //购买tlb
    NetAdapter_AddGrow,                                   //添加成长值
    NetAdapter_ListNews,                                   //新闻列表
    NetAdapter_MyFriendList,                                   //好友列表
    NetAdapter_AddFriendApply,                                   //添加好友
    NetAdapter_ConfirmAddFriend,                                   //添加好友确认
    
        NetAdapter_ListOrganization,                                   //组织列表
        NetAdapter_ViewOrganization,                                   //组织详情
        NetAdapter_OperateOrganization,                                   //操作组织
        NetAdapter_ListGroup,                                   //群组列表
        NetAdapter_SendOrgMessage,                                   //发送广播
    
    NetAdapter_GroupJoinApply,                                   //加入群组
    NetAdapter_SaveGroup,                                   //保存群组
    NetAdapter_ViewGroup,                                   //群组详情

    NetAdapter_ListOrgMessage,                              //消息列表
    NetAdapter_ReNameFriend,                                //修改好友备注
    NetAdapter_PwdModify,                                   //修改密码
    NetAdapter_RebindPhone,                                     ///
        NetAdapter_DoTop,                               //获取当前游记，攻略，路书，活动是否置顶（注：需要在发表前调用）
    NetAdapter_ReportBlack,                           //拉黑
    NetAdapter_SaveMerchant,                            //保存商家
    NetAdapter_MerchantError,                            //纠错
    NetAdapter_SysMessageList,                   //系统消息
        NetAdapter_InitImage ,               //等待的图片
    NetAdapter_UploadChatFile ,              //上传聊天记录
    NetAdapter_HiddenSetting, //设置隐藏
    NetAdapter_RemoveFriend,    //  删除好友
    NetAdapter_InviteGroupUser, //邀请好友
    NetAdapter_TlbCharge,       //购买tlb
    NetAdapter_PwdFind,        //找密码
}ENetAdapterType;

#endif
