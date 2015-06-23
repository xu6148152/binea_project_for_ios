//
//  BSApplication.m
//  Bristol
//
//  Created by Yangfan Huang on 5/8/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSApplication.h"
#import "UIControl+EventTrack.h"

@implementation BSApplication
- (BOOL) sendAction:(SEL)action to:(id)target from:(id)sender forEvent:(UIEvent *)event {
	if ([sender isKindOfClass:[UIControl class]]) {
		UIControl *control = (UIControl *)sender;
		
		if (control.eventTrackName || ([target isKindOfClass:[UIBarButtonItem class]] && ((UIBarButtonItem *)target).eventTrackName)) {
			NSSet *touches = [event touchesForView:control];
			for (UITouch *touch in touches) {
				if (touch.phase == UITouchPhaseEnded && CGRectContainsPoint(control.bounds,[touch locationInView:control])) {
					if (control.eventTrackName) {
						[control trackTap];
					} else {
						[(UIBarButtonItem *)target trackTap];
					}
					break;
				}
			}
		}
	}
	
	return [super sendAction:action to:target from:sender forEvent:event];
}
@end
