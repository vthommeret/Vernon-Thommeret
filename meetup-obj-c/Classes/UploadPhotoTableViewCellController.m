//
//  RootTableViewCellController.m
//  Tabletest
//
//  Created by Vernon Thommeret on 7/30/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import "UploadPhotoTableViewCellController.h"
#import "AbstractTableViewController.h"
#import "SingleLineTableViewCell.h"
#import "UploadPhotoViewController.h"

@implementation UploadPhotoTableViewCellController

@synthesize content = _content;

- (void) dealloc {
	[_content release];
	[super dealloc];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {	
	UploadPhotoViewController *uploadPhotoViewController = [[UploadPhotoViewController alloc] init];
	[self.navigationController pushViewController:uploadPhotoViewController animated:YES];
	[uploadPhotoViewController release];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *reuseIdentifier = [SingleLineTableViewCell identifierWithTableView:tableView indexPath:indexPath];
	
    SingleLineTableViewCell *cell = (SingleLineTableViewCell *) [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
	
    if (cell == nil) {
        cell = [[[SingleLineTableViewCell alloc] initWithTableView:tableView
														indexPath:indexPath
												  reuseIdentifier:reuseIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.icon = [UIImage imageNamed:@"camera.png"];
	}
	
	[cell prepareForReuseWithTableView:tableView indexPath:indexPath];
	
	cell.content = self.content;
	
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [SingleLineTableViewCell cellFrameWithTableView:tableView indexPath:indexPath].size.height;
}

@end
