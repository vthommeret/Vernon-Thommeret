//
//  DetailHeaderView.h
//  Meetup
//
//  Created by Vernon Thommeret on 8/24/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Three20/Three20.h>

@class TTImageView;
@protocol DetailHeaderViewDelegate;

@interface DetailHeaderView : UIView <TTImageViewDelegate> {	
	NSString *_title;
	NSString *_subtitle;
	NSString *_subsubtitle;
	CGFloat _rating;
	NSString *_photoUrl;
	TTImageView *_photoView;
	UIImage *_defaultImage;
	id<DetailHeaderViewDelegate> _delegate;
}

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *subsubtitle;
@property (nonatomic, assign) CGFloat rating;
@property (nonatomic, copy) NSString *photoUrl;
@property (nonatomic, retain) TTImageView *photoView;
@property (nonatomic, retain) UIImage *defaultImage;
@property (nonatomic, assign) id<DetailHeaderViewDelegate> delegate;

- (id)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle subsubtitle:(NSString *)subsubtitle
			 rating:(CGFloat)rating photoUrl:(NSString *)photoUrl defaultImage:(UIImage *)defaultImage
		   delegate:(id<DetailHeaderViewDelegate>)delegate;
- (void)updateFrame;
- (CGFloat)heightForPhoto;
- (CGFloat)heightForDetail;
- (CGRect)detailFrame;
- (UIImage *)photoThumbnail;

@end

#pragma mark -
#pragma mark DetailHeaderViewDelegate Protocol

@protocol DetailHeaderViewDelegate <NSObject>

@optional

- (void)detailHeaderView:(DetailHeaderView *)detailHeaderView didUpdateFrame:(CGRect)frame;
- (CGFloat)photoAccessoryHeightForDetailHeaderView:(DetailHeaderView *)detailHeaderView;
- (CGFloat)detailAccessoryHeightForDetailHeaderView:(DetailHeaderView *)detailHeaderView;


@end
