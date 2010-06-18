//
//  PhotosTableViewCellController.m
//  Meetup
//
//  Created by Vernon Thommeret on 8/19/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import "PhotosTableViewCellController.h"
#import "AbstractTableViewController.h"
#import "SingleLineTableViewCell.h"
#import "PhotoDetailViewController.h"
#import "Group.h"

@implementation PhotosTableViewCellController

@synthesize group = _group;

- (void) dealloc {
	[_group release];
	[super dealloc];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	PhotoDetailViewController *photoDetailViewController = [[PhotoDetailViewController alloc] init];
	photoDetailViewController.group = self.group;
	[self.navigationController pushViewController:photoDetailViewController animated:YES];
	[photoDetailViewController release];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *reuseIdentifier = [SingleLineTableViewCell identifierWithTableView:tableView indexPath:indexPath];
	
    SingleLineTableViewCell *cell = (SingleLineTableViewCell *) [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
	
    if (cell == nil) {
        cell = [[[SingleLineTableViewCell alloc] initWithTableView:tableView
														 indexPath:indexPath
												   reuseIdentifier:reuseIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
	[cell prepareForReuseWithTableView:tableView indexPath:indexPath];
	
	cell.content = [NSString stringWithFormat:@"%d photos", self.group.photoCount];
	
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [SingleLineTableViewCell cellFrameWithTableView:tableView indexPath:indexPath].size.height;
}

@end
