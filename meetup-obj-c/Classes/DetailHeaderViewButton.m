//
//  DetailHeaderViewButton.m
//  Meetup
//
//  Created by Vernon Thommeret on 8/26/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import "DetailHeaderViewButton.h"

#define kDetailHeaderButtonFontSize		13.0
#define kDetailHeaderButtonTopPadding	4.0
#define kDetailHeaderButtonSidePadding	7.0
#define kDetailHeaderButtonTextShadowR	65.0 / 255.0
#define kDetailHeaderButtonTextShadowG	138.0 / 255.0
#define kDetailHeaderButtonTextShadowB	45.0 / 255.0

@implementation DetailHeaderViewButton

@synthesize title = _title;
@synthesize style = _style;

- (void)dealloc {
	[_title release];
	[super dealloc];
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		self.backgroundColor = [UIColor clearColor];
		[self addTarget:self action:@selector(cancel)
	   forControlEvents:UIControlEventTouchDragExit | UIControlEventTouchCancel | UIControlEventTouchUpInside];
		[self addTarget:self action:@selector(select) forControlEvents:UIControlEventTouchDown];
    }
    return self;
}

- (void)cancel {
	self.highlighted = NO;
	[self setNeedsDisplay];
}

- (void)select {
	self.highlighted = YES;
	[self setNeedsDisplay];
}

- (void)enable {
	self.enabled = YES;
	
	[UIView beginAnimations:nil context:NULL];
	self.alpha = 1.0;
	[UIView commitAnimations];
}

- (void)disable {
	self.enabled = NO;
	
	[UIView beginAnimations:nil context:NULL];
	self.alpha = 0.5;
	[UIView commitAnimations];
}

- (void)setTitle:(NSString *)title {
	if (title != _title) {
		[_title release];
		_title = [title retain];
	}
	
	[self setNeedsDisplay];
}

- (void)setStyle:(DetailHeaderViewButtonStyle)style {
	_style = style;
	
	if (style == DetailHeaderViewButtonStyleInfo) {
		self.alpha = 0.3;
		self.userInteractionEnabled = NO;
	} else { // style == DetailHeaderViewButtonStyleNormal
		self.alpha = 1.0;
	}
}

- (CGSize)sizeThatFitsTitle:(NSString *)title {
	CGFloat heightDelta = self.style == DetailHeaderViewButtonStyleInfo ? 1 : 0;
	
	CGSize titleSize = [title sizeWithFont:[UIFont boldSystemFontOfSize:kDetailHeaderButtonFontSize]];
	titleSize = CGSizeMake(titleSize.width + 2 * kDetailHeaderButtonSidePadding, self.frame.size.height + heightDelta);
	return titleSize;
}

- (CGSize)sizeThatFits:(CGSize)size {
	return [self sizeThatFitsTitle:self.title];
}

- (void)drawRect:(CGRect)rect {
	UIImage *background;
	UIColor *textColor;
	UIColor *shadowColor;
	CGFloat shadowOffset;
	
	if (self.style == DetailHeaderViewButtonStyleNormal) {
		if (self.state == UIControlStateHighlighted) {
			background = [[UIImage imageNamed:@"detailHeaderButtonHighlighted.png"]
						  stretchableImageWithLeftCapWidth:4.0 topCapHeight:12.0];
		} else {
			background = [[UIImage imageNamed:@"detailHeaderButton.png"]
						  stretchableImageWithLeftCapWidth:4.0 topCapHeight:12.0];
		}
		
		textColor = [UIColor whiteColor];
		shadowColor = [UIColor colorWithRed:kDetailHeaderButtonTextShadowR
									  green:kDetailHeaderButtonTextShadowG
									   blue:kDetailHeaderButtonTextShadowB
									  alpha:1.0];
		shadowOffset = -1.0;
	} else { // self.style == DetailHeaderViewButtonStyleInfo
		background = [[UIImage imageNamed:@"detailHeaderInfoButton.png"]
					  stretchableImageWithLeftCapWidth:4.0 topCapHeight:12.0];
		textColor = [UIColor blackColor];
		shadowColor = [UIColor colorWithWhite:1.0 alpha:0.8];
		shadowOffset = 1.0;
	}
	
	[background drawInRect:rect];
	
	[shadowColor set];
	[self.title drawAtPoint:CGPointMake(kDetailHeaderButtonSidePadding, kDetailHeaderButtonTopPadding + shadowOffset)
				   withFont:[UIFont boldSystemFontOfSize:kDetailHeaderButtonFontSize]];
	
	[textColor set];
	[self.title drawAtPoint:CGPointMake(kDetailHeaderButtonSidePadding, kDetailHeaderButtonTopPadding)
				   withFont:[UIFont boldSystemFontOfSize:kDetailHeaderButtonFontSize]];
}

@end
