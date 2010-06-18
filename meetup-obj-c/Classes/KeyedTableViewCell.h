//
//  KeyedTableViewCell.h
//  Meetup
//
//  Created by Vernon Thommeret on 8/17/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractTableViewCell.h"

/**
 A keyed table view cell is responsible for displaying multiline text along with a label, or key. Visually, it
 mirrors the look of contact information in the default Contacts application.
 */
@interface KeyedTableViewCell : AbstractTableViewCell {
	NSString *_content;
}

@property (nonatomic, copy) NSString *content;

+ (CGRect)cellFrameWithContent:(NSString *)content tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
				 accessoryType:(UITableViewCellAccessoryType)accessoryType;

@end

#pragma mark -
#pragma mark MultiLineTableViewCellView interface

@interface KeyedTableViewCellView : AbstractTableViewCellView {}

@end
