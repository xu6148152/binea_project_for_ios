//
//  BSTopTenHelpMeTopHttpRequest.h
//  Bristol
//
//  Created by Gary Wong on 5/6/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSCustomHttpRequest.h"

@interface BSTopTenHelpMeTopBaseHttpRequest : BSCustomHttpRequest

@property (nonatomic, assign) DataModelIdType highlight_id;
@property (nonatomic, assign) NSInteger current_rank;

@end



@interface BSTopTenHelpMeTopInFriendHttpRequest : BSTopTenHelpMeTopBaseHttpRequest

@end


@interface BSTopTenHelpMeTopInEventHttpRequest : BSTopTenHelpMeTopBaseHttpRequest

@property (nonatomic, assign) DataModelIdType event_id;

@end


@interface BSTopTenHelpMeTopInSportHttpRequest : BSTopTenHelpMeTopBaseHttpRequest

@property (nonatomic, assign) NSInteger sport_type;

@end
