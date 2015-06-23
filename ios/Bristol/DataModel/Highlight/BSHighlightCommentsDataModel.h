//
//  BSHighlightCommentsDataModel.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/13/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "ZPBaseDataModel.h"

@interface BSHighlightCommentsDataModel : ZPBaseDataModel

@property (nonatomic, strong) NSArray *comments;

+ (RKMapping *)addCommentResponseMapping;

@end
