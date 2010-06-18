//
//  CommentsDetailViewController.m
//  Meetup
//
//  Created by Vernon Thommeret on 8/19/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import "CommentsDetailViewController.h"
#import "MultiLineTableViewCellController.h"
#import "MeetupAsyncRequest.h"
#import "StatusView.h"
#import "Group.h"
#import "Comment.h"
#import "State.h"

#import "User.h"

@implementation CommentsDetailViewController

@synthesize commentControllers = _commentControllers;
@synthesize group = _group;
@synthesize commentsRequest = _commentsRequest;
@synthesize statusView = _statusView;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	// show loading overlay
	
	StatusViewItem *loading = [[StatusViewItem alloc] initWithText:@"Loading Comments…"];
	
	StatusView *statusView = [[StatusView alloc] initWithFrame:self.view.frame
														 style:StatusViewStyleScreen
												statusViewItem:loading];
	[loading release];
	
	[self.view addSubview:statusView];
	
	self.statusView = statusView;
	[statusView release];
	
	// request groups
	
	MeetupAsyncRequest *commentsRequest = [[MeetupAsyncRequest alloc] init];
	commentsRequest.delegate = self;
	commentsRequest.callback = @selector(didReceiveComments:);
	[commentsRequest doMethod:@"comments" withParams:[NSString stringWithFormat:@"group_id=%d&review_only=1",
													  self.group.groupId]];
	
	self.commentsRequest = commentsRequest;
	[commentsRequest release];
}

- (void)didReceiveComments:(NSDictionary *)response {
	[_commentsRequest release];
	_commentsRequest = nil;
	
	NSDictionary *commentResults = [response objectForKey:@"results"];
	
	// set up model and cell controllers
	
	NSMutableArray *commentControllers = [[NSMutableArray alloc] initWithCapacity:25];
	
	for (NSDictionary *commentResult in commentResults) {		
		Comment *comment = [[Comment alloc] initWithResponseObject:commentResult];
		
		MultiLineTableViewCellController *multiLineCellController = [[MultiLineTableViewCellController alloc] init];
		multiLineCellController.navigationController = self.navigationController;
		multiLineCellController.showFull = YES;
		multiLineCellController.content = comment.text;
		[comment release];
		
		[commentControllers addObject:multiLineCellController];
		
		[multiLineCellController release];
	}
	
	self.commentControllers = commentControllers;
	[commentControllers release];
	
	[self updateAndReload];
	
	[_statusView removeFromSuperview];
	[_statusView release];
	_statusView = nil;
	
	[self viewDidAppear:NO];
}


- (void)constructTableItems {
	NSMutableArray *tableItems = [[NSArray alloc] initWithObjects:self.commentControllers, nil];
	self.tableItems = tableItems;
	[tableItems release];
}

- (void)dealloc {
	[_commentControllers release];
	[_group release];
	[_commentsRequest release];
	[_statusView release];
    [super dealloc];
}

@end
