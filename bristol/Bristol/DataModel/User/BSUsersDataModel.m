//
//  BSUsersDataModel.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/12/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSUsersDataModel.h"
#import "BSUserMO.h"
#import "BSHighlightMO.h"

@implementation BSUsersDataModel

+ (NSString *)fromKeyPath {
    return @"users";
}

+ (RKMapping *)responseMapping {
	RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];

	[mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:[self.class fromKeyPath] toKeyPath:@"users" withMapping:[BSUserMO responseMapping]]];

	return mapping;
}

@end


@implementation BSMembersDataModel

+ (NSString *)fromKeyPath {
    return @"members";
}

+ (RKMapping *)responseMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
    
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:[self.class fromKeyPath] toKeyPath:@"users" withMapping:[BSUserMO responseMappingWithRecentHighlights]]];
    
    return mapping;
}

@end


@implementation BSFollowersDataModel

+ (NSString *)fromKeyPath {
    return @"followers";
}

@end


@implementation BSRecentFollowersDataModel

+ (NSString *)fromKeyPath {
    return @"recent_followers";
}

@end

@implementation BSSignUpDataModel

+ (NSString *)fromKeyPath {
    return @"followed_users";
}

+ (RKMapping *)responseMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
    
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"user" toKeyPath:@"user" withMapping:[BSUserMO responseMapping]]];
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:[self.class fromKeyPath] toKeyPath:@"followed_users" withMapping:[BSUserMO responseMapping]]];

    return mapping;
}

@end

@implementation BSSetUserNameDataModel

+ (NSString *)fromKeyPath {
    return @"followed_users";
}

+ (RKMapping *)responseMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
    
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:[self.class fromKeyPath] toKeyPath:@"followed_users" withMapping:[BSUserMO responseMapping]]];
    
    return mapping;
}

@end

@implementation BSCompleteUserInfoModel

+ (NSString *)fromKeyPath {
    return @"followed_users";
}

+ (RKMapping *)responseMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
    
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:[self.class fromKeyPath] toKeyPath:@"followed_users" withMapping:[BSUserMO responseMapping]]];
    
    return mapping;
}

@end

@implementation BSCheckUserEmailModel

+ (RKMapping *)responseMapping {

    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
    [mapping addAttributeMappingsFromDictionary:@{
                                                  @"user_exists":@"user_exists",
                                                  @"bristol_logged_in":@"bristol_logged_in",
                                                  @"zepp_facebook_user":@"zepp_facebook_user"
                                                  }];
    return mapping;
}

@end

@implementation BSUsersToFollowModel

+ (RKMapping *)responseMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
    
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:[self.class fromKeyPath] toKeyPath:@"users" withMapping:[BSUserMO responseMappingWithRecentHighlights]]];
    
    return mapping;
}

@end
