//
//  SingleLineTableViewCell.m
//  TableCommon
//
//  Created by Vernon Thommeret on 8/11/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import "SingleLineTableViewCell.h"

@implementation SingleLineTableViewCell

@synthesize content = _content;
@synthesize icon = _icon;

- (id)initWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithTableView:tableView indexPath:indexPath reuseIdentifier:reuseIdentifier]) {
		SingleLineTableViewCellView *view = [[SingleLineTableViewCellView alloc]
											 initWithFrame:CGRectZero parentCell:self];
		[self.contentView addSubview:view];
		self.cellView = view;
		[view release];
	}
	return self;
}

- (void)setContent:(NSString *)content {
	[_content release];
	_content = [content copy];
	
	if (self.cellView == nil) {
		SingleLineTableViewCellView *view = [[SingleLineTableViewCellView alloc]
											 initWithFrame:CGRectZero parentCell:self];
		[self.contentView addSubview:view];
		self.cellView = view;
		[view release];
	}
	
	// redrawing the frame is expensive; only change if necessary
	CGRect newFrame = [[self class] cellFrameWithTableView:self.tableView indexPath:self.indexPath];
	if (self.cellView.frame.size.height != newFrame.size.height) {
		self.cellView.frame = newFrame;
		[self.cellView setNeedsDisplay];
	}
}

- (void)dealloc {
	[_content release];
	[_icon release];
    [super dealloc];
}

+ (NSString *)baseIdentifier {
	return @"SingleLine";
}

@end

#pragma mark -
#pragma mark SingleLineTableViewCellView Implementation

@implementation SingleLineTableViewCellView

#define kIconOffset	36.0

- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
	
	SingleLineTableViewCell *parentCell = (SingleLineTableViewCell *) self.parentCell;
	
	CGPoint insetOrigin = [[parentCell class] insetOriginForTableView:parentCell.tableView];
	CGFloat insetWidth = [[parentCell class] insetWidthForTableView:parentCell.tableView
												  withAccessoryType:parentCell.accessoryType];
	
	_highlighted ? [[UIColor whiteColor] set] : [[UIColor blackColor] set];
	
	if (parentCell.icon != nil) {
		[parentCell.icon drawAtPoint:CGPointMake(insetOrigin.x, insetOrigin.y - 3)];
		
		insetOrigin = CGPointMake(insetOrigin.x + kIconOffset, insetOrigin.y);
		insetWidth = insetWidth - kIconOffset;
	}
	
	CGPoint origin = [[parentCell class] originForTableView:parentCell.tableView];
	
	UIFont *font = [UIFont boldSystemFontOfSize:self.fontSize];
	
	CGFloat textHeight = [parentCell.content sizeWithFont:font].height;
	CGPoint textOrigin = CGPointMake(insetOrigin.x, origin.y + round((kStandardRowHeight - textHeight) / 2));
	
	[parentCell.content drawAtPoint:textOrigin
						   forWidth:insetWidth
						   withFont:font
					  lineBreakMode:UILineBreakModeTailTruncation];
}

@end