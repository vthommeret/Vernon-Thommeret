//
//  MeetupAsyncRequest.h
//  Meetup
//
//  Created by Vernon Thommeret on 7/17/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Allows you to execute an asynchronous request against the Meetup API. The response,
 if successful, is delivered to the delegate's callback.
 */
@interface MeetupAsyncRequest : NSObject {
	NSMutableData *_receivedData;
	NSURLRequest *_urlRequest;
	NSURLConnection *_urlConnection;
	id _delegate;
	SEL _callback;
	SEL _errorCallback;
}

@property (nonatomic, retain) NSMutableData *receivedData;
@property (nonatomic, retain) NSURLRequest *urlRequest;
@property (nonatomic, retain) NSURLConnection *urlConnection;
@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) SEL callback;
@property (nonatomic, assign) SEL errorCallback;

- (void) doMethod:(NSString *)method withParams:(NSString *)params;

@end
