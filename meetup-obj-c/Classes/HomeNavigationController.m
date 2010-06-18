//
//  HomeNavigationController.m
//  Meetup
//
//  Created by Vernon Thommeret on 8/12/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import "HomeNavigationController.h"
#import "HomeRootViewController.h"
#import "State.h"

@implementation HomeNavigationController

@synthesize navController = _navController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		self.tabBarItem.tag = kHomeTab;
		self.tabBarItem.image = [UIImage imageNamed:@"home.png"];
		self.title = @"Home";
    }
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

	HomeRootViewController *homeRootViewController = [[HomeRootViewController alloc]
												  initWithNibName:nil bundle:nil];
	
	UINavigationController *navController = [[UINavigationController alloc]
											 initWithRootViewController:homeRootViewController];
	[homeRootViewController release];
	
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
