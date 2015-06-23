//
//  BSHighlightPostDataModel.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 2/4/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "ZPBaseDataModel.h"
#import "BSHighlightMO.h"
#import "BSHighlightVideoBufferDataModel.h"

@interface BSHighlightPostDataModel : ZPBaseDataModel

@property(nonatomic, strong) BSHighlightMO *highlight;
@property(nonatomic, strong) BSHighlightVideoBufferDataModel *highlightVideoBuffer;
@property(nonatomic, strong) NSString *share_url;

@end
