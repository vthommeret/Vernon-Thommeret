//
//  EventTableViewController.m
//  Meetup
//
//  Created by Vernon Thommeret on 8/13/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import "EventDetailViewController.h"
#import "MultiLineTableViewCellController.h"
#import "LocationTableViewCellController.h"
#import "PhoneTableViewCellController.h"
#import "RsvpsTableViewCellController.h"
#import "DetailHeaderViewButton.h"
#import "MeetupAsyncRequest.h"
#import "MeetupAppDelegate.h"
#import "Event.h"
#import "Location.h"

#import "JSON.h"

@implementation EventDetailViewController

@synthesize event = _event;
@synthesize rsvpButton = _rsvpButton;
@synthesize rsvpInfoButton = _rsvpInfoButton;
@synthesize updateRsvpRequest = _updateRsvpRequest;
@synthesize rsvp = _rsvp;

- (void)dealloc {
	[_event release];
	[_rsvpButton release];
	[_rsvpInfoButton release];
	[_updateRsvpRequest release];
	[_rsvp release];
	[super dealloc];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = self.event.name;
	
	// show header
	
	Event *event = self.event;
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:kLongDate];
	NSString *dateString = [dateFormatter stringFromDate:event.date];
	[dateFormatter release];
	
	DetailHeaderView *detailHeaderView = [[DetailHeaderView alloc] initWithTitle:event.name
																		subtitle:dateString
																	 subsubtitle:nil
																		  rating:0.0
																		photoUrl:event.photoUrl
																	defaultImage:[UIImage
																				  imageNamed:@"detailHeaderEventDefault.png"]
																		delegate:self];
	self.tableView.tableHeaderView = detailHeaderView;
	[detailHeaderView release];
}

- (void)constructTableItems {
	self.tableHeaders = [NSMutableArray arrayWithCapacity:10];
	self.tableItems = [NSMutableArray arrayWithCapacity:10];
	
	// description
	
	if ([self.event.description length] != 0) {
		MultiLineTableViewCellController *descriptionController = [[MultiLineTableViewCellController alloc] init];
		descriptionController.navigationController = self.navigationController;
		descriptionController.key = @"Description";
		descriptionController.content = self.event.description;
		
		[self.tableHeaders addObject:@""];
		[self.tableItems addObject:[NSArray arrayWithObject:descriptionController]];
		 
		[descriptionController release];
	}
	
	// location and phone
	
	if (self.event.location != nil) {
		LocationTableViewCellController *locationController = [[LocationTableViewCellController alloc] init];
		locationController.navigationController = self.navigationController;
		locationController.location = self.event.location;
		locationController.key = @"Location";
		
		NSMutableArray *venueItems = [[NSMutableArray alloc] initWithCapacity:2];
		
		[venueItems addObject:locationController];
		
		if ([self.event.location.phone length] != 0) {
			PhoneTableViewCellController *phoneController = [[PhoneTableViewCellController alloc] init];
			phoneController.navigationController = self.navigationController;
			phoneController.key = @"Call";
			phoneController.phone = self.event.location.phone;
			
			[venueItems addObject:phoneController];
			[phoneController release];
		}
		
		[self.tableHeaders addObject:@""];
		[self.tableItems addObject:venueItems];
		
		[locationController release];
		[venueItems release];
	}
	
	// who's coming
	
	RsvpsTableViewCellController *rsvpController = [[RsvpsTableViewCellController alloc] init];
	rsvpController.navigationController = self.navigationController;
	rsvpController.key = @"Who's coming?";
	rsvpController.event = self.event;
	
	[self.tableHeaders addObject:@"Who's coming?"];
	[self.tableItems addObject:[NSArray arrayWithObject:rsvpController]];
	
	[rsvpController release];
}

#pragma mark -
#pragma mark DetailHeaderViewDelegate Methods

#define kDetailHeaderButtonTopPadding	4.0
#define kDetailHeaderButtonWidth		96.0
#define kDetailHeaderButtonHeight		24.0

- (void)detailHeaderView:(DetailHeaderView *)detailHeaderView didUpdateFrame:(CGRect)frame {
	CGRect detailFrame = [detailHeaderView detailFrame];
	CGRect rsvpButtonFrame = CGRectMake(detailFrame.origin.x,
										detailFrame.origin.y + [detailHeaderView heightForDetail] - kDetailHeaderButtonHeight,
										kDetailHeaderButtonWidth,
										kDetailHeaderButtonHeight);
	
	DetailHeaderViewButton *rsvpButton = [[DetailHeaderViewButton alloc] initWithFrame:rsvpButtonFrame];
	
	rsvpButton.title = @"Update Rsvp";
	[rsvpButton addTarget:self action:@selector(updateRsvp:) forControlEvents:UIControlEventTouchUpInside];
	
	[rsvpButton sizeToFit];
	
	[detailHeaderView addSubview:rsvpButton];
	self.rsvpButton = rsvpButton;
	[rsvpButton release];
}

