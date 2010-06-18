//
//  AbstractTableViewCell.m
//  TableCommon
//
//  Created by Vernon Thommeret on 8/11/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import "AbstractTableViewCell.h"

@implementation AbstractTableViewCell

@synthesize cellView = _cellView;
@synthesize cellType = _cellType;
@synthesize tableView = _tableView;
@synthesize indexPath = _indexPath;
@synthesize key = _key;

- (id)initWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
		self.tableView = tableView;
		self.indexPath = indexPath;
		self.cellType = [[self class] cellTypeForTableView:tableView indexPath:indexPath];
	}
	return self;
}

- (void)prepareForReuseWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
	self.tableView = tableView;
	self.indexPath = indexPath;
}

- (void)dealloc {
	[_cellView release];
	[_indexPath release];
	[_key release];
    [super dealloc];
}

// should be overidden
+ (NSString *)baseIdentifier {
	return @"";
}

+ (NSString *)identifierWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
	NSString *baseIdentifier = [[self class] baseIdentifier];
	
	AbstractTableViewCellType cellType = [[self class] cellTypeForTableView:tableView indexPath:indexPath];
	
	NSString *style = cellType & AbstractTableViewCellTypePlain ? @"Plain" : @"Grouped";
	NSString *position;
	
	if (cellType & AbstractTableViewCellTypeBeforeSection) {
		position = @"BeforeSection";
	} else if (cellType & AbstractTableViewCellTypeSingle) {
		position = @"Single";
	} else if (cellType & AbstractTableViewCellTypeLast) {
		position = @"Last";
	} else if (cellType & AbstractTableViewCellTypeFirst) {
		position = @"First";
	} else { // type & AbstractTableViewCellTypeMiddle
		position = @"Middle";
	}
	
	return [NSString stringWithFormat:@"%@_%@_%@", style, baseIdentifier, position];
}

+ (AbstractTableViewCellType)cellTypeForTableView:(UITableView *)tableView
										indexPath:(NSIndexPath *) indexPath {
	NSInteger sections = [tableView numberOfSections];
	NSInteger section = indexPath.section;
	NSInteger rows = [tableView.dataSource tableView:tableView numberOfRowsInSection:indexPath.section];
	NSInteger row = indexPath.row;
	
	AbstractTableViewCellType cellType = tableView.style == UITableViewStylePlain ?
	AbstractTableViewCellTypePlain : AbstractTableViewCellTypeGrouped;
	
	if (cellType & AbstractTableViewCellTypePlain) {
		if (section == sections - 1 && row == rows - 1) {
			cellType |= AbstractTableViewCellTypeLast;
		} else if (row == rows - 1) {
			cellType |= AbstractTableViewCellTypeBeforeSection;
		} else {
			cellType |= AbstractTableViewCellTypeMiddle;
		}
	} else { // cellType & AbstractTableViewCellTypeGrouped
		if (rows == 1) {
			cellType |= AbstractTableViewCellTypeSingle;
		} else if (row == rows - 1) {
			cellType |= AbstractTableViewCellTypeLast;
		} else if (row == 0) {
			cellType |= AbstractTableViewCellTypeFirst;
		} else {
			cellType |= AbstractTableViewCellTypeMiddle;
		}
	}
	
	return cellType;
}

+ (CGRect)cellFrameWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
	return [[self class] cellFrameWithContentHeight:kStandardRowHeight tableView:tableView indexPath:indexPath];
}

// For some reason, Apple draws grouped table view cells 1px outside of their frame.
// It's probably so that cells can be placed one after another without the separators
// butting up against each other (like CSS' border-collapse: collapse), but it's not
// as helpful for for us since we're doing all the drawing ourselves.
#define kGroupedNegOffset	-1

+ (CGRect)cellFrameWithContentHeight:(CGFloat)contentHeight
						   tableView:(UITableView *)tableView
						   indexPath:(NSIndexPath *)indexPath {	
	AbstractTableViewCellType type = [[self class] cellTypeForTableView:tableView indexPath:indexPath];
	
	CGFloat cellHeight = contentHeight;
	
	if (type & AbstractTableViewCellTypePlain) {		
		if (!(type & AbstractTableViewCellTypeLast)) {
			cellHeight += 1.0; // separator
		}
		
		return CGRectMake(0, 0, kPlainCellWidth, cellHeight);
	} else { // type & AbstractTableViewCellTypeGrouped
		if (type & AbstractTableViewCellTypeLast || type & AbstractTableViewCellTypeSingle) {
			cellHeight += 5.0; // shadow + separator
		} else {
			cellHeight += 1.0; // separator
		}
		
		return CGRectMake(kGroupedNegOffset, kGroupedNegOffset, kGroupedCellWidth - kGroupedNegOffset * 2, cellHeight);
	}
}

