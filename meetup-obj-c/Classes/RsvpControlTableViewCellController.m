//
//  RsvpControlTableViewCellController.m
//  Meetup
//
//  Created by Vernon Thommeret on 8/25/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import "RsvpControlTableViewCellController.h"
#import "AbstractTableViewController.h"
#import "RsvpControlTableViewCell.h"
#import "RsvpsDetailViewController.h"
#import "Event.h"

@implementation RsvpControlTableViewCellController

@synthesize event = _event;

- (void) dealloc {
	[_event release];
	[super dealloc];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *reuseIdentifier = [RsvpControlTableViewCell identifierWithTableView:tableView indexPath:indexPath];
	
    RsvpControlTableViewCell *cell = (RsvpControlTableViewCell *) [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
	
    if (cell == nil) {
        cell = [[[RsvpControlTableViewCell alloc] initWithTableView:tableView
													indexPath:indexPath
											  reuseIdentifier:reuseIdentifier] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	[cell prepareForReuseWithTableView:tableView indexPath:indexPath];
	
	cell.event = self.event;
	
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [RsvpControlTableViewCell cellFrameWithTableView:tableView indexPath:indexPath].size.height;
}

@end
