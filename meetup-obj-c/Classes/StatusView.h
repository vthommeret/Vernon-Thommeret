//
//  StatusView.h
//  Meetup
//
//  Created by Vernon Thommeret on 8/14/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    StatusViewStyleScreen,
    StatusViewStyleTableViewCell
} StatusViewStyle;

@class StatusViewItem;

/**
 A StatusView is a flexible view that can be used to indicate either progress or that some kind of
 error or warning occurred. In order to use it, you have to initialize it with a StatusViewItem (@see StatusViewItem).
 A StatusViewItem essentially takes a message and an optional icon. The StatusView will takes this StatusViewItem and
 display it in the center of its view. What makes a StatusView particularly flexible is that you can reuse a StatusView
 if it's being displayed on the screen by feeding it additional StatusViewItems with setStatusViewItem:. It also flexible
 in that it can be used in different contexts — currently as a window overlay or row overlay by specifying an appropriate
 frame and StatusViewStyle (@see StatusViewStyle).
 */
@interface StatusView : UIView {
	StatusViewItem *_statusViewItem;
}

@property (nonatomic, retain) StatusViewItem *statusViewItem;

- (id)initWithFrame:(CGRect)frame style:(StatusViewStyle)style statusViewItem:(StatusViewItem *)statusViewItem;

@end

#pragma mark -
#pragma mark StatusViewItem Interface

/**
 A StatusViewItem encapsulates particular status that can be fed to a StatusView.
 */
@interface StatusViewItem : UIView
{
	NSString *_text;
	UIImage *_icon;
	UIActivityIndicatorView *_spinner;
}

@property (nonatomic, copy) NSString *text;
@property (nonatomic, retain) UIImage *icon;
@property (nonatomic, retain) UIActivityIndicatorView *spinner;

- (id)initWithText:(NSString *)text icon:(UIImage *)icon;
- (id)initWithText:(NSString *)text;
- (void)drawWithParentFrame:(CGRect)parentFrame;

@end