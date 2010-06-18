//
//  GroupProfileTableViewCellController.m
//  Meetup
//
//  Created by Vernon Thommeret on 8/24/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import "GroupProfileTableViewCellController.h"
#import "AbstractTableViewController.h"
#import "PhotoTableViewCell.h"
#import "UserDetailViewController.h"
#import "User.h"

@implementation GroupProfileTableViewCellController

@synthesize user = _user;
@synthesize group = _group;

- (void) dealloc {
	[_user release];
	[_group release];
	[super dealloc];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {	
	UserDetailViewController *userDetailViewController = [[UserDetailViewController alloc]
														  initWithStyle:UITableViewStyleGrouped];
	userDetailViewController.user = self.user;
	userDetailViewController.group = self.group;
	[self.navigationController pushViewController:userDetailViewController animated:YES];
	[userDetailViewController release];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *reuseIdentifier = [PhotoTableViewCell identifierWithTableView:tableView indexPath:indexPath];
	
    PhotoTableViewCell *cell = (PhotoTableViewCell *) [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
	
    if (cell == nil) {
        cell = [[[PhotoTableViewCell alloc] initWithTableView:tableView
													indexPath:indexPath
											  reuseIdentifier:reuseIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.defaultImage = @"userDefault";
	}
	
	[cell prepareForReuseWithTableView:tableView indexPath:indexPath];
	
	cell.photoUrl = self.user.photoUrl;
	cell.content = self.user.name;
	
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [PhotoTableViewCell cellFrameWithTableView:tableView indexPath:indexPath].size.height;
}

@end
