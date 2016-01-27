//
//  ALiLog.h
//  NSLogTester
//
//  Created by Rainbow on 4/24/15.
//  Copyright (c) 2015 MST. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CocoaLumberjack.h"
#import "DDLegacyMacros.h"



NSString * VTPG_DDToStringFromTypeAndValue(const char * typeCode, void * value);

// WARNING: if NO_LOG_MACROS is #define-ed, than THE ARGUMENT WILL NOT BE EVALUATED
#ifndef NO_LOG_MACROS


#define ALiLog(_X_) do{\
    __typeof__(_X_) _Y_ = (_X_);\
    const char * _TYPE_CODE_ = @encode(__typeof__(_X_));\
    NSString *_STR_ = VTPG_DDToStringFromTypeAndValue(_TYPE_CODE_, &_Y_);\
    if(_STR_)\
        DDLogVerbose(@"%s = %@", #_X_, _STR_);\
    else\
        DDLogVerbose(@"Unknown _TYPE_CODE_: %s for expression %s in function %s, file %s, line %d", _TYPE_CODE_, #_X_, __func__, __FILE__, __LINE__);\
}while(0)


#define ALiLogError(_X_) do{\
    __typeof__(_X_) _Y_ = (_X_);\
    const char * _TYPE_CODE_ = @encode(__typeof__(_X_));\
    NSString *_STR_ = VTPG_DDToStringFromTypeAndValue(_TYPE_CODE_, &_Y_);\
    if(_STR_)\
        DDLogError(@"%s = %@ function %s, file %s, line %d", #_X_, _STR_,__func__, __FILE__, __LINE__);\
    else\
        DDLogError(@"Unknown _TYPE_CODE_: %s for expression %s in function %s, file %s, line %d", _TYPE_CODE_, #_X_, __func__, __FILE__, __LINE__);\
}while(0)


#define ALiLogWarn(_X_) do{\
    __typeof__(_X_) _Y_ = (_X_);\
    const char * _TYPE_CODE_ = @encode(__typeof__(_X_));\
    NSString *_STR_ = VTPG_DDToStringFromTypeAndValue(_TYPE_CODE_, &_Y_);\
    if(_STR_)\
        DDLogWarn(@"%s = %@", #_X_, _STR_);\
    else\
        DDLogWarn(@"Unknown _TYPE_CODE_: %s for expression %s in function %s, file %s, line %d", _TYPE_CODE_, #_X_, __func__, __FILE__, __LINE__);\
}while(0)

#define ALiLogInfo(_X_) do{\
    __typeof__(_X_) _Y_ = (_X_);\
    const char * _TYPE_CODE_ = @encode(__typeof__(_X_));\
    NSString *_STR_ = VTPG_DDToStringFromTypeAndValue(_TYPE_CODE_, &_Y_);\
    if(_STR_)\
        DDLogInfo(@"%s = %@", #_X_, _STR_);\
    else\
        DDLogInfo(@"Unknown _TYPE_CODE_: %s for expression %s in function %s, file %s, line %d", _TYPE_CODE_, #_X_, __func__, __FILE__, __LINE__);\
}while(0)

#define ALiLogDebug(_X_) do{\
    __typeof__(_X_) _Y_ = (_X_);\
    const char * _TYPE_CODE_ = @encode(__typeof__(_X_));\
    NSString *_STR_ = VTPG_DDToStringFromTypeAndValue(_TYPE_CODE_, &_Y_);\
    if(_STR_)\
        DDLogDebug(@"%s = %@", #_X_, _STR_);\
    else\
        DDLogDebug(@"Unknown _TYPE_CODE_: %s for expression %s in function %s, file %s, line %d", _TYPE_CODE_, #_X_, __func__, __FILE__, __LINE__);\
}while(0)

#define ALiLogVerbose(_X_) do{\
    __typeof__(_X_) _Y_ = (_X_);\
    const char * _TYPE_CODE_ = @encode(__typeof__(_X_));\
    NSString *_STR_ = VTPG_DDToStringFromTypeAndValue(_TYPE_CODE_, &_Y_);\
    if(_STR_)\
        DDLogVerbose(@"%s = %@", #_X_, _STR_);\
    else\
        DDLogVerbose(@"Unknown _TYPE_CODE_: %s for expression %s in function %s, file %s, line %d", _TYPE_CODE_, #_X_, __func__, __FILE__, __LINE__);\
}while(0)

#define LOG_NS(...) NSLog(__VA_ARGS__)
#define LOG_FUNCTION()	NSLog(@"%s", __func__)

#else /* NO_LOG_MACROS */

#define LOG_EXPR(_X_)
#define LOG_NS(...)
#define LOG_FUNCTION()
#endif /* NO_LOG_MACROS */






