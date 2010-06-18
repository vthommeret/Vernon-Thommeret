//
//  AbstractTableViewCellController.m
//  Meetup
//
//  Created by Vernon Thommeret on 8/13/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import "AbstractTableViewCellController.h"

@implementation AbstractTableViewCellController

@synthesize navigationController = _navigationController;
@synthesize key = _key;

- (void)dealloc {
	[_key release];
	[super dealloc];
}

@end
