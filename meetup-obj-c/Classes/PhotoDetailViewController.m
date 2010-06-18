//
//  PhotoDetailViewController.m
//  Meetup
//
//  Created by Vernon Thommeret on 8/19/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import "PhotoDetailViewController.h"
#import "MeetupAsyncRequest.h"
#import "MockPhotoSource.h"
#import "Group.h"

@implementation PhotoDetailViewController

@synthesize photos = _photos;
@synthesize photosRequest = _photosRequest;
@synthesize group = _group;

- (void)dealloc {
	[_photos release];
	[_photosRequest release];
	[_group release];
	[super dealloc];
}

- (void)viewDidLoad {
	MeetupAsyncRequest *photosRequest = [[MeetupAsyncRequest alloc] init];
	photosRequest.delegate = self;
	photosRequest.callback = @selector(didReceivePhotos:);
	[photosRequest doMethod:@"photos" withParams:[NSString stringWithFormat:@"group_id=%d", self.group.groupId]];
	
	self.photosRequest = photosRequest;
	[photosRequest release];
	
	/*
	NSArray *photos = [NSArray arrayWithObjects:  
					   [[[MockPhoto alloc]
						 initWithURL:@"http://farm4.static.flickr.com/3099/3164979221_6c0e583f7d.jpg?v=0"
						 smallURL:@"http://farm4.static.flickr.com/3099/3164979221_6c0e583f7d_t.jpg"
						 size:CGSizeMake(320, 480)] autorelease],
					   
					   [[[MockPhoto alloc]
						 initWithURL:@"http://farm4.static.flickr.com/3444/3223645618_13fe36887a_o.jpg"
						 smallURL:@"http://farm4.static.flickr.com/3444/3223645618_f5e2fa7fea_t.jpg"
						 size:CGSizeMake(320, 480)
						 caption:@"This is a caption."] autorelease],
					   
					   // Uncomment to cause photo viewer to ask photo source to load itself
					   // [NSNull null],
					   
					   [[[MockPhoto alloc]
						 initWithURL:@"http://farm2.static.flickr.com/1134/3172884000_84bc6a841e.jpg?v=0"
						 smallURL:@"http://farm2.static.flickr.com/1134/3172884000_84bc6a841e_t.jpg"
						 size:CGSizeMake(320, 480)] autorelease],
					   
					   [[[MockPhoto alloc]
						 initWithURL:@"http://farm2.static.flickr.com/1124/3164979509_bcfdd72123.jpg?v=0"
						 smallURL:@"http://farm2.static.flickr.com/1124/3164979509_bcfdd72123_t.jpg"
						 size:CGSizeMake(320, 480)
						 caption:@"A hike."] autorelease],
					   
					   [[[MockPhoto alloc]
						 initWithURL:@"http://farm4.static.flickr.com/3106/3203111597_d849ef615b.jpg?v=0"
						 smallURL:@"http://farm4.static.flickr.com/3106/3203111597_d849ef615b_t.jpg"
						 size:CGSizeMake(320, 480)
						 caption:@"This is a really long caption to show how long captions are wrapped and \
						 truncated. This maximum number of lines is six, so captions have to be pretty \
						 darned verbose to get clipped.  I am probably going to suffer from a repetitive stress injury \
						 just from typing this! Are we truncated yet? Just a few more characters I guess."] autorelease],
					   
					   
					   [[[MockPhoto alloc]
						 initWithURL:@"http://farm4.static.flickr.com/3081/3164978791_3c292029f2.jpg?v=0"
						 smallURL:@"http://farm4.static.flickr.com/3081/3164978791_3c292029f2_t.jpg"
						 size:CGSizeMake(320, 480)] autorelease],
					   
					   [[[MockPhoto alloc]
						 initWithURL:@"http://farm4.static.flickr.com/3246/2957580101_33c799fc09_o.jpg"
						 smallURL:@"http://farm4.static.flickr.com/3246/2957580101_d63ef56b15_t.jpg"
						 size:CGSizeMake(960, 1280)] autorelease],
					   [[[MockPhoto alloc]
						 initWithURL:@"http://farm3.static.flickr.com/2358/2179913094_3a1591008e.jpg"
						 smallURL:@"http://farm3.static.flickr.com/2358/2179913094_3a1591008e_t.jpg"
						 size:CGSizeMake(383, 500)] autorelease],
					   [[[MockPhoto alloc]
						 initWithURL:@"http://farm4.static.flickr.com/3162/2677417507_e5d0007e41.jpg"
						 smallURL:@"http://farm4.static.flickr.com/3162/2677417507_e5d0007e41_t.jpg"
						 size:CGSizeMake(391, 500)] autorelease],
					   [[[MockPhoto alloc]
						 initWithURL:@"http://farm4.static.flickr.com/3334/3334095096_ffdce92fc4.jpg"
						 smallURL:@"http://farm4.static.flickr.com/3334/3334095096_ffdce92fc4_t.jpg"
						 size:CGSizeMake(407, 500)] autorelease],
					   [[[MockPhoto alloc]
						 initWithURL:@"http://farm4.static.flickr.com/3118/3122869991_c15255d889.jpg"
						 smallURL:@"http://farm4.static.flickr.com/3118/3122869991_c15255d889_t.jpg"
						 size:CGSizeMake(500, 406)] autorelease],
					   [[[MockPhoto alloc]
						 initWithURL:@"http://farm2.static.flickr.com/1004/3174172875_1e7a34ccb7.jpg"
						 smallURL:@"http://farm2.static.flickr.com/1004/3174172875_1e7a34ccb7_t.jpg"
						 size:CGSizeMake(500, 372)] autorelease],
					   [[[MockPhoto alloc]
						 initWithURL:@"http://farm3.static.flickr.com/2300/2179038972_65f1e5f8c4.jpg"
						 smallURL:@"http://farm3.static.flickr.com/2300/2179038972_65f1e5f8c4_t.jpg"
						 size:CGSizeMake(391, 500)] autorelease],
					   
					   nil];
	*/
	
	/*
	NSArray *photos = [NSArray array];
	
	self.photoSource = [[[MockPhotoSource alloc] initWithType:MockPhotoSourceDelayed title:@"Group Photos"
						 photos:photos photos2:nil] autorelease];*/
}

