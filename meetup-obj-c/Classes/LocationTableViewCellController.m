//
//  LocationTableViewCellController.m
//  Meetup
//
//  Created by Vernon Thommeret on 8/17/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import "LocationTableViewCellController.h"
#import "AbstractTableViewController.h"
#import "KeyedTableViewCell.h"
#import "LocationDetailViewController.h"
#import "Location.h"

@implementation LocationTableViewCellController

@synthesize location = _location;

- (void) dealloc {
	[_location release];
	[super dealloc];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {	
	LocationDetailViewController *locationDetailViewController = [[LocationDetailViewController alloc]
																  initWithLocation:self.location];
	[self.navigationController pushViewController:locationDetailViewController animated:YES];
	[locationDetailViewController release];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *reuseIdentifier = [KeyedTableViewCell identifierWithTableView:tableView indexPath:indexPath];
	
    KeyedTableViewCell *cell = (KeyedTableViewCell *) [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
	
    if (cell == nil) {
        cell = [[[KeyedTableViewCell alloc] initWithTableView:tableView
													indexPath:indexPath
											  reuseIdentifier:reuseIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
	[cell prepareForReuseWithTableView:tableView indexPath:indexPath];
	
	cell.key = self.key;
	cell.content = self.location.description;
	
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [KeyedTableViewCell cellFrameWithContent:self.location.description tableView:tableView indexPath:indexPath
										  accessoryType:UITableViewCellAccessoryDisclosureIndicator].size.height;
}

@end
