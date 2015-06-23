//
//  AVAssetExportSession+Progress.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 2/10/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "AVAssetExportSession+Progress.h"
#import "objc/runtime.h"

@implementation AVAssetExportSession (Progress)

static id ProgressHandlerKey;

- (ZPFloatBlock)progressHandler {
	return objc_getAssociatedObject(self, &ProgressHandlerKey);
}

- (void)setProgressHandler:(ZPFloatBlock)progressHandler {
	objc_setAssociatedObject(self, &ProgressHandlerKey, progressHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)exportAsynchronouslyWithProgress:(ZPFloatBlock)progressHandler completionHandler:(ZPVoidBlock)completionHandler {
	if (progressHandler) {
		self.progressHandler = progressHandler;
		[self _monitorExportProgress];
	}
	[self exportAsynchronouslyWithCompletionHandler:completionHandler];
}

- (void)_monitorExportProgress {
	double delayInSeconds = 0.1;
	dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
	__weak typeof(self) weakSelf = self;

	dispatch_after(popTime, dispatch_get_main_queue(), ^{
		AVAssetExportSessionStatus status = weakSelf.status;
		switch (status) {
			case AVAssetExportSessionStatusExporting:
				{
				    ZPInvokeBlock(self.progressHandler, weakSelf.progress);
				    [weakSelf _monitorExportProgress];
				    break;
				}

			case AVAssetExportSessionStatusFailed:
				{
				    ZPLogDebug(@"Export Failed");
				    break;
				}

			case AVAssetExportSessionStatusUnknown:
			case AVAssetExportSessionStatusWaiting:
				{
				    [weakSelf _monitorExportProgress];
				    break;
				}

			default:
				break;
		}
	});
}

@end
