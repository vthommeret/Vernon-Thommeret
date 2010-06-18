//
//  CommentsDetailViewController.h
//  Meetup
//
//  Created by Vernon Thommeret on 8/19/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractTableViewController.h"

@class Group;
@class MeetupAsyncRequest;
@class StatusView;

/**
 A CommentsDetailViewController is responsible for displaying the comments of a group.
 */
@interface CommentsDetailViewController : AbstractTableViewController {
	NSMutableArray *_commentControllers;
	Group *_group;
	MeetupAsyncRequest *_commentsRequest;
	StatusView *_statusView;
}

@property (nonatomic, retain) NSMutableArray *commentControllers;
@property (nonatomic, retain) Group *group;
@property (nonatomic, retain) MeetupAsyncRequest *commentsRequest;
@property (nonatomic, retain) StatusView *statusView;

@end
