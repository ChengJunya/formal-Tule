//
//  TLHomeHelper.m
//  TL
//
//  Created by Rainbow on 3/8/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "TLHomeHelper.h"
#import "TLHomeImageRequestDTO.h"
#import "TLHomeImageResponseDTO.h"

#import "TLHomeImageDTO.h"


@interface TLHomeHelper ()
@property (nonatomic,strong) NSArray<TLHomeImageDTO> *homeImageDataArray;

@end


@implementation TLHomeHelper

//单例实现
ZX_IMPLEMENT_SINGLETON(TLHomeHelper)



- (void)getHomeImageList:(NSString*)height width:(NSString*)width requestArr:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block{
    
    if (self.homeImageDataArray!=nil && self.homeImageDataArray.count>0) {
        block(self.homeImageDataArray, YES);
        return;
    }
    
    //请求数据对象
    TLHomeImageRequestDTO* request = [[TLHomeImageRequestDTO alloc] init];
    request.width = width;
    request.height = height;
    

    
    //返回请求标记tag
    NSNumber *requestTag = [GDataManager asyncRequestByType:NetAdapter_Home_Image_List andObject:request success:^(TLHomeImageResponseDTO* responseDTO) {
       
        
        if (block) {
            self.homeImageDataArray = responseDTO.result.data;
            block(self.homeImageDataArray , YES);
        }
    } failure:^(id responseDTO) {
        if (block) {
            block(responseDTO, NO);
        }
    }];
    [requestArr addObject:requestTag];

    
    
}

@end
