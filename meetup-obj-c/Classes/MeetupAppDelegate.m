//
//  MeetupAppDelegate.m
//  Meetup
//
//  Created by Vernon Thommeret on 8/12/09.
//  Copyright Vernon Thommeret 2009. All rights reserved.
//

#import "MeetupAppDelegate.h"

#import "HomeNavigationController.h"
#import "GroupsNavigationController.h"
#import "SearchNavigationController.h"
#import "MoreNavigationController.h"
#import "StatusView.h"
#import "MeetupAsyncRequest.h"
#import "User.h"

#import "State.h"

@implementation MeetupAppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;
@synthesize statusView = _statusView;
@synthesize userRequest = _userRequest;

#define kMeetupColorR	244.0 / 255.0
#define kMeetupColorG	0.0
#define kMeetupColorB	34.0 / 255.0

#define kGrayBackgroundColor	207.0 / 255.0
#define kRowBackgroundColor		250.0 / 255.0
#define kDarkTextColor			43.0 / 255.0

#define kKeyColorR	85.0 / 255.0
#define kKeyColorG	104.0 / 255.0
#define kKeyColorB	143.0 / 255.0

- (void)dealloc {
    [_window release];
	[_tabBarController release];
	[_statusView release];
	[_userRequest release];
    [super dealloc];
}

+ (void)initialize {
	// set up state
	[State sharedState].meetupColor = [UIColor colorWithRed:kMeetupColorR green:kMeetupColorG
													   blue:kMeetupColorB alpha:1.0];
	[State sharedState].grayBackgroundColor = [UIColor colorWithRed:kGrayBackgroundColor green:kGrayBackgroundColor
															   blue:kGrayBackgroundColor alpha:1.0];
	[State sharedState].rowBackgroundColor = [UIColor colorWithRed:kRowBackgroundColor green:kRowBackgroundColor
															  blue:kRowBackgroundColor alpha:1.0];
	[State sharedState].darkTextColor = [UIColor colorWithRed:kDarkTextColor green:kDarkTextColor
														 blue:kDarkTextColor alpha:1.0];
	[State sharedState].keyColor = [UIColor colorWithRed:kKeyColorR green:kKeyColorG
													blue:kKeyColorB alpha:1.0];
	[State sharedState].sharedQueue = [[NSOperationQueue alloc] init];
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {	
	// set up window
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.window.backgroundColor = [State sharedState].grayBackgroundColor;
	
	// set up tab bar
	UITabBarController *tabBarController = [[UITabBarController alloc] initWithNibName:nil bundle:nil];
	tabBarController.delegate = self;
	
	// initialize main nav controllers
	HomeNavigationController *homeNavigationController = [[HomeNavigationController alloc]
														  initWithNibName:nil bundle:nil];
	GroupsNavigationController *groupsNavigationController = [[GroupsNavigationController alloc]
															  initWithNibName:nil bundle:nil];
	SearchNavigationController *searchNavigationController = [[SearchNavigationController alloc]
															  initWithNibName:nil bundle:nil];
	MoreNavigationController *moreNavigationController = [[MoreNavigationController alloc]
														  initWithNibName:nil bundle:nil];
	
	// populate nav controllers
	NSArray *viewControllers = [[NSArray alloc] initWithObjects:homeNavigationController,
								groupsNavigationController, searchNavigationController,
								moreNavigationController, nil];
	[homeNavigationController release];
	[groupsNavigationController release];
	[searchNavigationController release];
	[moreNavigationController release];
	
	tabBarController.viewControllers = viewControllers;
	[viewControllers release];
	
	// remember last tab selected
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSInteger selectedTabIndex = [defaults integerForKey:@"selectedTabIndex"];
	tabBarController.selectedIndex = selectedTabIndex;
	
	[self.window addSubview:tabBarController.view];
	
	self.tabBarController = tabBarController;
	[tabBarController release];
	
	// show status view
	
	StatusViewItem *signingIn = [[StatusViewItem alloc] initWithText:@"Signing in…"];
	
	CGRect screenFrame = [UIScreen mainScreen].applicationFrame;
	screenFrame = CGRectMake(screenFrame.origin.x,
							 screenFrame.origin.y + kTopBarHeight,
							 screenFrame.size.width,
							 screenFrame.size.height - kTopBarHeight - kTabBarHeight);
	
	StatusView *statusView = [[StatusView alloc] initWithFrame:screenFrame
														 style:StatusViewStyleScreen
												statusViewItem:signingIn];
	[signingIn release];
	[self.window addSubview:statusView];
	
	self.statusView = statusView;
	[statusView release];
	 
	// set up and display window
	[self.window makeKeyAndVisible];
	
	// start user request
	
	MeetupAsyncRequest *userRequest = [[MeetupAsyncRequest alloc] init];
	userRequest.delegate = self;
	userRequest.errorCallback = @selector(didFailWithError:);
	userRequest.callback = @selector(didReceiveUserData:);
	[userRequest doMethod:@"members" withParams:@"relation=self"];
	
	self.userRequest = userRequest;
	[userRequest release];
}

- (void)didFailWithError:(NSError *)error {
	[_userRequest release];
	_userRequest = nil;
	
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

- (void)didReceiveUserData:(NSDictionary *)response {
	[_userRequest release];
	_userRequest = nil;
	
	User *user = [[User alloc] initWithResponseObject:[[response objectForKey:@"results"] objectAtIndex:0]];
	[State sharedState].user = user;
	[user release];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"AppDelegateDidReceiveUserData" object:self];
	
	[_statusView removeFromSuperview];
	[_statusView release];
	_statusView = nil;
}

#pragma mark -
#pragma mark UITabBarController Delege Methods

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setInteger:viewController.tabBarItem.tag forKey:@"selectedTabIndex"];
}

@end
