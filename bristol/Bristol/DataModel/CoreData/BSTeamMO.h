#import "_BSTeamMO.h"
#import "ZPHttpRequestMappingProtocol.h"
#import "ZPHttpResponseMappingProtocol.h"
#import "ZPRandomInstanceForTestProtocol.h"

@interface BSTeamMO : _BSTeamMO <ZPHttpRequestMappingProtocol, ZPHttpResponseMappingProtocol, ZPRandomInstanceForTestProtocol> {}

@property (nonatomic, strong, readonly) NSArray *sportsSortedByAlphabet;
@property (nonatomic, strong, readonly) NSArray *membersSortedByAlphabet;
@property (nonatomic, strong, readonly) NSArray *followersSortedByAlphabet;

+ (RKMapping *)responseMappingWithRecentHighlights;
+ (RKMapping *)responseMappingWithUserTeams;

@property (nonatomic, strong) NSMutableSet *pendingUsers;
@property (nonatomic, strong) NSMutableSet *pendingEmails;
@end
