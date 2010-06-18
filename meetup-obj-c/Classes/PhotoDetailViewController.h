//
//  PhotoDetailViewController.h
//  Meetup
//
//  Created by Vernon Thommeret on 8/19/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Three20/Three20.h>

@class MeetupAsyncRequest;
@class Group;

@interface PhotoDetailViewController : TTPhotoViewController {
	NSMutableArray *_photos;
	MeetupAsyncRequest *_photosRequest;
	Group *_group;
}

@property (nonatomic, retain) NSMutableArray *photos;
@property (nonatomic, retain) MeetupAsyncRequest *photosRequest;
@property (nonatomic, retain) Group *group;

@end
