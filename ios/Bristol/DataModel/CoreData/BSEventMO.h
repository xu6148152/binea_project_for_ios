#import "_BSEventMO.h"
#import "ZPHttpRequestMappingProtocol.h"
#import "ZPHttpResponseMappingProtocol.h"
#import "ZPRandomInstanceForTestProtocol.h"

@interface BSEventMO : _BSEventMO <ZPHttpRequestMappingProtocol, ZPHttpResponseMappingProtocol, ZPRandomInstanceForTestProtocol> {}

@property (nonatomic, strong, readonly) NSArray *recent_followersSortedByAlphabet;
@property (nonatomic, strong, readonly) NSArray *followersSortedByAlphabet;

- (CLLocationCoordinate2D)coordinate;

+ (RKMapping *)responseMappingWithRecentHighlights;
+ (RKMapping *)responseMappingWithUserEvents;

@end
