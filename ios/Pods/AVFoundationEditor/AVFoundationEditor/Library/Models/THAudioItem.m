//
//  MIT License
//
//  Copyright (c) 2013 Bob McCune http://bobmccune.com/
//  Copyright (c) 2013 TapHarmonic, LLC http://tapharmonic.com/
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//

#import "THAudioItem.h"
#import "THVideoItem.h"

@interface THAudioItem()

@property (nonatomic, assign) BOOL prepared;
@property (nonatomic, copy) NSString *mediaType;
@property (nonatomic, copy) NSString *title;

@end

@implementation THAudioItem

+ (id)audioItemWithURL:(NSURL *)url {
	return [[self alloc] initWithURL:url];
}

+ (id)audioItemWithVideoItem:(THVideoItem *)videoItem {
	if (videoItem) {
		THAudioItem *audioItem = [[THAudioItem alloc] init];
		[audioItem _setupWithVideoItem:videoItem];
		return audioItem;
	} else {
		return nil;
	}
}

- (id)copyWithZone:(NSZone *)zone {
	THAudioItem *item = [super copyWithZone:zone];
	item.volumeAutomation = self.volumeAutomation;
	
	return item;
}

- (void)_setupWithVideoItem:(THVideoItem *)videoItem {
	self.timeRange = videoItem.timeRange;
	self.startTimeInTimeline = videoItem.startTimeInTimeline;
	self.asset = videoItem.asset;
	self.prepared = videoItem.prepared;
	self.mediaType = videoItem.mediaType;
	self.title = videoItem.title;
}

- (NSString *)mediaType {
	return AVMediaTypeAudio;
}

@end
