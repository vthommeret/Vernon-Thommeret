//
//  RsvpsDetailViewController.m
//  Meetup
//
//  Created by Vernon Thommeret on 8/18/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import "RsvpsDetailViewController.h"
#import "RsvpTableViewCellController.h"
#import "MeetupAsyncRequest.h"
#import "StatusView.h"
#import "Event.h"
#import "Rsvp.h"
#import "State.h"

@implementation RsvpsDetailViewController

@synthesize rsvpControllers = _rsvpControllers;
@synthesize event = _event;
@synthesize rsvpsRequest = _rsvpsRequest;
@synthesize statusView = _statusView;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"Who's coming?";
	
	// show loading overlay
	
	StatusViewItem *loading = [[StatusViewItem alloc] initWithText:@"Loading RSVPs…"];
	
	StatusView *statusView = [[StatusView alloc] initWithFrame:self.view.frame
														 style:StatusViewStyleScreen
												statusViewItem:loading];
	[loading release];
	
	[self.view addSubview:statusView];
	
	self.statusView = statusView;
	[statusView release];
	
	// request groups
	
	MeetupAsyncRequest *rsvpsRequest = [[MeetupAsyncRequest alloc] init];
	rsvpsRequest.delegate = self;
	rsvpsRequest.callback = @selector(didReceiveRsvps:);
	[rsvpsRequest doMethod:@"rsvps" withParams:[NSString stringWithFormat:@"event_id=%d", self.event.eventId]];
	
	self.rsvpsRequest = rsvpsRequest;
	[rsvpsRequest release];
}

- (void)didReceiveRsvps:(NSDictionary *)response {
	[_rsvpsRequest release];
	_rsvpsRequest = nil;
	
	NSDictionary *rsvpResults = [response objectForKey:@"results"];
	
	// set up model and cell controllers
	
	NSMutableArray *rsvpControllers = [[NSMutableArray alloc] initWithCapacity:25];
	
	for (NSDictionary *rsvpResult in rsvpResults) {		
		Rsvp *rsvp = [[Rsvp alloc] initWithResponseObject:rsvpResult];
		
		RsvpTableViewCellController *rsvpCellController = [[RsvpTableViewCellController alloc] init];
		rsvpCellController.navigationController = self.navigationController;
		rsvpCellController.rsvp = rsvp;
		[rsvp release];
		
		[rsvpControllers addObject:rsvpCellController];
		
		[rsvpCellController release];
	}
	
	self.rsvpControllers = rsvpControllers;
	[rsvpControllers release];
	
	[self updateAndReload];
	
	[_statusView removeFromSuperview];
	[_statusView release];
	_statusView = nil;
	
	[self viewDidAppear:NO];
}


- (void)constructTableItems {
	NSMutableArray *tableHeaders = [[NSMutableArray alloc] initWithCapacity:3];
	NSMutableArray *tableItems = [[NSMutableArray alloc] initWithCapacity:3];
	
	NSMutableArray *yes = [[NSMutableArray alloc] initWithCapacity:15];
	NSMutableArray *maybe = [[NSMutableArray alloc] initWithCapacity:15];
	NSMutableArray *no = [[NSMutableArray alloc] initWithCapacity:15];
	
	for (RsvpTableViewCellController *rsvpController in self.rsvpControllers) {
		if (rsvpController.rsvp.response == RsvpResponseYes) {
			[yes addObject:rsvpController];
		} else if (rsvpController.rsvp.response == RsvpResponseMaybe) {
			[maybe addObject:rsvpController];
		} else if (rsvpController.rsvp.response == RsvpResponseNo) {
			[no addObject:rsvpController];
		}
	}
	
	if ([yes count] != 0) {
		[tableHeaders addObject:@"Yes"];
		[tableItems addObject:yes];
	}
	[yes release];
	
	if ([maybe count] != 0) {
		[tableHeaders addObject:@"Maybe"];
		[tableItems addObject:maybe];
	}
	[maybe release];
	
	if ([no count] != 0) {
		[tableHeaders addObject:@"No"];
		[tableItems addObject:no];
	}
	[no release];
	
	self.tableHeaders = tableHeaders;
	self.tableItems = tableItems;
	 
	[tableHeaders release];
	[tableItems release];
}

- (void)dealloc {
	[_rsvpControllers release];
	[_event release];
	[_rsvpsRequest release];
	[_statusView release];
    [super dealloc];
}

@end
