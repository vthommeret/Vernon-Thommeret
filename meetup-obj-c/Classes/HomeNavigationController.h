//
//  HomeNavigationController.h
//  Meetup
//
//  Created by Vernon Thommeret on 8/12/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeNavigationController : UIViewController {
	UINavigationController *_navController;
}

@property (nonatomic, retain) UINavigationController *navController;

@end
