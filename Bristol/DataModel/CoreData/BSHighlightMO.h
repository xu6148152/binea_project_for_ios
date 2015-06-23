#import "_BSHighlightMO.h"
#import "ZPHttpRequestMappingProtocol.h"
#import "ZPHttpResponseMappingProtocol.h"
#import "ZPRandomInstanceForTestProtocol.h"

@interface BSHighlightMO : _BSHighlightMO <ZPHttpRequestMappingProtocol, ZPHttpResponseMappingProtocol, ZPRandomInstanceForTestProtocol> {}

@property (nonatomic, strong, readonly) NSArray *commentsSortedByCreate_AtAsc;
@property (nonatomic, assign) BOOL showSeeAllCommentsCell;

@end
