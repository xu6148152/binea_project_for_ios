//
//  BSCustomHttpRequest.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/8/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSCustomHttpRequest.h"
#import "BSUIGlobal.h"

@implementation BSCustomHttpRequest

- (id)init {
	self = [super init];
	if (self) {
		self.statusSuccessValue = 0;
	}
	return self;
}


+ (RKMapping *)responseMappingCustomized {
	RKObjectMapping *mapping = (RKObjectMapping *)[BSHttpResponseDataModel responseMapping];
	RKMapping *dataMapping = [self.class responseMapping];
	if (dataMapping) {
		RKRelationshipMapping *relationshipMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:[self.class responsePath]
																								 toKeyPath:@"dataModel"
																							   withMapping:dataMapping];
		[mapping addPropertyMapping:relationshipMapping];
	}
	return mapping;
}

- (void)postRequestWithSucceedBlock:(BSHttpRequestCompletedBlock)succeedBlock failedBlock:(BSHttpRequestCompletedBlock)failedBlock {
	[super postRequestCustomizedWithSucceedBlock:succeedBlock failedBlock:^(id<ZPHttpResponseMappingProtocol> result){
		BSHttpResponseDataModel *dm;
		if ([result isKindOfClass:[BSHttpResponseDataModel class]]) {
			dm = (BSHttpResponseDataModel *)result;
		} else {
			dm = [BSHttpResponseDataModel modelWithError:((ZPBaseDataModel *)result).error];
		}
		[BSUIGlobal showError:dm.error];
		ZPInvokeBlock(failedBlock, dm);
		if (dm.code == 100 && dm.apiCase == 902) {
			[[NSNotificationCenter defaultCenter] postNotificationName:kUserDidLogoutNotification object:nil];
		}
	}];
}

@end
