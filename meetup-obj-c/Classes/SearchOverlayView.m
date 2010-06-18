//
//  SearchOverlayView.m
//  Meetup
//
//  Created by Vernon Thommeret on 8/21/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import "SearchOverlayView.h"

@implementation SearchOverlayView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		self.backgroundColor = [UIColor blackColor];
		self.alpha = 0.0;
	}
	
	return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[self hide];
}

- (void)show {
	[UIView beginAnimations:nil context:NULL];
	self.alpha = 0.75;
	[UIView commitAnimations];
}

- (void)hide {
	[delegate willHideOverlay];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(cleanUp)];
	self.alpha = 0.0;
	[UIView commitAnimations];
}

- (void)didHide {
	[delegate didHideOverlay];
}

@end
