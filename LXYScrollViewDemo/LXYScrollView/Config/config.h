//
//  config.h
//  LXYScrollViewDemo
//
//  Created by 刘学阳 on 2017/9/15.
//  Copyright © 2017年 刘学阳. All rights reserved.
//

#ifndef config_h
#define config_h
#import "NSArray+Extension.h"

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self
#define dispatch_global_async_safe(block)\
dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);\

#define dispatch_main_async_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}


#endif /* config_h */
