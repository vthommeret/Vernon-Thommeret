//
//  SearchRootTableViewController.m
//  Meetup
//
//  Created by Vernon Thommeret on 8/13/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import "SearchRootTableViewController.h"
#import "GroupTableViewCellController.h"
#import "MeetupAsyncRequest.h"
#import "SearchOverlayView.h"
#import "StatusView.h"
#import "Group.h"
#import "State.h"

@implementation SearchRootTableViewController

@synthesize groupControllers = _groupControllers;
@synthesize searchRequest = _searchRequest;
@synthesize searchOverlay = _searchOverlay;
@synthesize statusView = _statusView;

- (void)dealloc {
	[_groupControllers release];
	[_searchRequest release];
	[_searchOverlay release];
	[_statusView release];
    [super dealloc];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

	UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, kTopBarHeight)];
	searchBar.tintColor = [State sharedState].meetupColor;
	searchBar.delegate = self;
	self.tableView.tableHeaderView = searchBar;
	[searchBar release];
	
	self.title = @"Search";
}

- (void)constructTableItems {
	NSMutableArray *tableItems = [[NSArray alloc] initWithObjects:self.groupControllers, nil];
	self.tableItems = tableItems;
	[tableItems release];
}

#pragma mark -
#pragma mark Search Bar Delegate Methods

#define STATUS_BAR_HEIGHT	20.0

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
	// cancel existing request and hide statusview if they're there
	
	_searchRequest.delegate = nil;
	[_searchRequest release];
	_searchRequest = nil;
	
	[_statusView removeFromSuperview];
	[_statusView release];
	_statusView = nil;
	
	// begin search and display overlay
	
	[searchBar setShowsCancelButton:YES animated:YES];
	
	CGRect overlayFrame = [UIScreen mainScreen].applicationFrame;
	overlayFrame = CGRectMake(overlayFrame.origin.x, overlayFrame.origin.y + 2 * kTopBarHeight,
							  overlayFrame.size.width, overlayFrame.size.height - 2 * kTopBarHeight);
	
	SearchOverlayView *searchOverlay = [[SearchOverlayView alloc] initWithFrame:overlayFrame];
	searchOverlay.delegate = self;
	[self.tableView.window addSubview:searchOverlay];
	
	[searchOverlay show];
	
	self.searchOverlay = searchOverlay;
	[searchOverlay release];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
	searchBar.text = @"";
	[self.searchOverlay hide];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	StatusViewItem *searching = [[StatusViewItem alloc] initWithText:@"Searching…"];
	
	CGRect statusViewFrame = self.tableView.frame;
	
	statusViewFrame = CGRectMake(statusViewFrame.origin.x, statusViewFrame.origin.y + kTopBarHeight,
								 statusViewFrame.size.width, statusViewFrame.size.height - kTopBarHeight);
	
	StatusView *statusView = [[StatusView alloc] initWithFrame:statusViewFrame
														 style:StatusViewStyleScreen
												statusViewItem:searching];
	[searching release];
	
	[self.view addSubview:statusView];
	
	self.statusView = statusView;
	[statusView release];
	
	// launch query
	
	NSString *query = searchBar.text;
	
	MeetupAsyncRequest *searchRequest = [[MeetupAsyncRequest alloc] init];
	searchRequest.delegate = self;
	searchRequest.callback = @selector(didReceiveResponse:);
	searchRequest.errorCallback = @selector(didFailWithError:);
	[searchRequest doMethod:@"search" withParams:[NSString stringWithFormat:@"query=%@&page=25", query]];
	
	self.searchRequest = searchRequest;
	[searchRequest release];
	
	[self.searchOverlay hide];
}

#pragma mark -
#pragma mark SearchOverlayView Delegate Methods

- (void)willHideOverlay {
	UISearchBar *searchBar = (UISearchBar *) self.tableView.tableHeaderView;
	
	[searchBar resignFirstResponder];
	[searchBar setShowsCancelButton:NO animated:YES];
}

- (void)didHideOverlay {
	[self.searchOverlay removeFromSuperview];
	[_searchOverlay release];
}

#pragma mark -
#pragma mark Request Callback Methods

- (void)didFailWithError:(NSError *)error {
	[_searchRequest release];
	_searchRequest = nil;
	
	NSString *errorString;
	
	if (error) {
		errorString = [error localizedDescription];
	} else {
		errorString = @"Couldn't talk to the API";
	}
	
	StatusViewItem *connectionFailed = [[StatusViewItem alloc] initWithText:errorString
																	   icon:[UIImage imageNamed:@"error.png"]];
	self.statusView.statusViewItem = connectionFailed;
	[connectionFailed release];
}

- (void)didReceiveResponse:(NSDictionary *)response {
	[_searchRequest release];
	_searchRequest = nil;
	
	NSDictionary *groupResults = [response objectForKey:@"results"];
	
	// set up model and cell controllers
	
	NSMutableArray *groupControllers = [[NSMutableArray alloc] initWithCapacity:25];
	
	for (NSDictionary *groupResult in groupResults) {
		Group *group = [[Group alloc] initWithResponseObject:groupResult];
		
		GroupTableViewCellController *groupCellController = [[GroupTableViewCellController alloc] init];
		groupCellController.navigationController = self.navigationController;
		groupCellController.group = group;
		[group release];
		
		[groupControllers addObject:groupCellController];
		
		[groupCellController release];
	}
	
	self.groupControllers = groupControllers;
	[groupControllers release];
	
	[self updateAndReload];
	
	[_statusView removeFromSuperview];
	[_statusView release];
	_statusView = nil;
	
	[self viewDidAppear:NO];
}

@end
