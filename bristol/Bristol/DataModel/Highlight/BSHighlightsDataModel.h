//
//  BSHighlightsDataModel.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/13/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "ZPBaseDataModel.h"

@interface BSHighlightsDataModel : ZPBaseDataModel

@property (nonatomic, strong) NSArray *highlights;

+ (NSString *)fromKeyPath;

@end


@interface BSHighlightsUserKeyDataModel : BSHighlightsDataModel

@end

@interface BSRecentHighlightDataModel : BSHighlightsDataModel

@end
