//
//  UpdateInfoDTO.h
//  TL
//
//  Created by Rainbow on 3/8/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "JSONModel.h"

@interface UpdateInfoDTO : JSONModel
@property (nonatomic, copy) NSString *update;           //true false
@property (nonatomic, copy) NSString *updateNote;       //1、本次更新修正了若干bug     。|2、新增功能语音聊天模块 "|"分割
@property (nonatomic, copy) NSString *updateVersion;    //1.1
@property (nonatomic, copy) NSString *appURL;           //ios app 更行地址

@end
