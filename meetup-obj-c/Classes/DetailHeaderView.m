//
//  DetailHeaderView.m
//  Meetup
//
//  Created by Vernon Thommeret on 8/24/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import "DetailHeaderView.h"
#import "State.h"

#define kDetailHeaderPhotoWidth		128.0
#define kDetailHeaderPhotoHeight	96.0
#define kDetailHeaderTopPadding		6.0
#define kDetailHeaderSidePadding	9.0

#define kStarWidth					13.0
#define kStarsWidth					65.0
#define kStarsHeight				21.0
#define kStarsTopPadding			1.0

#import "Graphics.h"

@implementation DetailHeaderView

@synthesize title = _title;
@synthesize subtitle = _subtitle;
@synthesize subsubtitle = _subsubtitle;
@synthesize rating = _rating;
@synthesize photoUrl = _photoUrl;
@synthesize photoView = _photoView;
@synthesize defaultImage = _defaultImage;
@synthesize delegate = _delegate;

- (void)dealloc {
	[_title release];
	[_subtitle release];
	[_subsubtitle release];
	[_photoUrl release];
	[_photoView release];
	[_defaultImage release];
	[super dealloc];
}

- (id)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle subsubtitle:(NSString *)subsubtitle
			 rating:(CGFloat)rating photoUrl:(NSString *)photoUrl defaultImage:(UIImage *)defaultImage
		   delegate:(id<DetailHeaderViewDelegate>)delegate {
	if (self = [super initWithFrame:CGRectMake(0, 0, 320, 0)]) {
		self.title = title;
		self.subtitle = subtitle;
		self.subsubtitle = subsubtitle;
		self.rating = rating;
		self.photoUrl = photoUrl;
		self.defaultImage = defaultImage;
		self.delegate = delegate;
		
		TTImageView *photoView = [[TTImageView alloc] initWithFrame:CGRectZero];
		photoView.URL = photoUrl;
		
		if (!photoView.isLoaded) {
			photoView.delegate = self;
		}
		
		self.photoView = photoView;
		[photoView release];
		
		self.backgroundColor = [UIColor clearColor];
		
		[self updateFrame];
	}
	return self;
}

- (void)imageView:(TTImageView *)imageView didLoadImage:(UIImage *)image {
	[self updateFrame];
	[self setNeedsDisplay];
}

- (void)updateFrame {
	CGFloat photoHeight = [self heightForPhoto];
	CGFloat detailHeight = [self heightForDetail];
	
	CGRect curFrame = self.frame;
	CGRect updatedFrame = CGRectMake(curFrame.origin.x,
					  curFrame.origin.y,
					  curFrame.size.width,
					  3 * kDetailHeaderTopPadding + MAX(photoHeight, detailHeight));
	self.frame = updatedFrame;
	
	id delegate = self.delegate;
	if ([delegate respondsToSelector:@selector(detailHeaderView:didUpdateFrame:)]) {
		[delegate detailHeaderView:self didUpdateFrame:updatedFrame];
	}
}

- (CGFloat)heightForPhoto {
	CGFloat photoHeight = kDetailHeaderPhotoHeight;
	TTImageView *photoView = self.photoView;
	
	if (photoView.isLoaded) {
		photoHeight = floor(kDetailHeaderPhotoWidth * photoView.image.size.height / photoView.image.size.width) + 1;
	}
	
	CGFloat accessoryHeight = 0.0;
	
	id delegate = self.delegate;
	if ([delegate respondsToSelector:@selector(photoAccessoryHeightForDetailHeaderView:)]) {
		accessoryHeight = [delegate photoAccessoryHeightForDetailHeaderView:self];
	}
	
	return photoHeight + accessoryHeight;
}

