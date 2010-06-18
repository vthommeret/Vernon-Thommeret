//
//  AboutRootViewController.m
//  Meetup
//
//  Created by Vernon Thommeret on 8/13/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import "AboutRootViewController.h"
#import "State.h"

@implementation AboutRootViewController

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.view.backgroundColor = [State sharedState].grayBackgroundColor;
	
	UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain
															target:self action:@selector(done:)];
	self.navigationItem.rightBarButtonItem = done;
	[done release];
	
	self.title = @"About";
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)done:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}

- (void)dealloc {
    [super dealloc];
}


@end
