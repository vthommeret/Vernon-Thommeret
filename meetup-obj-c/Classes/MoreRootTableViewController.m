//
//  RootTableViewController.m
//  TableCommon
//
//  Created by Vernon Thommeret on 8/11/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import "MoreRootTableViewController.h"
#import "UploadPhotoTableViewCellController.h"
#import "SettingsTableViewCellController.h"
#import "BlogTableViewCellController.h"
#import "AboutNavigationController.h"
#import "State.h"

@implementation MoreRootTableViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	UIBarButtonItem *signOut = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out"
																style:UIBarButtonItemStylePlain
															   target:self action:@selector(signOut:)];
	self.navigationItem.leftBarButtonItem = signOut;
	[signOut release];
	
	UIBarButtonItem *about = [[UIBarButtonItem alloc] initWithTitle:@"About"
																style:UIBarButtonItemStylePlain
															   target:self action:@selector(about:)];
	self.navigationItem.rightBarButtonItem = about;
	[about release];
	 
	self.title = @"More";
}

- (void)signOut:(id)sender {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sign out" message:@"Are you sure you want to sign out"
												   delegate:nil cancelButtonTitle:@"Yes" otherButtonTitles:nil];
	[alert show];
	[alert release];
}

- (void)about:(id)sender {
	AboutNavigationController *aboutNavigationController = [[AboutNavigationController alloc] initWithNibName:nil bundle:nil];
	[self presentModalViewController:aboutNavigationController animated:YES];
	[aboutNavigationController release];
}

- (void)constructTableItems {
	UploadPhotoTableViewCellController *uploadPhoto = [[UploadPhotoTableViewCellController alloc] init];
	uploadPhoto.navigationController = self.navigationController;
	uploadPhoto.content = @"Upload a Photo";
	
	SettingsTableViewCellController *settings = [[SettingsTableViewCellController alloc] init];
	settings.navigationController = self.navigationController;
	settings.content = @"Settings";
	
	BlogTableViewCellController *blog = [[BlogTableViewCellController alloc] init];
	blog.navigationController = self.navigationController;
	blog.content = @"Meetup Blog";	
	
	NSMutableArray *tableItems = [[NSMutableArray alloc] initWithObjects:
								  [NSMutableArray arrayWithObjects:uploadPhoto, nil],
								  [NSMutableArray arrayWithObjects:settings, blog, nil],
								  nil];
	self.tableItems = tableItems;
	[tableItems release];
	
	[uploadPhoto release];
	[settings release];
	[blog release];
	
}

@end
