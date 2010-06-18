//
//  SearchNavigationController.m
//  Meetup
//
//  Created by Vernon Thommeret on 8/12/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import "SearchNavigationController.h"
#import "SearchRootTableViewController.h"
#import "State.h"

@implementation SearchNavigationController

@synthesize navController = _navController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		self.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemSearch tag:kSearchTab];
    }
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	SearchRootTableViewController *searchRootTableViewController = [[SearchRootTableViewController alloc]
																	initWithStyle:UITableViewStylePlain];
	
	UINavigationController *navController = [[UINavigationController alloc]
											 initWithRootViewController:searchRootTableViewController];
	[searchRootTableViewController release];
	
	navController.navigationBar.tintColor = [State sharedState].meetupColor;
	[self.view addSubview:navController.view];
	
	self.navController = navController;
	[navController release];
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
