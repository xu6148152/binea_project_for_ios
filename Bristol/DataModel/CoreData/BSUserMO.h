#import "_BSUserMO.h"
#import "ZPHttpRequestMappingProtocol.h"
#import "ZPHttpResponseMappingProtocol.h"
#import "ZPRandomInstanceForTestProtocol.h"

@interface BSUserMO : _BSUserMO <ZPHttpRequestMappingProtocol, ZPHttpResponseMappingProtocol, ZPRandomInstanceForTestProtocol> {}

@property (nonatomic, strong, readonly) NSArray *sportsSortedByAlphabet;
@property (nonatomic, strong) NSMutableSet *pendingUsers;

+ (RKMapping *)responseMappingWithRecentHighlights;
+ (RKMapping *)responseMappingWithUserProfile;

+ (instancetype)createEntityAndSetDefaultValues;

@end
