//
//  GroupDetailViewController.m
//  Meetup
//
//  Created by Vernon Thommeret on 8/13/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import <Three20/Three20.h>
#import "GroupDetailViewController.h"
#import "MultiLineTableViewCellController.h"
#import "MembersTableViewCellController.h"
#import "CommentsTableViewCellController.h"
#import "PhotosTableViewCellController.h"
#import "DetailHeaderView.h"
#import "MeetupAsyncRequest.h"
#import "Group.h"
#import "Comment.h"
#import "State.h"

@implementation GroupDetailViewController

@synthesize group = _group;
@synthesize firstComment = _firstComment;
@synthesize firstCommentRequest = _firstCommentRequest;

- (void)dealloc {
	[_group release];
	[_firstComment release];
	[_firstCommentRequest release];
    [super dealloc];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];	
	
	Group *group = self.group;
	
	self.title = group.name;
	
	// grab first comment
	
	if (group.reviewCount != 0) {
		MeetupAsyncRequest *firstCommentRequest = [[MeetupAsyncRequest alloc] init];
		firstCommentRequest.delegate = self;
		firstCommentRequest.callback = @selector(didReceiveFirstComment:);
		[firstCommentRequest doMethod:@"comments"
						   withParams:[NSString stringWithFormat:@"group_id=%d&review_only=1&page=1", group.groupId]];
		
		self.firstCommentRequest = firstCommentRequest;
		[firstCommentRequest release];
	}
	
	// show header
		
	DetailHeaderView *headerView = [[DetailHeaderView alloc] initWithTitle:group.name
																  subtitle:[group.location description]
															   subsubtitle:[group membersDescription]
																	rating:group.rating
																  photoUrl:group.photoUrl
															  defaultImage:[UIImage imageNamed:@"detailHeaderGroupDefault.png"]
																  delegate:self];
	self.tableView.tableHeaderView = headerView;
	[headerView release];
}

- (void)didReceiveFirstComment:(NSDictionary *)response {
	[_firstCommentRequest release];
	_firstCommentRequest = nil;
	
	NSArray *comments = [response objectForKey:@"results"];
	
	if ([comments count] != 0) {
		NSDictionary *firstCommentResult = [comments objectAtIndex:0];
		
		Comment *firstComment = [[Comment alloc] initWithResponseObject:firstCommentResult];
		self.firstComment = firstComment;
		[firstComment release];
		
		[self updateAndReload];
	}
}

- (void)constructTableItems {
	self.tableHeaders = [NSMutableArray arrayWithCapacity:10];
	self.tableItems = [NSMutableArray arrayWithCapacity:10];
	
	// description
	
	if ([self.group.description length] != 0) {
		MultiLineTableViewCellController *descriptionController = [[MultiLineTableViewCellController alloc] init];
		descriptionController.navigationController = self.navigationController;
		descriptionController.key = @"Description";
		descriptionController.content = self.group.description;
		
		[self.tableHeaders addObject:@""];
		[self.tableItems addObject:[NSArray arrayWithObject:descriptionController]];
		
		[descriptionController release];
	}
	
	// members
	
	MembersTableViewCellController *membersController = [[MembersTableViewCellController alloc] init];
	membersController.navigationController = self.navigationController;
	membersController.key = @"Members";
	membersController.group = self.group;
	
	[self.tableHeaders addObject:@"Members"];
	[self.tableItems addObject:[NSArray arrayWithObject:membersController]];
	
	[membersController release];
	
	// comments
	
	if (self.group.reviewCount != 0) {
		NSMutableArray *commentItems = [[NSMutableArray alloc] initWithCapacity:2];
		
		// show first comment if it's available
		
		if (self.firstComment != nil) {
			MultiLineTableViewCellController *firstCommentController = [[MultiLineTableViewCellController alloc] init];
			firstCommentController.navigationController = self.navigationController;
			firstCommentController.content = self.firstComment.text;
			
			[commentItems addObject:firstCommentController];
			[firstCommentController release];
		}
		
		// link to more comments
		
		CommentsTableViewCellController *commentsController = [[CommentsTableViewCellController alloc] init];
		commentsController.navigationController = self.navigationController;
		commentsController.group = self.group;
		
		if (self.firstComment != nil) {
			commentsController.more = YES;
		}
		
		[commentItems addObject:commentsController];
		[commentsController release];
		
		[self.tableHeaders addObject:@"Comments"];
		[self.tableItems addObject:commentItems];
		
		[commentItems release];
	}
	
	// photos
	
	if (self.group.photoCount != 0) {
		PhotosTableViewCellController *photosController = [[PhotosTableViewCellController alloc] init];
		photosController.navigationController = self.navigationController;
		photosController.group = self.group;
		
		[self.tableHeaders addObject:@"Photos"];
		[self.tableItems addObject:[NSArray arrayWithObject:photosController]];
		
		[photosController release];
	}
}

@end
