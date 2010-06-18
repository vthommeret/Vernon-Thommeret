//
//  MultiLineTableViewCell.m
//  TableCommon
//
//  Created by Vernon Thommeret on 8/11/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import "MultiLineTableViewCell.h"

#define kMaxMultiLineRowHeight	50.0

@implementation MultiLineTableViewCell

@synthesize content = _content;
@synthesize showFull = _showFull;

- (id)initWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithTableView:tableView indexPath:indexPath reuseIdentifier:reuseIdentifier]) {
		MultiLineTableViewCellView *view = [[MultiLineTableViewCellView alloc] initWithFrame:CGRectZero parentCell:self];
		[self.contentView addSubview:view];
		self.cellView = view;
		[view release];
	}
	return self;
}

- (void)setShowFull:(BOOL)showFull {
	_showFull = showFull;
	
	if (showFull) {
		self.accessoryType = UITableViewCellAccessoryNone;
	} else {
		self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
}

- (void)setContent:(NSString *)content {
	[_content release];
	_content = [content copy];
	
	// redrawing the frame is expensive; only change if necessary
	CGRect newFrame = [[self class] cellFrameWithContent:self.content tableView:self.tableView indexPath:self.indexPath accessoryType:self.accessoryType showFull:self.showFull];
	if (self.cellView.frame.size.height != newFrame.size.height) {
		self.cellView.frame = newFrame;
		[self.cellView setNeedsDisplay];
	}
}

- (void)dealloc {
	[_content release];
    [super dealloc];
}

+ (NSString *)baseIdentifier {
	return @"MultiLine";
}

+ (CGRect)cellFrameWithContent:(NSString *)content tableView:(UITableView *)tableView
					 indexPath:(NSIndexPath *)indexPath accessoryType:(UITableViewCellAccessoryType)accessoryType
					  showFull:(BOOL)showFull {
	CGFloat maxHeight;
	
	if (showFull) {
		maxHeight = MAXFLOAT;
	} else {
		maxHeight = kMaxMultiLineRowHeight;
	}
	
	CGFloat insetPaddingVert = [[self class] insetOriginForTableView:tableView].y * 2.0;
	CGFloat insetWidth = [[self class] insetWidthForTableView:tableView withAccessoryType:accessoryType];
	CGFloat contentHeight = [content sizeWithFont:[UIFont systemFontOfSize:14.0]
								constrainedToSize:CGSizeMake(insetWidth, maxHeight)
									lineBreakMode:UILineBreakModeTailTruncation].height + insetPaddingVert;
	
	return [[self class] cellFrameWithContentHeight:contentHeight tableView:tableView indexPath:indexPath];
}

@end

#pragma mark -
#pragma mark MultiLineTableViewCellView Implementation

@implementation MultiLineTableViewCellView

- (id)initWithFrame:(CGRect)frame parentCell:(AbstractTableViewCell *)parentCell {
	if (self = [super initWithFrame:frame parentCell:parentCell]) {
		self.fontSize = 14.0;
	}
	return self;
}

- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
	
	MultiLineTableViewCell *parentCell = (MultiLineTableViewCell *) self.parentCell;
	
	CGFloat maxHeight;
	
	if (parentCell.showFull) {
		maxHeight = MAXFLOAT;
	} else {
		maxHeight = kMaxMultiLineRowHeight;
	}
	
	CGPoint insetOrigin = [[parentCell class] insetOriginForTableView:parentCell.tableView];
	CGFloat insetWidth = [[parentCell class] insetWidthForTableView:parentCell.tableView
												  withAccessoryType:parentCell.accessoryType];
	
	_highlighted ? [[UIColor whiteColor] set] : [[UIColor blackColor] set];
	
	
	[parentCell.content drawInRect:CGRectMake(insetOrigin.x, insetOrigin.y, insetWidth, maxHeight)
						  withFont:[UIFont systemFontOfSize:self.fontSize]
					 lineBreakMode:UILineBreakModeTailTruncation];
}

@end
