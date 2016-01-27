//
//  ZXSingletonMacro.h
//  alijk
//
//  Created by easy on 15/1/21.
//  Copyright (c) 2015年 zhongxin. All rights reserved.
//

#ifndef alijk_ZXSingletonMacro_h
#define alijk_ZXSingletonMacro_h

#import <objc/runtime.h>

#define ZX_DECLARE_SINGLETON_IMPL(classname, sharedInstance) \
+ (classname*)sharedInstance;

#define ZX_IMPLEMENT_SINGLETON_IMPL(classname, sharedInstance) \
\
+(classname*)sharedInstance \
{ \
static classname *_sharedInstance = nil; \
\
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_sharedInstance = [[classname alloc] init]; \
}); \
\
return _sharedInstance; \
}


#define ZX_DECLARE_SINGLETON(classname) ZX_DECLARE_SINGLETON_IMPL(classname, shared##classname)
#define ZX_IMPLEMENT_SINGLETON(classname) ZX_IMPLEMENT_SINGLETON_IMPL(classname, shared##classname)
#define ZX_CALL_SINGLETON(classname) ([classname shared##classname])

#endif
