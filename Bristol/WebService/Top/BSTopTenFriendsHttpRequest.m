//
//  BSTopFriendsHttpRequest.m
//  Bristol
//
//  Created by Bo on 1/30/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSTopTenFriendsHttpRequest.h"
#import "BSTopDataModel.h"
#import "BSHighlightMO.h"

@implementation BSTopTenFriendsHttpRequest

#pragma mark - overwrite -
+ (NSString *)requestPath {
    return @"top/friends";
}

@end
