#import "BSCommentMO.h"
#import "BSUserMO.h"

@interface BSCommentMO ()

@end

@implementation BSCommentMO

+ (RKObjectMapping *)requestMapping {
	RKObjectMapping *mapping = [RKObjectMapping requestMapping];

	return mapping;
}

+ (RKMapping *)responseMapping {
	RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:@"Comment" inManagedObjectStore:[RKManagedObjectStore defaultStore]];

	[mapping addAttributeMappingsFromDictionary:@{
	     @"id":@"identifier",
	     @"content":@"content",
         @"created_at":@"created_at",
	 }];

	[mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"user" toKeyPath:@"user" withMapping:[BSUserMO responseMapping]]];

	mapping.identificationAttributes = @[@"identifier"];

	return mapping;
}

- (void)randomPropertiesForTest {
    self.content = [NSString randomStringWithLength:[NSNumber randomUIntegerFrom:10 to:100]];
}

+ (instancetype)randomInstanceForTest {
    BSCommentMO *mo = [BSCommentMO createEntity];
    [mo randomPropertiesForTest];

	return mo;
}

@end
