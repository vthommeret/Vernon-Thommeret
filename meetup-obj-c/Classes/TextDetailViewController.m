//
//  TextDetailViewController.m
//  Meetup
//
//  Created by Vernon Thommeret on 8/14/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import "TextDetailViewController.h"
#import "MultiLineTableViewCellController.h"

@implementation TextDetailViewController

@synthesize text = _text;

- (void)constructTableItems {
	MultiLineTableViewCellController *textController = [[MultiLineTableViewCellController alloc] init];
	textController.navigationController = self.navigationController;
	textController.content = self.text;
	textController.showFull = YES;
	
	self.tableItems = [NSArray arrayWithObject:[NSArray arrayWithObject:textController]];
	
	[textController release];
}

- (void)dealloc {
	[_text release];
    [super dealloc];
}


@end
