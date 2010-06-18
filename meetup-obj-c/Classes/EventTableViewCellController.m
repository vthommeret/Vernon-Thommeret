//
//  RootTableViewCellController.m
//  Tabletest
//
//  Created by Vernon Thommeret on 7/30/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import "EventTableViewCellController.h"
#import "AbstractTableViewController.h"
#import "PhotoTableViewCell.h"
#import "EventDetailViewController.h"
#import "Event.h"

@implementation EventTableViewCellController

@synthesize event = _event;

- (void) dealloc {
	[_event release];
	[super dealloc];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	EventDetailViewController *eventDetailViewController = [[EventDetailViewController alloc]
															initWithStyle:UITableViewStyleGrouped];
	eventDetailViewController.event = self.event;
	[self.navigationController pushViewController:eventDetailViewController animated:YES];
	[eventDetailViewController release];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *reuseIdentifier = [PhotoTableViewCell identifierWithTableView:tableView indexPath:indexPath];
	
    PhotoTableViewCell *cell = (PhotoTableViewCell *) [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
	
    if (cell == nil) {
        cell = [[[PhotoTableViewCell alloc] initWithTableView:tableView
													indexPath:indexPath
											  reuseIdentifier:reuseIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.defaultImage = @"eventDefault";
	}
	
	[cell prepareForReuseWithTableView:tableView indexPath:indexPath];
	
	cell.photoUrl = self.event.photoUrl;
	cell.content = self.event.name;
	
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [PhotoTableViewCell cellFrameWithTableView:tableView indexPath:indexPath].size.height;
}

@end