- (CGFloat)heightForDetail {
	// text height
	
	UIFont *tFont = [UIFont boldSystemFontOfSize:14.0];
	CGSize tSize = CGSizeMake(self.frame.size.width - kDetailHeaderPhotoWidth - 3 * kDetailHeaderSidePadding, MAXFLOAT);
	UILineBreakMode tMode = UILineBreakModeTailTruncation;
	
	CGFloat titleHeight, subtitleHeight, subsubtitleHeight = 0.0;
	
	if ([self.title length] != 0) {
		titleHeight = [self.title sizeWithFont:tFont constrainedToSize:tSize lineBreakMode:tMode].height;
	}
	
	if ([self.subtitle length] != 0) {
		subtitleHeight = [[self.subtitle description] sizeWithFont:tFont constrainedToSize:tSize
													 lineBreakMode:tMode].height;
	}
	
	if ([self.subsubtitle length] != 0) {
		subsubtitleHeight = [self.subsubtitle sizeWithFont:tFont constrainedToSize:tSize
											 lineBreakMode:tMode].height;
	}
	
	CGFloat textHeight = titleHeight + subtitleHeight + subsubtitleHeight;
	
	// rating height
	
	CGFloat ratingHeight = self.rating ? kStarsTopPadding + kStarsHeight : 0;
	
	CGFloat accessoryHeight = 0.0;
	
	id delegate = self.delegate;
	if ([delegate respondsToSelector:@selector(detailAccessoryHeightForDetailHeaderView:)]) {
		accessoryHeight = [delegate detailAccessoryHeightForDetailHeaderView:self];
	}
	
	return textHeight + ratingHeight + accessoryHeight;
}

- (void)drawRect:(CGRect)rect {
	UIImage *thumb = [self photoThumbnail];
	[thumb drawAtPoint:CGPointMake(kDetailHeaderSidePadding, 2 * kDetailHeaderTopPadding)];
	
	CGRect baseRect = [self detailFrame];
	
	UIFont *font = [UIFont boldSystemFontOfSize:14.0];
	UILineBreakMode lineMode = UILineBreakModeTailTruncation;
	
	CGRect lastRect = baseRect;
	CGFloat lastHeight = 0.0;
	
	// draw title
	
	if ([self.title length] != 0) {
		CGRect titleShadowRect = CGRectOffset(baseRect, 0, 1);
		
		[[UIColor colorWithWhite:1.0 alpha:0.75] set];
		[self.title drawInRect:titleShadowRect withFont:font lineBreakMode:lineMode];	
		
		[[State sharedState].darkTextColor set];
		[self.title drawInRect:baseRect withFont:font lineBreakMode:lineMode];
		
		lastHeight = [self.title sizeWithFont:font constrainedToSize:baseRect.size lineBreakMode:lineMode].height;
	}
	
	// draw subtitle
	
	if ([self.subtitle length] != 0) {
		CGRect subtitleRect = CGRectOffset(baseRect, 0, lastHeight);
		CGRect subtitleShadowRect = CGRectOffset(subtitleRect, 0, 1);
		
		[[UIColor colorWithWhite:1.0 alpha:0.75] set];
		[self.subtitle drawInRect:subtitleShadowRect withFont:font lineBreakMode:UILineBreakModeWordWrap];
		
		[[UIColor colorWithRed:110.0/255.0 green:110.0/255.0 blue:110.0/255.0 alpha:1.0] set];
		[self.subtitle drawInRect:subtitleRect withFont:font lineBreakMode:UILineBreakModeWordWrap];
		
		lastRect = subtitleRect;
		lastHeight = [self.subtitle sizeWithFont:font
							   constrainedToSize:subtitleRect.size lineBreakMode:lineMode].height;
	}
	
	// draw subsubtitle
	
	if ([self.subsubtitle length] != 0) {
		CGRect subsubtitleRect = CGRectOffset(lastRect, 0, lastHeight);
		CGRect subsubtitleShadowRect = CGRectOffset(subsubtitleRect, 0, 1);
		
		[[UIColor colorWithWhite:1.0 alpha:0.75] set];
		[self.subsubtitle drawInRect:subsubtitleShadowRect withFont:font lineBreakMode:UILineBreakModeWordWrap];
		
		[[UIColor colorWithRed:110.0/255.0 green:110.0/255.0 blue:110.0/255.0 alpha:1.0] set];
		[self.subsubtitle drawInRect:subsubtitleRect withFont:font lineBreakMode:UILineBreakModeWordWrap];
		
		lastRect = subsubtitleRect;
		lastHeight = [self.subsubtitle sizeWithFont:font
								  constrainedToSize:subsubtitleRect.size
									  lineBreakMode:lineMode].height;
	}
	
	// draw rating
	
	if (self.rating) {
		CGContextRef c = UIGraphicsGetCurrentContext();
		CGFloat rating = round(self.rating / .1) * .1; // normalize rating to only show full and half stars
		
		UIImage *starsEmpty = [UIImage imageNamed:@"starsEmpty.png"];
		UIImage *starsFilled = [UIImage imageNamed:@"starsFilled.png"];
		
		CGPoint ratingOrigin = CGPointMake(lastRect.origin.x,
										   lastRect.origin.y + lastHeight + kStarsTopPadding);
		
		CGContextSaveGState(c);
		CGContextAddRect(c, CGRectMake(ratingOrigin.x, ratingOrigin.y, ceil(kStarsWidth * rating), kStarsHeight));
		CGContextClip(c);
		[starsFilled drawAtPoint:ratingOrigin];
		
		CGContextRestoreGState(c);
		CGContextAddRect(c, CGRectMake(ratingOrigin.x + kStarsWidth * rating,
									   ratingOrigin.y,
									   ceil(kStarsWidth * (1 - rating)),
									   kStarsHeight));
		CGContextClip(c);
		[starsEmpty drawAtPoint:ratingOrigin];
	}
}

