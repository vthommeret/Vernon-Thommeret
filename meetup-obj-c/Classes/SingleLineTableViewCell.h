//
//  SingleLineTableViewCell.h
//  TableCommon
//
//  Created by Vernon Thommeret on 8/11/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractTableViewCell.h"

/**
 A SingleLineTableViewCell is responsible for displaying a single line text and
 optionally a 29x29 icon. If an icon is specified, the text will be shifted over
 to make room for the icon. This cell essentially mirrors the display of the standard
 iPhone table view cell. Use it for displaying simple, single-line pieces of text.
 */
@interface SingleLineTableViewCell : AbstractTableViewCell {
	NSString *_content;
	UIImage *_icon;
}

@property (nonatomic, copy) NSString *content;
@property (nonatomic, retain) UIImage *icon;

@end

#pragma mark -
#pragma mark SingleLineTableViewCellView interface

@interface SingleLineTableViewCellView : AbstractTableViewCellView {}

@end
