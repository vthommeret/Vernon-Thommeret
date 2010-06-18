//
//  AbstractTableViewCell.h
//  TableCommon
//
//  Created by Vernon Thommeret on 8/11/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//
#import <UIKit/UIKit.h>

#define kStandardRowHeight	43.0

#define kPlainCellWidth				320.0
#define	kGroupedCellWidth			300.0

#define kPlainCellOrigin			CGPointMake(0, 0)
#define kGroupedCellOrigin			CGPointMake(1, 1)

#define kPlainCellPadding			10.0
#define kGroupedCellPaddingHoriz	9.0
#define kGroupedCellPaddingVert		11.0

enum {
    AbstractTableViewCellTypePlain         = 1 << 0,
    AbstractTableViewCellTypeGrouped       = 1 << 1,
    AbstractTableViewCellTypeFirst         = 1 << 2,
    AbstractTableViewCellTypeMiddle        = 1 << 3,
    AbstractTableViewCellTypeLast          = 1 << 4,
    AbstractTableViewCellTypeSingle        = 1 << 5,
	AbstractTableViewCellTypeBeforeSection = 1 << 6
};
typedef NSUInteger AbstractTableViewCellType;

@class AbstractTableViewCellView;

@interface AbstractTableViewCell : UITableViewCell {
	AbstractTableViewCellType _cellType;
	AbstractTableViewCellView *_cellView;
	UITableView *_tableView;
	NSIndexPath *_indexPath;
	NSString *_key;
}

@property (nonatomic, assign) AbstractTableViewCellType cellType;
@property (nonatomic, retain) AbstractTableViewCellView *cellView;
@property (nonatomic, assign) UITableView *tableView;
@property (nonatomic, retain) NSIndexPath *indexPath;
@property (nonatomic, copy) NSString *key;

- (id)initWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
		reuseIdentifier:(NSString *)reuseIdentifier;
- (void)prepareForReuseWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
+ (NSString *)baseIdentifier;
+ (NSString *)identifierWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
+ (AbstractTableViewCellType)cellTypeForTableView:(UITableView *)tableView
										indexPath:(NSIndexPath *) indexPath;
+ (CGRect)cellFrameWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
+ (CGRect)cellFrameWithContentHeight:(CGFloat)contentHeight
						   tableView:(UITableView *)tableView
						   indexPath:(NSIndexPath *)indexPath;
+ (CGPoint)originForTableView:(UITableView *)tableView;
+ (CGPoint)insetOriginForTableView:(UITableView *)tableView;
+ (CGFloat)insetWidthForTableView:(UITableView *)tableView withAccessoryType:(UITableViewCellAccessoryType)accessoryType;
+ (CGFloat)fontSizeForTableView:(UITableView *)tableView;

@end

#pragma mark -
#pragma mark AbstractTableViewCellView interface

@interface AbstractTableViewCellView : UIView {
	AbstractTableViewCell *_parentCell;
	BOOL _highlighted;
	NSString *_backImageTitle;
	NSString *_backImageSelectedTitle;
	CGFloat _fontSize;
}

@property (nonatomic, assign) AbstractTableViewCell *parentCell;
@property (nonatomic, copy) NSString *backImageTitle;
@property (nonatomic, copy) NSString *backImageSelectedTitle;
@property (nonatomic, assign) CGFloat fontSize;

- (id)initWithFrame:(CGRect)frame parentCell:(AbstractTableViewCell *)parentCell;
+ (UIImage *)imageNamed:(NSString *)name width:(CGFloat)width height:(CGFloat)height;

@end