- (CGRect)detailFrame {
	return CGRectMake(kDetailHeaderPhotoWidth + 2 * kDetailHeaderSidePadding,
					  2 * kDetailHeaderTopPadding + 4,
					  self.frame.size.width - kDetailHeaderPhotoWidth - 3 * kDetailHeaderSidePadding,
					  MAXFLOAT);
}

- (UIImage *)photoThumbnail {
	TTImageView *photoView = self.photoView;
	UIImage *photo;
	
	if (photoView.isLoaded) {
		photo = photoView.image;
	} else {
		photo = [UIImage imageNamed:@"detailHeaderPhotoBackgroundDefault.png"];
	}
	
	CGFloat width = kDetailHeaderPhotoWidth;
	CGFloat height = kDetailHeaderPhotoWidth * photo.size.height / photo.size.width;
	
	UIImage *thumb;
	
	UIGraphicsBeginImageContext(CGSizeMake(width, floor(height) + 1));
	CGContextRef c = UIGraphicsGetCurrentContext();
	
	// draw highlight
	[[UIColor colorWithWhite:1.0 alpha:0.5] set];
	CGContextAddRoundedRect(c, CGRectMake(0, 1, width, floor(height)), 6);
	CGContextFillPath(c);
	
	// draw photo and shadow (clipped to rounded rectangle)
	
	CGContextAddRoundedRect(c, CGRectMake(0, 0, width, floor(height)), 6);
	CGContextClip(c);
	
	[photo drawInRect:CGRectMake(0, 0, width, ceil(height))];
	
	UIImage *defaultImage = self.defaultImage;
	if (!photoView.isLoaded && defaultImage != nil) {
		[defaultImage drawAtPoint:CGPointMake(round((kDetailHeaderPhotoWidth - defaultImage.size.width) / 2.0),
											  round((kDetailHeaderPhotoHeight - defaultImage.size.height) / 2.0))];
	}
	
	UIImage *innerShadow = [[UIImage imageNamed:@"detailHeaderPhotoInnerShadow.png"]
							stretchableImageWithLeftCapWidth:9 topCapHeight:10];
	[innerShadow drawInRect:CGRectMake(0, 0, width, floor(height))
				  blendMode:kCGBlendModeNormal alpha:0.4];
	
	// save thumbnail
	
	thumb = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	
	return thumb;
}

@end
