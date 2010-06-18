//
//  SettingsTableViewCellController.m
//  Meetup
//
//  Created by Vernon Thommeret on 8/14/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import "SettingsTableViewCellController.h"
#import "AbstractTableViewController.h"
#import "SingleLineTableViewCell.h"
#import "SettingsViewController.h"

@implementation SettingsTableViewCellController

@synthesize content = _content;

- (void) dealloc {
	[_content release];
	[super dealloc];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {	
	SettingsViewController *settingsViewController = [[SettingsViewController alloc] init];
	[self.navigationController pushViewController:settingsViewController animated:YES];
	[settingsViewController release];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *reuseIdentifier = [SingleLineTableViewCell identifierWithTableView:tableView indexPath:indexPath];
	
    SingleLineTableViewCell *cell = (SingleLineTableViewCell *) [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
	
    if (cell == nil) {
        cell = [[[SingleLineTableViewCell alloc] initWithTableView:tableView
														 indexPath:indexPath
												   reuseIdentifier:reuseIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.icon = [UIImage imageNamed:@"settings.png"];
	}
	
	[cell prepareForReuseWithTableView:tableView indexPath:indexPath];
	
	cell.content = self.content;
	
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [SingleLineTableViewCell cellFrameWithTableView:tableView indexPath:indexPath].size.height;
}

@end
