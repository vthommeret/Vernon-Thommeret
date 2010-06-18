//
//  MeetupAppDelegate.h
//  Meetup
//
//  Created by Vernon Thommeret on 8/12/09.
//  Copyright Vernon Thommeret 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StatusView;
@class MeetupAsyncRequest;

@interface MeetupAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIWindow *_window;
	UITabBarController *_tabBarController;
	StatusView *_statusView;
	MeetupAsyncRequest *_userRequest;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) UITabBarController *tabBarController;
@property (nonatomic, retain) StatusView *statusView;
@property (nonatomic, retain) MeetupAsyncRequest *userRequest;

@end
