//
//  Annotation.h
//  Meetup
//
//  Created by Vernon Thommeret on 7/22/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface Annotation : NSObject <MKAnnotation> {
	CLLocationCoordinate2D _coordinate;
	NSString *_title;
	NSString *_subtitle;
}

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@end
