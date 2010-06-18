//
//  MembersTableViewCellController.m
//  Meetup
//
//  Created by Vernon Thommeret on 8/17/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import "MembersTableViewCellController.h"
#import "AbstractTableViewController.h"
#import "SingleLineTableViewCell.h"
#import "MembersDetailViewController.h"
#import "Group.h"

@implementation MembersTableViewCellController

@synthesize group = _group;

- (void) dealloc {
	[_group release];
	[super dealloc];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	MembersDetailViewController *membersDetailViewController = [[MembersDetailViewController alloc]
														  initWithStyle:UITableViewStylePlain];
	membersDetailViewController.title = @"Members";
	membersDetailViewController.group = self.group;
	[self.navigationController pushViewController:membersDetailViewController animated:YES];
	[membersDetailViewController release];
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
	
	cell.content = [self.group membersDescription];
	
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [SingleLineTableViewCell cellFrameWithTableView:tableView indexPath:indexPath].size.height;
}

@end
