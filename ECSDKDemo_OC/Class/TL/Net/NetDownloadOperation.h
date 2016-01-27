//
//  NetDownloadOperation.h
//  alijk
//
//  Created by easy on 10/19/14.
//  Copyright (c) 2014 zhongxin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^DownloadCompletionBlock)(NSURL *filePath, NSError *error);

@interface NetDownloadOperation : NSOperation

- (id)initWithDownloadURL:(NSURL *)downloadURL
                toSaveURL:(NSURL *)saveURL
           sessionManager:(AFURLSessionManager *)manager
        completionHandler:(DownloadCompletionBlock)completionHandle;

@end
