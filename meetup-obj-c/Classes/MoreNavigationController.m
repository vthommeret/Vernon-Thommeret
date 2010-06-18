//
//  MoreNavigationController.m
//  Meetup
//
//  Created by Vernon Thommeret on 8/12/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import "MoreNavigationController.h"
#import "MoreRootTableViewController.h"
#import "State.h"

@implementation MoreNavigationController

@synthesize navController = _navController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		self.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemMore tag:kMoreTab];
    }
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	MoreRootTableViewController *moreRootViewController = [[MoreRootTableViewController alloc]
														   initWithStyle:UITableViewStyleGrouped];

	UINavigationController *navController = [[UINavigationController alloc]
											 initWithRootViewController:moreRootViewController];
	[moreRootViewController release];
	
	navController.navigationBar.tintColor = [State sharedState].meetupColor;
	[self.view addSubview:navController.view];
	
	self.navController = navController;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.navController viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self.navController viewDidAppear:animated];
}

- (void)dealloc {
	[_navController release];
    [super dealloc];
}

@end
