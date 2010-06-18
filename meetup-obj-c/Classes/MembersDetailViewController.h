//
//  MembersDetailViewController.h
//  Meetup
//
//  Created by Vernon Thommeret on 8/18/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Three20/Three20.h>
#import "AbstractTableViewController.h"

@class Group;
@class MeetupAsyncRequest;
@class StatusView;

/**
 A MembersDetailViewController is responsible for displaying the members in a group.
 */
@interface MembersDetailViewController : AbstractTableViewController <TTURLRequestDelegate> {
	NSMutableArray *_memberControllers;
	Group *_group;
	MeetupAsyncRequest *_membersRequest;
	StatusView *_statusView;
}

@property (nonatomic, retain) NSMutableArray *memberControllers;
@property (nonatomic, retain) Group *group;
@property (nonatomic, retain) MeetupAsyncRequest *membersRequest;
@property (nonatomic, retain) StatusView *statusView;

@end
