//
//  BSAttributedLabel.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 1/22/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSAttributedLabel.h"

@implementation BSAttributedLabel

- (void)_setDefaults {
	[self setLinkAttributesWithColor:[UIColor whiteColor]];
}

- (id)init {
	self = [super init];
	if (self) {
		[self _setDefaults];
	}
	return self;
}

- (void)awakeFromNib {
	[super awakeFromNib];
	
	[self _setDefaults];
}

- (void)setBounds:(CGRect)bounds {
	[super setBounds:bounds];

	if (self.numberOfLines == 0 && bounds.size.width != self.preferredMaxLayoutWidth) {
		self.preferredMaxLayoutWidth = self.bounds.size.width;
		[self setNeedsUpdateConstraints];
	}
}

- (void)setLinkAttributesWithColor:(UIColor *)color {
	UIFont *baseFont = [UIFont fontWithName:@"Avenir-BlackOblique" size:12];
	CTFontRef baseFontRef = CTFontCreateWithName((__bridge CFStringRef)baseFont.fontName, baseFont.pointSize, NULL);
	self.linkAttributes = @{ (NSString *)kCTForegroundColorAttributeName : color, (NSString *)kCTUnderlineStyleAttributeName : @(NO), (NSString *)kCTFontAttributeName : (__bridge id)baseFontRef };
	CFRelease(baseFontRef);
	self.activeLinkAttributes = self.linkAttributes;
	self.inactiveLinkAttributes = self.linkAttributes;
}
@end
