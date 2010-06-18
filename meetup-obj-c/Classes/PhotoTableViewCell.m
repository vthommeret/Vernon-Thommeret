//
//  PhotoTableViewCell.m
//  Meetup
//
//  Created by Vernon Thommeret on 8/18/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import "Three20/Three20.h"
#import "PhotoTableViewCell.h"

@implementation PhotoTableViewCell

@synthesize defaultImage = _defaultImage;
@synthesize photoUrl = _photoUrl;
@synthesize content = _content;
@synthesize photo = _photo;
@synthesize photoRequest = _photoRequest;

- (void)dealloc {
	[_defaultImage release];
	[_photoUrl release];
	[_content release];
	[_photo release];
	[_photoRequest release];
    [super dealloc];
}

- (id)initWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
		reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithTableView:tableView indexPath:indexPath reuseIdentifier:reuseIdentifier]) {
		PhotoTableViewCellView *cellView = [[PhotoTableViewCellView alloc]
										initWithFrame:CGRectZero parentCell:self];
		
		cellView.frame = [[self class] cellFrameWithTableView:self.tableView indexPath:self.indexPath];
		
		[self.contentView addSubview:cellView];
		self.cellView = cellView;
		[cellView release];
	}
	return self;
}

- (void)prepareForReuse {
	[self.photoRequest cancel];
	[_photoRequest release];
	_photoRequest = nil;
	
	[_photo release];
	_photo = nil;
	 
	self.cellView.frame = [[self class] cellFrameWithTableView:self.tableView indexPath:self.indexPath];
}

- (void)setContent:(NSString *)content {
	if (content != _content) {
		[_content release];
		_content = [content copy];
	}
	
	[self.cellView setNeedsDisplay];
}

- (void)setPhotoUrl:(NSString *)photoUrl {
	if (photoUrl != _photoUrl) {
		[_photoUrl release];
		_photoUrl = [photoUrl copy];
	}
	
	if ([photoUrl length] != 0) {
		UIImage *photo = [[TTURLCache sharedCache] imageForURL:photoUrl];
		
		if (photo != nil) {
			self.photo = photo;
		} else {
			TTURLRequest *photoRequest = [TTURLRequest requestWithURL:self.photoUrl delegate:self];
			
			TTURLImageResponse *response = [[TTURLImageResponse alloc] init];
			photoRequest.response = response;
			[response release];
			
			if ([photoRequest send]) { // if the image can be returned synchronously
				self.photo = ((TTURLImageResponse *) photoRequest.response).image;
				[self.cellView setNeedsDisplay];
			} else {
				self.photoRequest = photoRequest;
			}
		}

	}
}

#pragma mark -
#pragma mark TTURLRequestDelegate Methods

- (void)requestDidFinishLoad:(TTURLRequest *)request {
	self.photo = ((TTURLImageResponse *) request.response).image;
	
	[_photoRequest release];
	_photoRequest = nil;
	
	[self.cellView setNeedsDisplay];
}

+ (NSString *)baseIdentifier {
	return @"Photo";
}

+ (CGRect)cellFrameWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
	return [[self class] cellFrameWithContentHeight:kRowPhotoSize tableView:tableView indexPath:indexPath];
}

@end

#pragma mark -
#pragma mark PhotoTableViewCellView Implementation

@implementation PhotoTableViewCellView

static NSMutableDictionary *_thumbs;

- (id)initWithFrame:(CGRect)frame parentCell:(AbstractTableViewCell *)parentCell {
	if (self = [super initWithFrame:frame parentCell:parentCell]) {
		self.fontSize = 15.0;
	}
	return self;
}

- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
	
	CGContextRef c = UIGraphicsGetCurrentContext();	
	
	_highlighted ? [[UIColor colorWithWhite:1.0 alpha:.05] set] : [[UIColor colorWithWhite:0.0 alpha:.05] set];
	CGContextFillRect(c, CGRectMake(0, 0, kRowPhotoSize, kRowPhotoSize));
	
	// quartz centers strokes on the coordinates, so in order to draw a pixel perfect line
	// we need to draw it at x.5 rather than x.0
	_highlighted ? [[UIColor colorWithWhite:1.0 alpha:.1] set] : [[UIColor colorWithWhite:0.0 alpha:.1] set];
	CGContextBeginPath(c);
	CGContextMoveToPoint(c, kRowPhotoSize + 0.5, 0);
	CGContextAddLineToPoint(c, kRowPhotoSize + 0.5, kRowPhotoSize);
	CGContextStrokePath(c);
	
	PhotoTableViewCell *parentCell = (PhotoTableViewCell *) self.parentCell;
	
	UIImage *photo = parentCell.photo;
	if (photo != nil) {
		UIImage *thumb = [[self class] thumbWithImage:photo url:parentCell.photoUrl];
		[thumb drawAtPoint:CGPointMake(0, 0)];
	} else {
		UIImage *defaultImage;
		
		if (_highlighted) {
			defaultImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@Selected.png", parentCell.defaultImage]];
		} else {
			defaultImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", parentCell.defaultImage]];
		}
		
		[defaultImage drawAtPoint:CGPointMake((int) ((kRowPhotoSize - defaultImage.size.width) / 2.0),
											  (int) ((kRowPhotoSize - defaultImage.size.height) / 2.0) + 1.0)];
	}
	
	// draw text
	
	CGPoint insetOrigin = [[parentCell class] insetOriginForTableView:parentCell.tableView];
	CGFloat insetWidth = [[parentCell class] insetWidthForTableView:parentCell.tableView
												  withAccessoryType:parentCell.accessoryType];
	
	insetOrigin = CGPointMake(insetOrigin.x + kRowPhotoSize, insetOrigin.y);
	insetWidth = insetWidth - kRowPhotoSize;
	
	_highlighted ? [[UIColor whiteColor] set] : [[UIColor blackColor] set];
	
	UIFont *groupFont = [UIFont boldSystemFontOfSize:self.fontSize];
	
	CGFloat textHeight = [parentCell.content sizeWithFont:groupFont
										   constrainedToSize:CGSizeMake(insetWidth, kRowPhotoSize - 2 * insetOrigin.y)
											   lineBreakMode:UILineBreakModeTailTruncation].height;
	
	[parentCell.content drawInRect:CGRectMake(insetOrigin.x, (kRowPhotoSize - textHeight) / 2.0, insetWidth, textHeight)
							 withFont:groupFont
						lineBreakMode:UILineBreakModeTailTruncation];
}

+ (UIImage *)thumbWithImage:(UIImage *)image url:(NSString *)url {
	if (_thumbs == nil) {
		_thumbs = [[NSMutableDictionary alloc] initWithCapacity:20];
	}
	
	UIImage *thumb = [_thumbs objectForKey:url];
	
	if (thumb == nil) {		
		CGFloat width, height;
		
		if (image.size.width > image.size.height) {
			width = ceil(kRowPhotoSize * image.size.width / image.size.height);
			height = kRowPhotoSize;
		} else {
			width = kRowPhotoSize;
			height = ceil(kRowPhotoSize * image.size.height / image.size.width);
		}
		
		UIGraphicsBeginImageContext(CGSizeMake(kRowPhotoSize, kRowPhotoSize));
		
		[image drawInRect:CGRectMake(0, 0, width, height)];
		
		thumb = UIGraphicsGetImageFromCurrentImageContext();
		
		UIGraphicsEndImageContext();
		
		if (thumb != nil) {			
			[_thumbs setObject:thumb forKey:url];
		}
	}
	
	return thumb;
}

@end
