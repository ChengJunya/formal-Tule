//
//  TLOrgMessageBody.h
//  TL
//
//  Created by YONGFU on 5/21/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "ECMessageBody.h"

@interface TLOrgMessageBody : ECMessageBody
/**
 @brief text 文本消息体的内部文本对象的文本
 */
@property (nonatomic, strong) NSString *text;

/**
 @brief serverTime 时间
 */
@property (nonatomic, strong) NSString *serverTime;

/**
 @brief 创建文本实例
 @param text 文本消息
 */
-(instancetype)initWithText:(NSString*)text;
@end
