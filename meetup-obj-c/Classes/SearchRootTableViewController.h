//
//  SearchRootTableViewController.h
//  Meetup
//
//  Created by Vernon Thommeret on 8/13/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractTableViewController.h"

@class MeetupAsyncRequest;
@class SearchOverlayView;
@class StatusView;

@interface SearchRootTableViewController : AbstractTableViewController <UISearchBarDelegate> {
	NSMutableArray *_groupControllers;
	MeetupAsyncRequest *_searchRequest;
	SearchOverlayView *_searchOverlay;
	StatusView *_statusView;
}

@property (nonatomic, retain) NSMutableArray *groupControllers;
@property (nonatomic, retain) MeetupAsyncRequest *searchRequest;
@property (nonatomic, retain) SearchOverlayView *searchOverlay;
@property (nonatomic, retain) StatusView *statusView;

@end
