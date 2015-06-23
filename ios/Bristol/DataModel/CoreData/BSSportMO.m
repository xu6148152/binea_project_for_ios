#import "BSSportMO.h"
#import "NSManagedObject+MagicalFinders.h"

@interface BSSportMO ()

// Private interface goes here.

@end

@implementation BSSportMO

- (NSString *)nameLocalized {
	return ZPLocalizedString(self.nameKey);
}

+ (RKMapping *)responseMapping {
	RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:@"Sport" inManagedObjectStore:[RKManagedObjectStore defaultStore]];
	
	[mapping addAttributeMappingsFromDictionary:@{
												  @"id":@"identifier",
												  @"name":@"nameKey",
												 }];
	
	mapping.identificationAttributes = @[@"identifier"];
	
	return mapping;
}

+ (instancetype)sportOfIdentifier:(DataModelIdType)identifierValue {
	return [BSSportMO MR_findFirstByAttribute:@"identifier" withValue:@(identifierValue)];
}

@end
