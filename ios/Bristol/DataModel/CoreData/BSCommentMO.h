#import "_BSCommentMO.h"
#import "ZPHttpRequestMappingProtocol.h"
#import "ZPHttpResponseMappingProtocol.h"
#import "ZPRandomInstanceForTestProtocol.h"

@interface BSCommentMO : _BSCommentMO <ZPHttpRequestMappingProtocol, ZPHttpResponseMappingProtocol, ZPRandomInstanceForTestProtocol> {}

@end
