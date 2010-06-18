//
//  RootTableViewController.h
//  TableCommon
//
//  Created by Vernon Thommeret on 8/11/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractTableViewController.h"

@class MeetupAsyncRequest;
@class StatusView;

@interface YourEventsTableViewController : AbstractTableViewController {
	NSMutableArray *_yourEventControllers;
	MeetupAsyncRequest *_yourEventsRequest;
	StatusView *_statusView;
}

@property (nonatomic, retain) NSMutableArray *yourEventControllers;
@property (nonatomic, retain) MeetupAsyncRequest *yourEventsRequest;
@property (nonatomic, retain) StatusView *statusView;

- (void)requestYourEvents;

@end