- (CGFloat)detailAccessoryHeightForDetailHeaderView:(DetailHeaderView *)detailHeaderView {
	return kDetailHeaderButtonHeight + kDetailHeaderButtonTopPadding;
}

- (void)updateRsvp:(id)sender {
	[self.rsvpButton disable];
	
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Will you be there?"
															 delegate:self
													cancelButtonTitle:@"Cancel"
											   destructiveButtonTitle:nil
													otherButtonTitles:@"Yes", @"Maybe", @"No", nil];
	[actionSheet showFromTabBar:((MeetupAppDelegate *) [UIApplication sharedApplication].delegate).tabBarController.tabBar];
	[actionSheet release];
}

#pragma mark -
#pragma mark UIActionSheetDelegate Methods

#define kRsvpActionSheetYes		0
#define kRsvpActionSheetMaybe	1
#define kRsvpActionSheetNo		2
#define kRsvpActionSheetCancel	3

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	DetailHeaderViewButton *rsvpButton = self.rsvpButton;
	
	if (buttonIndex == kRsvpActionSheetCancel) {
		[rsvpButton enable];
	} else {
		NSString *rsvp;
		
		if (buttonIndex == kRsvpActionSheetYes) {
			rsvp = @"yes";
		} else if (buttonIndex == kRsvpActionSheetMaybe) {
			rsvp = @"maybe";
		} else { // buttonIndex == kRsvpActionSheetNo
			rsvp = @"no";
		}
		
		self.rsvp = rsvp;
		
		[self doUpdateRsvpRequestWithRsvp:rsvp];
		
		NSString *title = @"Updating…";
		
		CGRect newFrame = rsvpButton.frame;
		newFrame.size = [rsvpButton sizeThatFitsTitle:title];
		
		rsvpButton.title = @"";
		[UIView beginAnimations:nil context:title];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(restoreRsvpButtonTitle:finished:context:)];
		rsvpButton.frame = newFrame;
		[UIView commitAnimations];
	}
}

- (void)doUpdateRsvpRequestWithRsvp:(NSString *)rsvp {
	MeetupAsyncRequest *updateRsvpRequest = [[MeetupAsyncRequest alloc] init];
	updateRsvpRequest.delegate = self;
	updateRsvpRequest.errorCallback = @selector(updateRsvpRequestDidSucceed:);
	updateRsvpRequest.callback = @selector(updateRsvpRequestDidFail:);
	[updateRsvpRequest doMethod:@"rsvp" withParams:[NSString stringWithFormat:@"event_id=%d&rsvp=%@",
													self.event.eventId, rsvp]];
	
	self.updateRsvpRequest = updateRsvpRequest;
	[updateRsvpRequest release];
}

- (void)updateRsvpRequestDidFail:(NSDictionary *)response {
	[_updateRsvpRequest release];
	_updateRsvpRequest = nil;
	
	DetailHeaderViewButton *rsvpButton = self.rsvpButton;
	
	DetailHeaderViewButton *rsvpInfoButton = [[DetailHeaderViewButton alloc] initWithFrame:rsvpButton.frame];
	rsvpInfoButton.style = DetailHeaderViewButtonStyleInfo;
	rsvpInfoButton.title = [self.rsvp uppercaseString];
	[rsvpInfoButton sizeToFit];
	
	NSString *title = @"Change Rsvp";
	
	CGRect newFrame = CGRectOffset(rsvpButton.frame, rsvpInfoButton.frame.size.width + 5.0, 0);
	newFrame.size = [rsvpButton sizeThatFitsTitle:title];
	
	rsvpButton.title = @"";
	[UIView beginAnimations:nil context:title];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(didSlideRsvpButton:finished:context:)];
	rsvpButton.frame = newFrame;
	[UIView commitAnimations];
	
	self.rsvpInfoButton = rsvpInfoButton;
	[rsvpInfoButton release];
}

- (void)updateRsvpRequestDidSucceed:(NSDictionary *)response {
	[_updateRsvpRequest release];
	_updateRsvpRequest = nil;
}

- (void)didSlideRsvpButton:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	self.rsvpButton.title = context;
	[self.rsvpButton enable];
	
	DetailHeaderView *detailHeaderView = (DetailHeaderView *) self.tableView.tableHeaderView;
	DetailHeaderViewButton *rsvpInfoButton = self.rsvpInfoButton;
	
	rsvpInfoButton.alpha = 0.0;
	[detailHeaderView addSubview:self.rsvpInfoButton];
	
	[UIView beginAnimations:nil context:NULL];
	rsvpInfoButton.alpha = 0.3;
	[UIView commitAnimations];
}

- (void)restoreRsvpButtonTitle:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	self.rsvpButton.title = context;
}
	 
@end
