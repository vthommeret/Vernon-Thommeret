//
//  RootTableViewCellController.m
//  Tabletest
//
//  Created by Vernon Thommeret on 7/30/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import "GroupTableViewCellController.h"
#import "AbstractTableViewController.h"
#import "PhotoTableViewCell.h"
#import "GroupDetailViewController.h"
#import "Group.h"

@implementation GroupTableViewCellController

@synthesize group = _group;

- (void) dealloc {
	[_group release];
	[super dealloc];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {	
	GroupDetailViewController *groupDetailViewController = [[GroupDetailViewController alloc]
															initWithStyle:UITableViewStyleGrouped];
	groupDetailViewController.group = self.group;
	[self.navigationController pushViewController:groupDetailViewController animated:YES];
	[groupDetailViewController release];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *reuseIdentifier = [PhotoTableViewCell identifierWithTableView:tableView indexPath:indexPath];
	
    PhotoTableViewCell *cell = (PhotoTableViewCell *) [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
	
    if (cell == nil) {
        cell = [[[PhotoTableViewCell alloc] initWithTableView:tableView
														indexPath:indexPath
												  reuseIdentifier:reuseIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.defaultImage = @"groupDefault";
	}
	
	[cell prepareForReuseWithTableView:tableView indexPath:indexPath];
	
	cell.photoUrl = self.group.photoUrl;
	cell.content = self.group.name;
	
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [PhotoTableViewCell cellFrameWithTableView:tableView indexPath:indexPath].size.height;
}

@end
