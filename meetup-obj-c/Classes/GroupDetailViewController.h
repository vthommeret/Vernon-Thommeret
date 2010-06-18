//
//  GroupDetailViewController.h
//  Meetup
//
//  Created by Vernon Thommeret on 8/13/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractTableViewController.h"
#import "DetailHeaderView.h"

@class Group, Comment, MeetupAsyncRequest;

/**
 A GroupDetailViewController is one of the main view controllers, responsible for
 displaying everything applicable to a group — its basic information, its description,
 a reference to its next meetup, calendar, members, and any photos, if available.
 */
@interface GroupDetailViewController : AbstractTableViewController <DetailHeaderViewDelegate> {
	Group *_group;
	Comment *_firstComment;
	MeetupAsyncRequest *_firstCommentRequest;
}

@property (nonatomic, retain) Group *group;
@property (nonatomic, retain) Comment *firstComment;
@property (nonatomic, retain) MeetupAsyncRequest *firstCommentRequest;

@end
