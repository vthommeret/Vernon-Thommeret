//
//  PhotoTableViewCell.h
//  Meetup
//
//  Created by Vernon Thommeret on 8/18/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractTableViewCell.h"
#import "Three20/TTImageView.h"

/**
 A PhotoTableViewCell is responsible for displaying text and a photo. It is similar to the
 SingleLineTableView in that it's a fixed height (64px) but it can render up to two lines of text.
 It is used by the GroupTableViewCellController, EventTableViewCellController.
 */
@interface PhotoTableViewCell : AbstractTableViewCell <TTURLRequestDelegate> {
	NSString *_defaultImage;
	NSString *_photoUrl;
	NSString *_content;
	UIImage *_photo;
	TTURLRequest *_photoRequest;
}

@property (nonatomic, copy) NSString *defaultImage;
@property (nonatomic, copy) NSString *photoUrl;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, retain) UIImage *photo;
@property (nonatomic, retain) TTURLRequest *photoRequest;

@end

#pragma mark -
#pragma mark PhotoTableViewCellView interface

@interface PhotoTableViewCellView : AbstractTableViewCellView {}

+ (UIImage *)thumbWithImage:(UIImage *)image url:(NSString *)url;

@end
