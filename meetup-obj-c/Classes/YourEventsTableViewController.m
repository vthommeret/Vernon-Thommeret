//
//  RootTableViewController.m
//  TableCommon
//
//  Created by Vernon Thommeret on 8/11/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import "YourEventsTableViewController.h"
#import "EventTableViewCellController.h"
#import "StatusView.h"
#import "Event.h"
#import "User.h"
#import "Location.h"
#import "MeetupAsyncRequest.h"
#import "State.h"

@implementation YourEventsTableViewController

@synthesize yourEventControllers = _yourEventControllers;
@synthesize yourEventsRequest = _yourEventsRequest;
@synthesize statusView = _statusView;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	if ([State sharedState].user == nil) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestYourEvents)
													 name:@"AppDelegateDidReceiveUserData" object:nil];
	} else {
		[self requestYourEvents];
	}
}

- (void)requestYourEvents {
	// show loading overlay
	
	StatusViewItem *loading = [[StatusViewItem alloc] initWithText:@"Loading Your Events…"];
	
	StatusView *statusView = [[StatusView alloc] initWithFrame:self.view.frame
														 style:StatusViewStyleScreen
												statusViewItem:loading];
	[loading release];
	
	[self.view addSubview:statusView];
	
	self.statusView = statusView;
	[statusView release];
	
	// request groups
	
	NSInteger userId = [State sharedState].user.userId;
	
	MeetupAsyncRequest *yourEventsRequest = [[MeetupAsyncRequest alloc] init];
	yourEventsRequest.delegate = self;
	yourEventsRequest.callback = @selector(didReceiveYourEvents:);
	[yourEventsRequest doMethod:@"events" withParams:[NSString stringWithFormat:@"member_id=%d&order=time", userId]];
	
	self.yourEventsRequest = yourEventsRequest;
	[yourEventsRequest release];
}

- (void)didReceiveYourEvents:(NSDictionary *)response {
	[_yourEventsRequest release];
	_yourEventsRequest = nil;
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"AppDelegateDidReceiveUserData" object:nil];
	
	NSDictionary *yourEventsResults = [response objectForKey:@"results"];
	
	// set up model and cell controllers
	
	NSMutableArray *yourEventControllers = [[NSMutableArray alloc] initWithCapacity:15];
	
	for (NSDictionary *eventResult in yourEventsResults) {		
		Event *event = [[Event alloc] initWithResponseObject:eventResult];
		
		EventTableViewCellController *eventCellController = [[EventTableViewCellController alloc] init];
		eventCellController.navigationController = self.parentController.navigationController;
		eventCellController.event = event;
		[event release];
		
		[yourEventControllers addObject:eventCellController];

		[eventCellController release];
	}
	
	self.yourEventControllers = yourEventControllers;
	[yourEventControllers release];
	
	[self updateAndReload];
	
	[_statusView removeFromSuperview];
	[_statusView release];
	_statusView = nil;
	
	[self viewDidAppear:NO];
}

- (void)constructTableItems {
	NSMutableArray *yourEventControllers = self.yourEventControllers;
	
	if (yourEventControllers != nil) {
		NSMutableArray *tableHeaders = [[NSMutableArray alloc] initWithCapacity:5];
		NSMutableArray *tableItems = [[NSMutableArray alloc] initWithCapacity:5];

		
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:kShortDate];
		for (EventTableViewCellController *eventController in yourEventControllers) {
			NSDate *date = eventController.event.date;
			
			NSString *dateString;
			if ([date isEqualToDate:[NSDate date]]) {
				dateString = @"Today";
			} else {
				dateString = [dateFormatter stringFromDate:eventController.event.date];
			}

			if (![[tableHeaders lastObject] isEqual:dateString]) {
				[tableHeaders addObject:dateString];
				
				NSMutableArray *dayEvents = [[NSMutableArray alloc] initWithObjects:eventController, nil];
				[tableItems addObject:dayEvents];
				[dayEvents release];
			} else {
				[[tableItems lastObject] addObject:eventController];
			}
		}
		[dateFormatter release];
		
		self.tableHeaders = tableHeaders;
		self.tableItems = tableItems;
		
		[tableHeaders release];
		[tableItems release];
	}
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"AppDelegateDidReceiveUserData" object:nil];
	[_yourEventControllers release];
	[_yourEventsRequest release];
	[_statusView release];
	[super dealloc];
}

@end
