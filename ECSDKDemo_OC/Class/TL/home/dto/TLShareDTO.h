//
//  TLShareDTO.h
//  TL
//
//  Created by Rainbow on 3/22/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TLShareDTO : NSObject
@property(nonatomic,strong) NSString *shareUrl;
@property(nonatomic,strong) NSString *shareDesc;
@property(nonatomic,strong) NSString *shareTitle;
@property(nonatomic,strong) NSString *shareImageUrl;
@property(nonatomic,strong) NSString *patAwardId;

@end


/*
 _share.shareUrl = @"http://www.baidu.com";//obj.shareUrl;
 _share.shareDesc = @"途乐，乐在途中！";//obj.shareDesc;
 _share.shareTitle = @"途乐";//obj.title;
 _share.shareImageUrl = @"http://file01.16sucai.com/d/file/2013/0720/20130720022635795.jpg";//obj.imageUrl;
 _share.patAwardId = @"wxf51c8154f251195f";//obj.patAwardId;


*/