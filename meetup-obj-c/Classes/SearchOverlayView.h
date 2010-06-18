//
//  SearchOverlayView.h
//  Meetup
//
//  Created by Vernon Thommeret on 8/21/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchOverlayViewDelegate;

@interface SearchOverlayView : UIView
{
	id<SearchOverlayViewDelegate> delegate;
}

@property (nonatomic, assign) id delegate;

- (void) show;
- (void) hide;

@end

#pragma mark -
#pragma mark SearchOverlayViewDelegate Protocol

@protocol SearchOverlayViewDelegate

- (void)willHideOverlay;
- (void)didHideOverlay;

@end