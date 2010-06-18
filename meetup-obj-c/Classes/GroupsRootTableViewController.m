//
//  GroupsRootTableViewController.m
//  Meetup
//
//  Created by Vernon Thommeret on 8/13/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import "GroupsRootTableViewController.h"
#import "GroupTableViewCellController.h"
#import "StatusView.h"
#import "MeetupAsyncRequest.h"
#import "User.h"
#import "Group.h"

#import "State.h"

@implementation GroupsRootTableViewController

@synthesize organizedGroupControllers = _organizedGroupControllers;
@synthesize moreGroupControllers = _moreGroupControllers;
@synthesize groupsRequest = _groupsRequest;
@synthesize statusView = _statusView;

- (void)viewDidLoad {
    [super viewDidLoad];
	
	if ([State sharedState].user == nil) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestGroups) name:@"AppDelegateDidReceiveUserData" object:nil];
	} else {
		[self requestGroups];
	}
	
	self.title = @"Groups";
}

- (void)requestGroups {
	// show loading overlay
	
	StatusViewItem *loading = [[StatusViewItem alloc] initWithText:@"Loading Your Groups…"];
	
	StatusView *statusView = [[StatusView alloc] initWithFrame:self.tableView.frame
														 style:StatusViewStyleScreen
												statusViewItem:loading];
	[loading release];
	
	[self.view addSubview:statusView];
	
	self.statusView = statusView;
	[statusView release];
	
	// request groups
	
	NSInteger userId = [State sharedState].user.userId;
	
	MeetupAsyncRequest *groupsRequest = [[MeetupAsyncRequest alloc] init];
	groupsRequest.delegate = self;
	groupsRequest.callback = @selector(didReceiveGroups:);
	[groupsRequest doMethod:@"groups" withParams:[NSString stringWithFormat:@"member_id=%d", userId]];
	
	self.groupsRequest = groupsRequest;
	[groupsRequest release];
}

- (void)didReceiveGroups:(NSDictionary *)response {
	[_groupsRequest release];
	_groupsRequest = nil;
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"AppDelegateDidReceiveUserData" object:nil];
	
	NSDictionary *groupsResult = [response objectForKey:@"results"];
	
	// set up model and cell controllers
	
	NSMutableArray *organizedGroupControllers = [[NSMutableArray alloc] initWithCapacity:15];
	NSMutableArray *moreGroupControllers = [[NSMutableArray alloc] initWithCapacity:15];
	
	for (NSDictionary *groupResult in groupsResult) {
		Group *group = [[Group alloc] initWithResponseObject:groupResult];
		
		GroupTableViewCellController *groupCellController = [[GroupTableViewCellController alloc] init];
		groupCellController.navigationController = self.navigationController;
		groupCellController.group = group;
		[group release];
		
		if ([[groupResult objectForKey:@"organizer_id"] intValue] == [State sharedState].user.userId) {
			[organizedGroupControllers addObject:groupCellController];
		} else {
			[moreGroupControllers addObject:groupCellController];
		}
		
		[groupCellController release];
	}
	
	self.organizedGroupControllers = organizedGroupControllers;
	self.moreGroupControllers = moreGroupControllers;
	[organizedGroupControllers release];
	[moreGroupControllers release];
	
	[self updateAndReload];
	
	[_statusView removeFromSuperview];
	[_statusView release];
	_statusView = nil;
	
	[self viewDidAppear:NO];
}

- (void)constructTableItems {
	NSMutableArray *tableHeaders;
	NSMutableArray *tableItems;
	
	// don't show headers if the user doesn't organize any groups
	if ([self.organizedGroupControllers count] == 0) {
		tableHeaders = nil;
		tableItems = [[NSArray alloc] initWithObjects:self.moreGroupControllers, nil];
	} else {
		tableHeaders = [[NSArray alloc] initWithObjects:@"Groups You Organize", @"More Groups", nil];
		tableItems = [[NSArray alloc] initWithObjects:self.organizedGroupControllers, self.moreGroupControllers, nil];
	}
	
	self.tableHeaders = tableHeaders;
	self.tableItems = tableItems;
	
	[tableHeaders release];
	[tableItems release];
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"AppDelegateDidReceiveUserData" object:nil];
	[_organizedGroupControllers release];
	[_moreGroupControllers release];
	[_groupsRequest release];
	[_statusView release];
    [super dealloc];
}

@end
