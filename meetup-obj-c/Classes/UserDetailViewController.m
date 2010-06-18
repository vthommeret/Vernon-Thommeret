//
//  UserDetailViewController.m
//  Meetup
//
//  Created by Vernon Thommeret on 8/24/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import "UserDetailViewController.h"
#import "MultiLineTableViewCellController.h"
#import "DetailHeaderView.h"
#import "MeetupAsyncRequest.h"
#import "User.h"
#import "Group.h"
#import "Comment.h"

@implementation UserDetailViewController

@synthesize user = _user;
@synthesize group = _group;
@synthesize commentControllers = _commentControllers;
@synthesize greetingsRequest = _greetingsRequest;

- (void)dealloc {
	[_user release];
	[_group release];
	[_commentControllers release];
	[_greetingsRequest release];
    [super dealloc];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	User *user = self.user;
	self.title = user.name;
	
	DetailHeaderView *headerView = [[DetailHeaderView alloc] initWithTitle:user.name
																  subtitle:[user.location description]
															   subsubtitle:nil
																	rating:0.0
																  photoUrl:user.photoUrl
															  defaultImage:[UIImage imageNamed:@"detailHeaderUserDefault.png"]
																  delegate:self];
	self.tableView.tableHeaderView = headerView;
	[headerView release];
	
	if (self.group != nil) {
		MeetupAsyncRequest *greetingsRequest = [[MeetupAsyncRequest alloc] init];
		greetingsRequest.delegate = self;
		greetingsRequest.callback = @selector(didReceiveComments:);
		[greetingsRequest doMethod:@"comments" withParams:[NSString stringWithFormat:@"member_id=%d",
														   self.group.groupId, self.user.userId]];
		[greetingsRequest release];
	}
}

- (void)didReceiveComments:(NSDictionary *)response {
	[_greetingsRequest release];
	_greetingsRequest = nil;
	
	NSDictionary *greetingsResult = [response objectForKey:@"results"];
	NSMutableArray *commentControllers = [[NSMutableArray alloc] initWithCapacity:15];
	
	for (NSDictionary *greetingResult in greetingsResult) {
		Comment *comment = [[Comment alloc] initWithResponseObject:greetingResult];
		
		MultiLineTableViewCellController *commentController = [[MultiLineTableViewCellController alloc] init];
		commentController.navigationController = self.navigationController;
		commentController.showFull = YES;
		commentController.content = comment.text;
		[comment release];
		
		[commentControllers addObject:commentController];
		[commentController release];
	}
	
	self.commentControllers = commentControllers;
	[commentControllers release];
	
	[self updateAndReload];
}

- (void)constructTableItems {
	NSMutableArray *tableHeaders = [[NSMutableArray alloc] initWithCapacity:3];
	NSMutableArray *tableItems = [[NSMutableArray alloc] initWithCapacity:3];
	
	if ([self.user.bio length] != 0) {
		MultiLineTableViewCellController *bioController = [[MultiLineTableViewCellController alloc] init];
		bioController.navigationController = self.navigationController;
		bioController.content = self.user.bio;
		bioController.showFull = YES;
		
		[tableHeaders addObject:@""];
		[tableItems addObject:[NSArray arrayWithObject:bioController]];
		
		[bioController release];
	}
	
	if ([self.commentControllers count] != 0) {
		[tableHeaders addObject:@"Greetings"];
		[tableItems addObject:self.commentControllers];
	}
	
	self.tableHeaders = tableHeaders;
	self.tableItems = tableItems;
	
	[tableHeaders release];
	[tableItems release];
}

@end