- (void)didReceivePhotos:(NSDictionary *)response {
	[_photosRequest release];
	_photosRequest = nil;
	
	NSDictionary *photoResults = [response objectForKey:@"results"];
	
	// set up model and cell controllers
	
	self.photos = [[NSMutableArray alloc] initWithCapacity:20];
	
	for (NSDictionary *photoResult in photoResults) {		
		NSArray *fullUrls = [photoResult objectForKey:@"photo_urls"];
		NSArray *thumbUrls = [photoResult objectForKey:@"thumb_urls"];
		
		NSLog(@"full urls: %@", fullUrls);
		NSLog(@"thumb urls: %@", thumbUrls);
		
		for (int i = 0; i < [fullUrls count]; i++) {
			MockPhoto *mockPhoto = [[MockPhoto alloc] initWithURL:[[fullUrls objectAtIndex:i] stringByReplacingOccurrencesOfString:@".dev." withString:@"."]
														 smallURL:[[thumbUrls objectAtIndex:i] stringByReplacingOccurrencesOfString:@".dev." withString:@"."]
															 size:CGSizeMake(32, 48)];
			[self.photos addObject:mockPhoto];
			[mockPhoto release];
		}
	}
	
	MockPhotoSource *photoSource = [[MockPhotoSource alloc] initWithType:MockPhotoSourceNormal title:@"Group Photos"
																  photos:self.photos photos2:nil];
	self.photoSource = photoSource;
	[photoSource release];
}

@end
