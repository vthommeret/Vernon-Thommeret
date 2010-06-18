//
//  RsvpsTableViewCellController.m
//  Meetup
//
//  Created by Vernon Thommeret on 8/17/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import "RsvpsTableViewCellController.h"
#import "AbstractTableViewController.h"
#import "RsvpsTableViewCell.h"
#import "RsvpsDetailViewController.h"
#import "Event.h"

@implementation RsvpsTableViewCellController

@synthesize event = _event;

- (void) dealloc {
	[_event release];
	[super dealloc];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {	
	RsvpsDetailViewController *rsvpDetailViewController = [[RsvpsDetailViewController alloc]
															initWithStyle:UITableViewStylePlain];
	rsvpDetailViewController.event = self.event;
	[self.navigationController pushViewController:rsvpDetailViewController animated:YES];
	[rsvpDetailViewController release];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *reuseIdentifier = [RsvpsTableViewCell identifierWithTableView:tableView indexPath:indexPath];
	
    RsvpsTableViewCell *cell = (RsvpsTableViewCell *) [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
	
    if (cell == nil) {
        cell = [[[RsvpsTableViewCell alloc] initWithTableView:tableView
													indexPath:indexPath
											  reuseIdentifier:reuseIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
	[cell prepareForReuseWithTableView:tableView indexPath:indexPath];
	
	cell.event = self.event;
	
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [RsvpsTableViewCell cellFrameWithTableView:tableView indexPath:indexPath].size.height;
}

@end
