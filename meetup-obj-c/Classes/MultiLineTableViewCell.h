//
//  MultiLineTableViewCell.h
//  TableCommon
//
//  Created by Vernon Thommeret on 8/11/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractTableViewCell.h"

/**
 A multiline table view cell is responsible for displaying extended text. It can be configured
 to either truncate the content (displaying three lines of text), or to show the full content,
 which is more appropriate for a detail view.
 */
@interface MultiLineTableViewCell : AbstractTableViewCell {
	NSString *_content;
	BOOL _showFull;
}

@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) BOOL showFull;

+ (CGRect)cellFrameWithContent:(NSString *)content tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
				  accessoryType:(UITableViewCellAccessoryType)accessoryType showFull:(BOOL)showFull;

@end

#pragma mark -
#pragma mark MultiLineTableViewCellView interface

@interface MultiLineTableViewCellView : AbstractTableViewCellView {}

@end
