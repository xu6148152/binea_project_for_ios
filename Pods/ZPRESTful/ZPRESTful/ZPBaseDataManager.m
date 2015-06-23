//
//  ZPBaseDataManager.m
//  ZEPP
//
//  Created by Guichao Huang (Gary) on 1/6/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "ZPBaseDataManager.h"
#import "ZPFoundation.h"

#define MR_SHORTHAND
#import "CoreData+MagicalRecord.h"
#import "RestKit.h"

// Use a class extension to expose access to MagicalRecord's private setter methods
@interface NSManagedObjectContext ()
+ (void)MR_setRootSavingContext:(NSManagedObjectContext *)context;
+ (void)MR_setDefaultContext:(NSManagedObjectContext *)moc;
@end



@implementation ZPBaseDataManager

static ZPBaseDataManager *instance;

+ (void)initialize {
	Class class = self.class;
	if (class != ZPBaseDataManager.class) {
		static dispatch_once_t onceToken;
		dispatch_once(&onceToken, ^{
			instance = [[class alloc] init];
		});
	}
}

+ (instancetype)sharedInstance {
	return instance;
}

+ (NSString *)dbStorePath {
	return [RKApplicationDataDirectory() stringByAppendingPathComponent:@"data.db"];
}

+ (NSString *)dbSeedPath {
	return nil;
}

- (id)init {
	self = [super init];

	if (self) {
		NSManagedObjectModel *managedObjectModel = [self managedObjectModel];
		RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
		NSString *storePath = [[self class] dbStorePath];
		NSString *seedPath = [[self class] dbSeedPath];
		ZPLogDebug(@"data file path:%@", storePath);
		NSError *error = nil;
		if (![managedObjectStore addSQLitePersistentStoreAtPath:storePath fromSeedDatabaseAtPath:seedPath withConfiguration:nil options:nil error:&error]) {
			[[NSFileManager defaultManager] removeItemAtURL:[NSURL fileURLWithPath:storePath] error:nil];
			[managedObjectStore addSQLitePersistentStoreAtPath:storePath fromSeedDatabaseAtPath:seedPath withConfiguration:nil options:nil error:&error];
		}
		
		[managedObjectStore createManagedObjectContexts];

		// Configure MagicalRecord to use RestKit's Core Data stack
		[NSPersistentStoreCoordinator MR_setDefaultStoreCoordinator:managedObjectStore.persistentStoreCoordinator];
		[NSManagedObjectContext MR_setRootSavingContext:managedObjectStore.persistentStoreManagedObjectContext];
		[NSManagedObjectContext MR_setDefaultContext:managedObjectStore.mainQueueManagedObjectContext];

		RKObjectManager *_objectManager = [RKObjectManager managerWithBaseURL:[[ZPApiUrlManager sharedInstance] currentApiUrl]];
		_objectManager.requestSerializationMIMEType = RKMIMETypeJSON;
		_objectManager.managedObjectStore = managedObjectStore;
		[RKObjectManager setSharedManager:_objectManager];
		[self setHeaderForHTTPClient:_objectManager.HTTPClient];

		[self _addNotification];
	}

	return self;
}

- (void)setHeaderForHTTPClient:(AFHTTPClient *)HTTPClient {
	// overwrite to set up header
}

- (NSManagedObjectModel *)managedObjectModel {
	return [[NSManagedObjectModel mergedModelFromBundles:@[[NSBundle mainBundle]]] mutableCopy];
}

- (void)_apiUrlDidChanged {
	AFHTTPClient *HTTPClient = [AFHTTPClient clientWithBaseURL:[[ZPApiUrlManager sharedInstance] currentApiUrl]];
	[HTTPClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
	[self setHeaderForHTTPClient:HTTPClient];

	[[RKObjectManager sharedManager].HTTPClient cancelAllHTTPOperationsWithMethod:nil path:nil];
	[RKObjectManager sharedManager].HTTPClient = HTTPClient;
}

- (void)_addNotification {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_didEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_apiUrlDidChanged) name:ZPApiUrlDidChangedNotification object:nil];
}

- (void)_removeNotification {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)_didEnterBackground {
	[self save];
}

- (void)dealloc {
	[self _removeNotification];
}

- (void)save {
	// TODO: is this ok?
	[[NSManagedObjectContext rootSavingContext] saveToPersistentStoreAndWait];
	[[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
}

@end
