//
//  AboutViewController.m
//  Meetup
//
//  Created by Vernon Thommeret on 8/13/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import "AboutNavigationController.h"
#import "AboutRootViewController.h"
#import "State.h"

@implementation AboutNavigationController

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationBar.tintColor = [State sharedState].meetupColor;
	
	AboutRootViewController *aboutRootViewController = [[AboutRootViewController alloc] initWithNibName:nil bundle:nil];
	[self pushViewController:aboutRootViewController animated:NO];
	[aboutRootViewController release];
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [super dealloc];
}

@end