+ (CGPoint)originForTableView:(UITableView *)tableView {
	if (tableView.style == UITableViewStylePlain) {
		return kPlainCellOrigin;
	} else { // tableView.style == UITableViewStyleGrouped
		return kGroupedCellOrigin;
	}
}

+ (CGPoint)insetOriginForTableView:(UITableView *)tableView {
	if (tableView.style == UITableViewStylePlain) {
		return CGPointMake(kPlainCellPadding, kPlainCellPadding);
	} else { // tableView.style == UITableViewStyleGrouped
		return CGPointMake(kGroupedCellPaddingHoriz, kGroupedCellPaddingVert);
	}
}

#define kAccessoryDisclosureIndicatorPadding	18.0

+ (CGFloat)insetWidthForTableView:(UITableView *)tableView withAccessoryType:(UITableViewCellAccessoryType)accessoryType {
	CGFloat delta = 0;
	
	if (accessoryType == UITableViewCellAccessoryDisclosureIndicator) {
		delta = kAccessoryDisclosureIndicatorPadding;
	}
	
	if (tableView.style == UITableViewStylePlain) {
		return kPlainCellWidth - kPlainCellPadding * 2.0 - delta;
	} else { // tableView.style == UITableViewStyleGrouped
		return kGroupedCellWidth - kGroupedCellPaddingHoriz * 2.0 - delta;
	}
}

+ (CGFloat)fontSizeForTableView:(UITableView *)tableView {
	if (tableView.style == UITableViewStylePlain) {
		return 20.0;
	} else { // tableView.style == UITableViewStyleGrouped
		return 15.0;
	}
}

@end

#pragma mark -
#pragma mark AbstractTableViewCellView Implementation

@implementation AbstractTableViewCellView

static NSMutableDictionary *_images;

@synthesize parentCell = _parentCell;
@synthesize backImageTitle = _backImageTitle;
@synthesize backImageSelectedTitle = _backImageSelectedTitle;
@synthesize fontSize = _fontSize;

- (id)initWithFrame:(CGRect)frame parentCell:(AbstractTableViewCell *)parentCell {
	if (self = [super initWithFrame:frame]) {		
		self.parentCell = parentCell;
		
		self.fontSize = [AbstractTableViewCell fontSizeForTableView:self.parentCell.tableView];
		
		AbstractTableViewCellType cellType = self.parentCell.cellType;
		
		NSString *tableType;
		
		if (cellType & AbstractTableViewCellTypePlain) {
			tableType = @"plain";
		} else { // cellType & AbstractTableViewCellTypeGrouped
			tableType = @"grouped";
		}
		
		NSString *position;
		
		if (cellType & AbstractTableViewCellTypeFirst) {
			position = @"First";
		} else if (cellType & AbstractTableViewCellTypeMiddle) {
			position = @"Middle";
		} else if (cellType & AbstractTableViewCellTypeLast) {
			position = @"Last";
		} else if (cellType & AbstractTableViewCellTypeSingle) {
			position = @"Single";
		} else { // type & AbstractTableViewCellTypeBeforeSection
			position = @"BeforeSection";
		}
		
		NSString *backImageTitle = [[NSString alloc] initWithFormat:@"%@Row%@.png", tableType, position];
		NSString *backImageSelectedTitle = [[NSString alloc] initWithFormat:@"%@Row%@Selected.png", tableType, position];
		
		self.backImageTitle = backImageTitle;
		self.backImageSelectedTitle = backImageSelectedTitle;
		
		[backImageTitle release];
		[backImageSelectedTitle release];
	}
	
	return self;
}

- (void)dealloc {
	[_backImageTitle release];
	[_backImageSelectedTitle release];
	[super dealloc];
}

- (void)drawRect:(CGRect)rect {
	NSString *imageTitle = _highlighted ? self.backImageSelectedTitle : self.backImageTitle;
	[[[self class] imageNamed:imageTitle width:self.frame.size.width height:self.frame.size.height] drawAtPoint:CGPointMake(0, 0)];
}

+ (UIImage *)imageNamed:(NSString *)name width:(CGFloat)width height:(CGFloat)height {
	if (_images == nil) {
		_images = [[NSMutableDictionary alloc] initWithCapacity:20];
	}
	
	NSString *key = [[NSString alloc] initWithFormat:@"%.1f,%.1f,%@", width, height, name];
	UIImage *image = [_images objectForKey:key];
	
	if (image == nil) {
		image = [[UIImage imageNamed:name] stretchableImageWithLeftCapWidth:10 topCapHeight:14];
		
		UIGraphicsBeginImageContext(CGSizeMake(width, height));
		[image drawInRect:CGRectMake(0, 0, width, height)];
		image = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext(); 
		
		if (image != nil) {			
			[_images setObject:image forKey:key];
		}
	}
	
	[key release];
	
	return image;
}

- (void) setHighlighted:(BOOL)highlighted {
	_highlighted = highlighted;
	[self setNeedsDisplay];
}

- (BOOL) isHighlighted {
	return _highlighted;
}

@end
