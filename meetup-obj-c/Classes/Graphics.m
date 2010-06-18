//
//  Graphics.m
//  Meetup
//
//  Created by Vernon Thommeret on 8/23/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import "Graphics.h"

/**
 Found here: http://www.iphonedevforums.com/forum/sdk-coding-help/200-problem-make-rounded-rectangle.html
 */
void CGContextAddRoundedRect (CGContextRef c, CGRect rect, int corner_radius) {
	int x_left = rect.origin.x;
	int x_left_center = rect.origin.x + corner_radius;
	int x_right_center = rect.origin.x + rect.size.width - corner_radius;
	int x_right = rect.origin.x + rect.size.width;
	int y_top = rect.origin.y;
	int y_top_center = rect.origin.y + corner_radius;
	int y_bottom_center = rect.origin.y + rect.size.height - corner_radius;
	int y_bottom = rect.origin.y + rect.size.height;
	
	// begin
	CGContextBeginPath(c);
	CGContextMoveToPoint(c, x_left, y_top_center);
	
	// first corner
	CGContextAddArcToPoint(c, x_left, y_top, x_left_center, y_top, corner_radius);
	CGContextAddLineToPoint(c, x_right_center, y_top);
	
	// second corner
	CGContextAddArcToPoint(c, x_right, y_top, x_right, y_top_center, corner_radius);
	CGContextAddLineToPoint(c, x_right, y_bottom_center);
	
	// third corner
	CGContextAddArcToPoint(c, x_right, y_bottom, x_right_center, y_bottom, corner_radius);
	CGContextAddLineToPoint(c, x_left_center, y_bottom);
	
	// fourth corner
	CGContextAddArcToPoint(c, x_left, y_bottom, x_left, y_bottom_center, corner_radius);
	CGContextAddLineToPoint(c, x_left, y_top_center);
	
	// done
	CGContextClosePath(c);
}
