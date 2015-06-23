//
//  SDAVAssetExportSession+Progress.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 6/22/15.
//  Copyright © 2015 Zepp US Inc. All rights reserved.
//

#import "SDAVAssetExportSession.h"

@interface SDAVAssetExportSession (Progress)

- (void)exportAsynchronouslyWithProgress:(ZPFloatBlock)progressHandler completionHandler:(ZPVoidBlock)completionHandler;

@end
