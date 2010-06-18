//
//  MultiLineTableViewCellController.m
//  Meetup
//
//  Created by Vernon Thommeret on 8/13/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import "MultiLineTableViewCellController.h"
#import "AbstractTableViewController.h"
#import "MultiLineTableViewCell.h"
#import "TextDetailViewController.h"

@implementation MultiLineTableViewCellController

@synthesize content = _content;
@synthesize showFull = _showFull;

- (void) dealloc {
	[_content release];
	[super dealloc];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (!self.showFull) {
		TextDetailViewController *textDetailViewController = [[TextDetailViewController alloc]
															  initWithStyle:UITableViewStyleGrouped];
		textDetailViewController.text = self.content;
		textDetailViewController.title = self.key;
		[self.navigationController pushViewController:textDetailViewController animated:YES];
		[textDetailViewController release];
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *reuseIdentifier = [MultiLineTableViewCell identifierWithTableView:tableView indexPath:indexPath];
	
    MultiLineTableViewCell *cell = (MultiLineTableViewCell *) [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
	
    if (cell == nil) {
        cell = [[[MultiLineTableViewCell alloc] initWithTableView:tableView
													indexPath:indexPath
											  reuseIdentifier:reuseIdentifier] autorelease];
	}
	
//	[cell prepareForReuseWithTableView:tableView indexPath:indexPath];
	
	cell.showFull = self.showFull;
	cell.content = self.content;
	
	if (cell.showFull) {
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	} else {
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCellAccessoryType accessoryType = self.showFull ?
		UITableViewCellAccessoryNone : UITableViewCellAccessoryDisclosureIndicator;
	
	return [MultiLineTableViewCell cellFrameWithContent:self.content tableView:tableView indexPath:indexPath
										  accessoryType:accessoryType
											   showFull:self.showFull].size.height;
}

@end
