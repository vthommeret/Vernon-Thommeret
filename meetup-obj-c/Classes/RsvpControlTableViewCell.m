//
//  RsvpControlTableViewCell.m
//  Meetup
//
//  Created by Vernon Thommeret on 8/25/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import "RsvpControlTableViewCell.h"
#import "Event.h"
#import "State.h"

#define kRsvpControlWidth	99.0
#define kRsvpControlHeight	33.0

@implementation RsvpControlTableViewCell

@synthesize event = _event;
@synthesize yes = _yes;
@synthesize maybe = _maybe;
@synthesize no = _no;
@synthesize selected = _selected;

- (void)dealloc {
	[_event release];
	[_yes release];
	[_maybe release];
	[_no release];
	[_selected release];
    [super dealloc];
}

- (void)setEvent:(Event *)event {
	if (event != _event) {
		[_event release];
		_event = [event retain];
	}
	
	RsvpControlItemView *yes = [[RsvpControlItemView alloc] initWithImage:@"segControlLeft" text:@"Yes"
																   origin:CGPointMake(0, 0)];
	RsvpControlItemView *maybe = [[RsvpControlItemView alloc] initWithImage:@"segControlMiddle" text:@"Maybe"
																  origin:CGPointMake(kRsvpControlWidth - 1.0, 0)];
	RsvpControlItemView *no = [[RsvpControlItemView alloc] initWithImage:@"segControlRight" text:@"No"
																  origin:CGPointMake(2 * (kRsvpControlWidth - 1.0), 0)];
	
	if (event.myRsvp == RsvpResponseYes) {
		yes.state = UIControlStateSelected;
	} else if (event.myRsvp == RsvpResponseMaybe) {
		maybe.state = UIControlStateSelected;
	} else if (event.myRsvp == RsvpResponseNo) {
		no.state = UIControlStateSelected;
	}
	
	yes.delegate = maybe.delegate = no.delegate = self;
	
	[self.contentView addSubview:yes];
	[self.contentView addSubview:maybe];
	[self.contentView addSubview:no];
	
	self.yes = yes;
	self.maybe = maybe;
	self.no = no;
	
	[yes release];
	[maybe release];
	[no release];
}

- (void)didSelectRsvpControlItem:(RsvpControlItemView *)rsvpControlItem {
	[self.selected deselect];
	self.selected = rsvpControlItem;
}

+ (NSString *)baseIdentifier {
	return @"RsvpControl";
}

+ (CGRect)cellFrameWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
	return [[self class] cellFrameWithContentHeight:kRsvpControlHeight tableView:tableView indexPath:indexPath];
}

@end

#pragma mark -
#pragma mark RsvpControlItemView implementation

@implementation RsvpControlItemView

@synthesize normal = _normal;
@synthesize down = _down;
@synthesize selected = _selected;
@synthesize text = _text;
@synthesize state = _state;
@synthesize delegate = _delegate;

- (void)dealloc {
	[_normal release];
	[_down release];
	[_selected release];
	[_text release];
	[super dealloc];
}

- (id)initWithImage:(NSString *)image text:(NSString *)text origin:(CGPoint)origin {
	if (self = [super initWithFrame:CGRectMake(origin.x, origin.y, kRsvpControlWidth, kRsvpControlHeight)]) {
		self.normal = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", image]];
		self.down = [UIImage imageNamed:[NSString stringWithFormat:@"%@Down.png", image]];
		self.selected = [UIImage imageNamed:[NSString stringWithFormat:@"%@Selected.png", image]];
		self.text = text;
	}
	return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	if (!(self.state & UIControlStateSelected)) {
		UIView *selected = ((RsvpControlTableViewCell *) self.delegate).selected;
		
		if (selected != nil) {
			[[self superview] insertSubview:self belowSubview:selected];
		} else {
			[[self superview] bringSubviewToFront:self];
		}

		self.state = UIControlStateHighlighted;
		[self setNeedsDisplay];
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	if (!(self.state & UIControlStateSelected)) {
		if ([self.delegate respondsToSelector:@selector(didSelectRsvpControlItem:)]) {
			[self.delegate performSelector:@selector(didSelectRsvpControlItem:) withObject:self];
		}
		
		[[self superview] bringSubviewToFront:self];
		
		self.state = UIControlStateSelected;
		[self setNeedsDisplay];
	}
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	if (!(self.state & UIControlStateSelected)) {
		[self deselect];
	}
}

- (void)deselect {
	self.state = UIControlStateNormal;
	[self setNeedsDisplay];
}

#define kRsvpControlTextShadowR	44.0 / 255.0
#define kRsvpControlTextShadowG	69.0 / 255.0
#define kRsvpControlTextShadowB	137.0 / 255.0

- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
	
	if (self.state & UIControlStateHighlighted) {
		[self.down drawAtPoint:CGPointMake(0, 0)];
	} else if (self.state & UIControlStateSelected) {
		[self.selected drawAtPoint:CGPointMake(0, 0)];
	} else { // self.state & UIControlStateNormal
		[self.normal drawAtPoint:CGPointMake(0, 0)];
	}
	
	// draw text
	
	CGFloat textHeight = [self.text sizeWithFont:[UIFont boldSystemFontOfSize:13.0]].height;
	CGRect textRect = CGRectMake(0, round((rect.size.height - textHeight) / 2.0) - 2.0, rect.size.width, textHeight);
	CGRect textShadowRect = CGRectOffset(textRect, 0, -1);
	UIFont *font = [UIFont boldSystemFontOfSize:13.0];
	UILineBreakMode lineMode = UILineBreakModeTailTruncation;
	UITextAlignment alignment = UITextAlignmentCenter;
	
	if (self.state & UIControlStateSelected) {
		[[UIColor colorWithRed:kRsvpControlTextShadowR green:kRsvpControlTextShadowG blue:kRsvpControlTextShadowB alpha:1.0] set];
		[self.text drawInRect:textShadowRect withFont:font lineBreakMode:lineMode alignment:alignment];
		
		[[UIColor whiteColor] set];
	}

	
	[self.text drawInRect:textRect withFont:font lineBreakMode:lineMode alignment:alignment];
}

@end
