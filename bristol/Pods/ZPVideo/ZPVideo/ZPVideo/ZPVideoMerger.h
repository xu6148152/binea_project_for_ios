//
//  ZPVideoMerger.h
//  ZEPP
//
//  Created by Guichao Huang (Gary) on 10/3/14.
//
//

#import <Foundation/Foundation.h>

#import "ZPVideoShared.h"

typedef void (^ZPVideoMergerCompletionCallback) (NSError *error);
typedef void (^ZPVideoMergerProgressCallback) (float progress);

@interface ZPVideoMerger : NSObject

+ (void)mergeVideoWithUrls:(NSArray *)aryUrls outputURL:(NSURL *)outputURL presetName:(NSString *)presetName progressCallback:(ZPVideoMergerProgressCallback)progressCallback completionCallback:(ZPVideoMergerCompletionCallback)completionCallback;

+ (void)mergeVideoWithUrls:(NSArray *)aryUrls outputURL:(NSURL *)outputURL presetName:(NSString *)presetName constrainDuration:(float)constrainDuration shiftDuration:(float)shiftDuration isForward:(BOOL)isForward progressCallback:(ZPVideoMergerProgressCallback)progressCallback completionCallback:(ZPVideoMergerCompletionCallback)completionCallback;

@end
