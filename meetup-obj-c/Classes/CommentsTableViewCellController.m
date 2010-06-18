//
//  CommentsTableViewCellController.m
//  Meetup
//
//  Created by Vernon Thommeret on 8/19/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import "CommentsTableViewCellController.h"
#import "AbstractTableViewController.h"
#import "SingleLineTableViewCell.h"
#import "CommentsDetailViewController.h"
#import "Group.h"

@implementation CommentsTableViewCellController

@synthesize group = _group;
@synthesize more = _more;

- (void) dealloc {
	[_group release];
	[super dealloc];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	CommentsDetailViewController *commentsDetailViewController = [[CommentsDetailViewController alloc]
																initWithStyle:UITableViewStylePlain];
	commentsDetailViewController.title = @"Comments";
	commentsDetailViewController.group = self.group;
	[self.navigationController pushViewController:commentsDetailViewController animated:YES];
	[commentsDetailViewController release];
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
	
	if (self.more) {
		cell.content = [NSString stringWithFormat:@"%d more comments", self.group.reviewCount - 1];
	} else {
		cell.content = [NSString stringWithFormat:@"%d comments", self.group.reviewCount];
	}
	
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [SingleLineTableViewCell cellFrameWithTableView:tableView indexPath:indexPath].size.height;
}

@end
