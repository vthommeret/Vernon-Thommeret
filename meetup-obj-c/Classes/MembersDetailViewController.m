//
//  MembersDetailViewController.m
//  Meetup
//
//  Created by Vernon Thommeret on 8/18/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import "MembersDetailViewController.h"
#import "GroupProfileTableViewCellController.h"
#import "MeetupAsyncRequest.h"
#import "StatusView.h"
#import "Group.h"
#import "User.h"
#import "State.h"

@implementation MembersDetailViewController

@synthesize memberControllers = _memberControllers;
@synthesize group = _group;
@synthesize membersRequest = _membersRequest;
@synthesize statusView = _statusView;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	// show loading overlay
	
	StatusViewItem *loading = [[StatusViewItem alloc] initWithText:@"Loading Members…"];
	
	StatusView *statusView = [[StatusView alloc] initWithFrame:self.view.frame
														 style:StatusViewStyleScreen
												statusViewItem:loading];
	[loading release];
	
	[self.view addSubview:statusView];
	
	self.statusView = statusView;
	[statusView release];
	
	// request groups
	
	MeetupAsyncRequest *membersRequest = [[MeetupAsyncRequest alloc] init];
	membersRequest.delegate = self;
	membersRequest.callback = @selector(didReceiveMembers:);
	[membersRequest doMethod:@"members" withParams:[NSString stringWithFormat:@"group_id=%d", self.group.groupId]];
	
	self.membersRequest = membersRequest;
	[membersRequest release];
}

- (void)didReceiveMembers:(NSDictionary *)response {
	[_membersRequest release];
	_membersRequest = nil;
	
	NSDictionary *membersResults = [response objectForKey:@"results"];
	
	// set up model and cell controllers
	
	NSMutableArray *memberControllers = [[NSMutableArray alloc] initWithCapacity:25];
	
	for (NSDictionary *memberResult in membersResults) {		
		User *user = [[User alloc] initWithResponseObject:memberResult];
		
		GroupProfileTableViewCellController *groupProfileCellController = [[GroupProfileTableViewCellController alloc] init];
		groupProfileCellController.navigationController = self.navigationController;
		groupProfileCellController.user = user;
		[user release];
		groupProfileCellController.group = self.group;
		
		[memberControllers addObject:groupProfileCellController];
		
		[groupProfileCellController release];
	}
	
	self.memberControllers = memberControllers;
	[memberControllers release];
	
	[self updateAndReload];
	
	[_statusView removeFromSuperview];
	[_statusView release];
	_statusView = nil;
	
	[self viewDidAppear:NO];
}

- (void)constructTableItems {
	NSMutableArray *tableItems = [[NSArray alloc] initWithObjects:self.memberControllers, nil];
	self.tableItems = tableItems;
	[tableItems release];
}

- (void)dealloc {
	[_memberControllers release];
	[_group release];
	[_membersRequest release];
	[_statusView release];
    [super dealloc];
}

@end
