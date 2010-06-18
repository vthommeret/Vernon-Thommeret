//
//  GroupsRootTableViewController.h
//  Meetup
//
//  Created by Vernon Thommeret on 8/13/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractTableViewController.h"

@class MeetupAsyncRequest;
@class StatusView;

@interface GroupsRootTableViewController : AbstractTableViewController {
	NSMutableArray *_organizedGroupControllers;
	NSMutableArray *_moreGroupControllers;
	MeetupAsyncRequest *_groupsRequest;
	StatusView *_statusView;
}

@property (nonatomic, retain) NSMutableArray *organizedGroupControllers;
@property (nonatomic, retain) NSMutableArray *moreGroupControllers;
@property (nonatomic, retain) MeetupAsyncRequest *groupsRequest;
@property (nonatomic, retain) StatusView *statusView;

- (void) requestGroups;

@end
