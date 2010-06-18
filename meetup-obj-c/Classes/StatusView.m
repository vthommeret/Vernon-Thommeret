//
//  StatusView.m
//  Meetup
//
//  Created by Vernon Thommeret on 8/14/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import "StatusView.h"
#import "State.h"

@implementation StatusView

@synthesize statusViewItem = _statusViewItem;

- (id)initWithFrame:(CGRect)frame style:(StatusViewStyle)style statusViewItem:(StatusViewItem *)statusViewItem {	
	if (self = [super initWithFrame:frame]) {
		self.statusViewItem = statusViewItem;
		
		if (style == StatusViewStyleScreen) {
			self.backgroundColor = [State sharedState].grayBackgroundColor;
			
			UIImageView *headerShadow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"headerShadow.png"]];
			[self addSubview:headerShadow];
			[self sendSubviewToBack:headerShadow];
			[headerShadow release];
		}
	}
	
	return self;
}

- (void)setStatusViewItem:(StatusViewItem *)statusViewItem {
	if (statusViewItem != _statusViewItem) {
		[_statusViewItem removeFromSuperview];
		[_statusViewItem release];
		_statusViewItem = [statusViewItem retain];
	}
	
	[statusViewItem drawWithParentFrame:self.frame];
	[self addSubview:statusViewItem];
}

- (void)dealloc {
	[_statusViewItem removeFromSuperview];
    [super dealloc];
}

@end

#pragma mark -
#pragma mark StatusViewItem Implementation

@implementation StatusViewItem

@synthesize text = _text;
@synthesize icon = _icon;
@synthesize spinner = _spinner;

- (id)initWithText:(NSString *)text icon:(UIImage *)icon {
	if (self = [super init]) {
		self.text = text;
		self.icon = icon;
		self.backgroundColor = [State sharedState].grayBackgroundColor;
	}
	return self;
}

- (id)initWithText:(NSString *)text {
	return [self initWithText:text icon:nil];
}

#define kTextPadding		60.0
#define kSpinnerWithPadding	24.0
#define kIconPadding		6.0

- (void)drawWithParentFrame:(CGRect)parentFrame {
	CGFloat iconWithPadding;
	CGFloat maxHeight;
	
	CGSize textSize = [self.text sizeWithFont:[UIFont boldSystemFontOfSize:14.0]
									 forWidth:parentFrame.size.height - kTextPadding
								lineBreakMode:UILineBreakModeTailTruncation];
	
	if (self.icon == nil) {
		iconWithPadding = kSpinnerWithPadding;
		maxHeight = textSize.height;
	} else {
		iconWithPadding = self.icon.size.width + kIconPadding;
		maxHeight = MAX(textSize.height, self.icon.size.height);
	}
	
	CGRect itemFrame = CGRectMake((parentFrame.size.width - textSize.width - iconWithPadding) / 2.0,
								  (parentFrame.size.height - maxHeight) / 2.0,
								  textSize.width + iconWithPadding,
								  maxHeight + 1); // extra pixel for text shadow
	itemFrame = CGRectIntegral(itemFrame);
	self.frame = itemFrame;
	
	if (self.icon != nil) {
		UIImageView *iconView = [[UIImageView alloc] initWithImage:self.icon];
		[self addSubview:iconView];
		[iconView release];
	} else {
		UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc]
											initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		[self addSubview:spinner];
		[spinner startAnimating];
		self.spinner = spinner;
		[spinner release];
	}
	
	CGRect labelRect = CGRectMake(iconWithPadding, 0, self.frame.size.width - iconWithPadding, self.frame.size.height);
	
	UILabel *label = [[UILabel alloc] initWithFrame:labelRect];
	label.text = self.text;
	label.font = [UIFont boldSystemFontOfSize:14.0];
	label.textColor = [State sharedState].darkTextColor;
	label.shadowColor = [UIColor whiteColor];
	label.shadowOffset = CGSizeMake(0, 1);
	label.backgroundColor = [UIColor clearColor];
	
	[self addSubview:label];
	[label release];
}

- (void)dealloc {
	[_text release];
	[_icon release];
	[_spinner release];
	[super dealloc];
}

@end