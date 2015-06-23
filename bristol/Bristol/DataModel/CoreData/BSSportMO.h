#import "_BSSportMO.h"

@interface BSSportMO : _BSSportMO<ZPHttpResponseMappingProtocol> {}

@property(nonatomic, strong, readonly) NSString *nameLocalized;

+ (instancetype)sportOfIdentifier:(DataModelIdType)identifierValue;

@end
