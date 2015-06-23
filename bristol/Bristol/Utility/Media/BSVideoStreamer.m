//
//  BSVideoStreamer.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 5/11/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSVideoStreamer.h"
#import "AFNetworkActivityIndicatorManager.h"

#import <MobileCoreServices/MobileCoreServices.h>

@interface BSVideoStreamer() <NSURLConnectionDataDelegate, AVAssetResourceLoaderDelegate>
{
	BOOL isLoadingComplete;
	long long _expectedFileSize;
}
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSMutableData *videoData;
@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSHTTPURLResponse *response;
@property (nonatomic, strong) NSMutableArray *pendingRequests;

@property (nonatomic, copy) ZPFloatBlock progress;
@property (nonatomic, copy) ZPDataBlock success;
@property (nonatomic, copy) ZPErrorBlock faild;
@property (nonatomic, strong) BSVideoStreamer *strongRef;

@end

@implementation BSVideoStreamer

+ (AVURLAsset *)streamVideoForUrl:(NSURL *)url progress:(ZPFloatBlock)progress success:(ZPDataBlock)success faild:(ZPErrorBlock)faild {
	if (!url) {
		return nil;
	}
	
	BSVideoStreamer *videoStreamer = [BSVideoStreamer new];
	videoStreamer.url = url;
	videoStreamer.progress = progress;
	videoStreamer.success = success;
	videoStreamer.faild = faild;
	videoStreamer.strongRef = videoStreamer;
	videoStreamer.pendingRequests = [NSMutableArray array];
	
	NSURLComponents *components = [[NSURLComponents alloc] initWithURL:url resolvingAgainstBaseURL:NO];
	components.scheme = @"streaming";
	AVURLAsset *asset = [AVURLAsset URLAssetWithURL:[components URL] options:nil];
	[asset.resourceLoader setDelegate:videoStreamer queue:dispatch_get_main_queue()];
	
	[[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
	
	return asset;
}

- (void)dealloc {
	[[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
}

- (void)_processPendingRequests
{
	NSMutableArray *requestsCompleted = [NSMutableArray array];
	
	for (AVAssetResourceLoadingRequest *loadingRequest in self.pendingRequests)
	{
		[self _fillInContentInformation:loadingRequest.contentInformationRequest];
		
		BOOL didRespondCompletely = [self _isRespondCompletelyForRequest:loadingRequest.dataRequest];
		
		if (didRespondCompletely)
		{
			[requestsCompleted addObject:loadingRequest];
			
			[loadingRequest finishLoading];
		}
	}
	
	[self.pendingRequests removeObjectsInArray:requestsCompleted];
}

- (void)_fillInContentInformation:(AVAssetResourceLoadingContentInformationRequest *)contentInformationRequest
{
	if (contentInformationRequest == nil || self.response == nil)
	{
		return;
	}
	
	NSString *mimeType = [self.response MIMEType];
	CFStringRef contentType = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, (__bridge CFStringRef)(mimeType), NULL);
	
	contentInformationRequest.byteRangeAccessSupported = YES;
	contentInformationRequest.contentType = CFBridgingRelease(contentType);
	contentInformationRequest.contentLength = [self.response expectedContentLength];
}

- (BOOL)_isRespondCompletelyForRequest:(AVAssetResourceLoadingDataRequest *)dataRequest
{
//	ZPLogDebug(@"request:%p, Offset:%lli, requestedLength:%li, currentOffset:%lli, data:%li", dataRequest, dataRequest.requestedOffset, dataRequest.requestedLength, dataRequest.currentOffset, self.videoData.length);
	long long startOffset = dataRequest.requestedOffset;
	if (dataRequest.currentOffset != 0)
	{
		startOffset = dataRequest.currentOffset;
	}
	
	// Don't have any data at all for this request
	if (self.videoData.length < startOffset)
	{
		ZPLogDebug(@"NO DATA FOR REQUEST");
		return NO;
	}
	
	// This is the total data we have from startOffset to whatever has been downloaded so far
	NSUInteger unreadBytes = self.videoData.length - (NSUInteger)startOffset;
	
	// Respond with whatever is available if we can't satisfy the request fully yet
	NSUInteger numberOfBytesToRespondWith = MIN((NSUInteger)dataRequest.requestedLength, unreadBytes);
	
	NSData *subData = [self.videoData subdataWithRange:NSMakeRange((NSUInteger)startOffset, numberOfBytesToRespondWith)];
	[dataRequest respondWithData:subData];
	
	long long endOffset = startOffset + dataRequest.requestedLength;
	BOOL didRespondFully = self.videoData.length >= endOffset;
	
	return didRespondFully;
}

#pragma mark - NSURLConnectionDelegate, NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	ZPLogDebug(@"connection didFailWithError");
	ZPInvokeBlock(self.faild, error);
	
	_strongRef = nil;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	ZPLogDebug(@"connection didReceiveResponse");
	_expectedFileSize = response.expectedContentLength > 0 ? response.expectedContentLength : 0;
	
	self.videoData = [NSMutableData data];
	self.response = (NSHTTPURLResponse *)response;
	[self _processPendingRequests];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[self.videoData appendData:data];
	[self _processPendingRequests];
	
	float progress = (float)self.videoData.length / _expectedFileSize;
	ZPInvokeBlock(self.progress, progress);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	ZPLogDebug(@"connectionDidFinishLoading");
	isLoadingComplete = YES;
	[self _processPendingRequests];
	ZPInvokeBlock(self.success, self.videoData);
	
	_strongRef = nil;
}

#pragma mark - AVAssetResourceLoaderDelegate
- (BOOL)resourceLoader:(AVAssetResourceLoader *)resourceLoader shouldWaitForLoadingOfRequestedResource:(AVAssetResourceLoadingRequest *)loadingRequest
{
	if(isLoadingComplete == YES)
	{
		[self.pendingRequests addObject:loadingRequest];
		[self _processPendingRequests];
		return YES;
	}
	
	if (self.connection == nil)
	{
		NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
		self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
		[self.connection setDelegateQueue:[NSOperationQueue mainQueue]];
		
		[self.connection start];
	}
	
	ZPLogDebug(@"shouldWaitForLoadingOfRequestedResource:%@", loadingRequest);
	[self.pendingRequests addObject:loadingRequest];
	return YES;
}

- (void)resourceLoader:(AVAssetResourceLoader *)resourceLoader didCancelLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest
{
	ZPLogDebug(@"didCancelLoadingRequest:%@", loadingRequest);
	[self.pendingRequests removeObject:loadingRequest];
}

@end
