//
//  NetDownloader.h
//  alijk
//
//  Created by easy on 10/19/14.
//  Copyright (c) 2014 zhongxin. All rights reserved.
//

#import "AFURLSessionManager.h"
#import "NetDownloadOperation.h"

@interface NetDownloader : AFURLSessionManager

+ (NetDownloader*)sharedManager;

- (void)download:(NSURL *)downloadURL
       toSaveURL:(NSURL *)saveURL
        progress:(NSProgress * __autoreleasing *)progress
completionHandler:(DownloadCompletionBlock)completionHandler;

@end
