//
//  ZPLog.h
//  ZPVideo
//
//  Created by Guichao Huang (Gary) on 10/15/14.
//  Copyright (c) 2014 Zepp US Inc. All rights reserved.
//


#import "lcl.h"
#import "LoggerClient.h"

#define ZPLogComponent lcl_cAPP

/**
 The logging macros. These macros will log to the currently active logging component
 at the log level identified in the name of the macro.
 
 For example, in the `RKMappingOperation` class we would redefine the RKLogComponent:
 
 #undef RKLogComponent
 #define RKLogComponent RKlcl_cRestKitObjectMapping
 
 The RKlcl_c prefix is the LibComponentLogging data structure identifying the logging component
 we want to target within this portion of the codebase. See lcl_config_component_RK.h for reference.
 
 Having defined the logging component, invoking the logger via:
 
 RKLogInfo(@"This is my log message!");
 
 Would result in a log message similar to:
 
 I RestKit.ObjectMapping:RKLog.h:42 This is my log message!
 
 The message will only be logged if the log level for the active component is equal to or higher
 than the level the message was logged at (in this case, Info).
 */
#define ZPLogCritical(...)                                                              \
lcl_log(ZPLogComponent, lcl_vCritical, @"" __VA_ARGS__)

#define ZPLogError(...)                                                                 \
lcl_log(ZPLogComponent, lcl_vError, @"" __VA_ARGS__)

#define ZPLogWarning(...)                                                               \
lcl_log(ZPLogComponent, lcl_vWarning, @"" __VA_ARGS__)

#define ZPLogInfo(...)                                                                  \
lcl_log(ZPLogComponent, lcl_vInfo, @"" __VA_ARGS__)

#define ZPLogDebug(...)                                                                 \
lcl_log(ZPLogComponent, lcl_vDebug, @"" __VA_ARGS__)

#define ZPLogTrace(...)                                                                 \
lcl_log(ZPLogComponent, lcl_vTrace, @"" __VA_ARGS__)

/**
 Log Level Aliases
 
 These aliases simply map the log levels defined within LibComponentLogger to something more friendly
 */
#define ZPLogLevelOff       lcl_vOff
#define ZPLogLevelCritical  lcl_vCritical
#define ZPLogLevelError     lcl_vError
#define ZPLogLevelWarning   lcl_vWarning
#define ZPLogLevelInfo      lcl_vInfo
#define ZPLogLevelDebug     lcl_vDebug
#define ZPLogLevelTrace     lcl_vTrace

/**
 Alias the LibComponentLogger logging configuration method. Also ensures logging
 is initialized for the framework.
 
 Expects the name of the component and a log level.
 
 Examples:
 
 // Log debugging messages from the Foundation component
 ZPLogConfigureByName("Foundation", ZPLogLevelDebug);
 
 // Log only critical messages from the Video component
 ZPLogConfigureByName("Video", ZPLogLevelCritical);
 */
#define ZPLogConfigureByName(name, level)                                               \
lcl_configure_by_name(name, level);

#define ZPLogConfigureByComponent(component, level)                                     \
lcl_configure_by_component(component, level);

#define ZPLogSetBufferFileWithNSLogger(fileName)                                        \
LoggerSetBufferFile(NULL, (__bridge CFStringRef)[NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.rawnsloggerdata", fileName]]);

#define ZPLogImageWithNSLogger(image, level)                                            \
LogImageData(@"image", level, image.size.width, image.size.height, UIImagePNGRepresentation(image));

#define ZPLogDataWithNSLogger(data, level)                                             \
LogData(@"data", level, data);
