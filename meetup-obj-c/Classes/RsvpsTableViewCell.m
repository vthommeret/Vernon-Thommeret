//
//  RsvpTableViewCell.m
//  Meetup
//
//  Created by Vernon Thommeret on 8/17/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import "RsvpsTableViewCell.h"
#import "Event.h"
#import "State.h"

@implementation RsvpsTableViewCell

@synthesize event = _event;

- (id)initWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithTableView:tableView indexPath:indexPath reuseIdentifier:reuseIdentifier]) {
		RsvpTableViewCellView *cellView = [[RsvpTableViewCellView alloc]
											 initWithFrame:CGRectZero parentCell:self];
		
		cellView.frame = [[self class] cellFrameWithTableView:self.tableView indexPath:self.indexPath];
		
		[self.contentView addSubview:cellView];
		self.cellView = cellView;
		[cellView release];
	}
	return self;
}

- (void)prepareForReuse {
	self.cellView.frame = [[self class] cellFrameWithTableView:self.tableView indexPath:self.indexPath];
}

- (void)setEvent:(Event *)event {
	if (event != _event) {
		[_event release];
		_event = [event retain];
	}
	
	[self.cellView setNeedsDisplay];
}

- (void)dealloc {
	[_event release];
    [super dealloc];
}

+ (NSString *)baseIdentifier {
	return @"Rsvps";
}

#define kRsvpRowHeight	75.0

+ (CGRect)cellFrameWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
	return [[self class] cellFrameWithContentHeight:kRsvpRowHeight tableView:tableView indexPath:indexPath];
}

@end

#pragma mark -
#pragma mark RsvpsTableViewCellView Implementation

@implementation RsvpTableViewCellView

#define kRsvpCountFontSize	30.0
#define kRsvpRowKeyPadding	5.0

- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
	
	RsvpsTableViewCell *parentCell = (RsvpsTableViewCell *) self.parentCell;
	
	CGPoint insetOrigin = [[parentCell class] insetOriginForTableView:parentCell.tableView];
	CGFloat insetWidth = [[parentCell class] insetWidthForTableView:parentCell.tableView
												  withAccessoryType:parentCell.accessoryType];
	
	_highlighted ? [[UIColor whiteColor] set] : [[UIColor blackColor] set];
	
	NSInteger insetThird = insetWidth / 3.0;
	UIFont *rsvpCountFont = [UIFont boldSystemFontOfSize:kRsvpCountFontSize];
	UIFont *keyFont = [UIFont boldSystemFontOfSize:kKeyFontSize];
	
	// draw rsvp counts
	
	NSString *yesRsvpCount = [NSString stringWithFormat:@"%d", parentCell.event.rsvpCount - parentCell.event.maybeRsvpCount];
	NSString *maybeRsvpCount = [NSString stringWithFormat:@"%d", parentCell.event.maybeRsvpCount];
	NSString *noRsvpCount = [NSString stringWithFormat:@"%d", parentCell.event.noRsvpCount];
	
	[yesRsvpCount drawInRect:CGRectMake(insetOrigin.x, insetOrigin.y, insetThird, kRsvpCountFontSize)
					withFont:rsvpCountFont
			   lineBreakMode:UILineBreakModeTailTruncation
				   alignment:UITextAlignmentCenter];
	
	[maybeRsvpCount drawInRect:CGRectMake(insetOrigin.x + insetThird, insetOrigin.y, insetThird, kRsvpCountFontSize)
					  withFont:rsvpCountFont
				 lineBreakMode:UILineBreakModeTailTruncation
					 alignment:UITextAlignmentCenter];
	
	[noRsvpCount drawInRect:CGRectMake(insetOrigin.x + insetThird * 2, insetOrigin.y, insetThird, kRsvpCountFontSize)
			 withFont:rsvpCountFont
		lineBreakMode:UILineBreakModeTailTruncation
			alignment:UITextAlignmentCenter];
	
	// draw keys
	
	_highlighted ? [[UIColor whiteColor] set] : [[State sharedState].keyColor set];
	
	NSInteger yDelta = kRsvpCountFontSize + kRsvpRowKeyPadding;
	
	[@"yes" drawInRect:CGRectMake(insetOrigin.x, insetOrigin.y + yDelta, insetThird, kRsvpCountFontSize)
					withFont:keyFont
			   lineBreakMode:UILineBreakModeTailTruncation
				   alignment:UITextAlignmentCenter];
	
	[@"maybe" drawInRect:CGRectMake(insetOrigin.x + insetThird, insetOrigin.y + yDelta, insetThird, kRsvpCountFontSize)
					  withFont:keyFont
				 lineBreakMode:UILineBreakModeTailTruncation
					 alignment:UITextAlignmentCenter];
	
	[@"no" drawInRect:CGRectMake(insetOrigin.x + insetThird * 2, insetOrigin.y + yDelta, insetThird, kRsvpCountFontSize)
				   withFont:keyFont
			  lineBreakMode:UILineBreakModeTailTruncation
				  alignment:UITextAlignmentCenter];
}

@end