//
//  PhoneTableViewCellController.m
//  Meetup
//
//  Created by Vernon Thommeret on 8/17/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import "PhoneTableViewCellController.h"
#import "AbstractTableViewController.h"
#import "KeyedTableViewCell.h"

@implementation PhoneTableViewCellController

@synthesize phone = _phone;

- (void) dealloc {
	[_phone release];
	[super dealloc];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {	
	/*
	NSCharacterSet *badChars = [NSCharacterSet characterSetWithCharactersInString:@"()- "];
	NSString *phoneFormatted = [NSString stringWithFormat:@"tel://%@",
								[[self.phone componentsSeparatedByCharactersInSet:badChars] componentsJoinedByString:@""]];
	 */
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", self.phone]]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *reuseIdentifier = [KeyedTableViewCell identifierWithTableView:tableView indexPath:indexPath];
	
    KeyedTableViewCell *cell = (KeyedTableViewCell *) [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
	
    if (cell == nil) {
        cell = [[[KeyedTableViewCell alloc] initWithTableView:tableView
													indexPath:indexPath
											  reuseIdentifier:reuseIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	
	[cell prepareForReuseWithTableView:tableView indexPath:indexPath];
	
	cell.key = self.key;
	cell.content = self.phone;
	
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [KeyedTableViewCell cellFrameWithContent:self.phone tableView:tableView indexPath:indexPath
									  accessoryType:UITableViewCellAccessoryNone].size.height;
}

@end
