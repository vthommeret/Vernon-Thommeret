//
//  MeetupAsyncRequest.m
//  Meetup
//
//  Created by Vernon Thommeret on 7/17/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import "MeetupAsyncRequest.h"
#import "JSON.h"

@implementation MeetupAsyncRequest

@synthesize receivedData = _receivedData;
@synthesize urlRequest = _urlRequest;
@synthesize urlConnection = _urlConnection;
@synthesize delegate = _delegate;
@synthesize callback = _callback;
@synthesize errorCallback = _errorCallback;

- (void)dealloc {
	[_urlConnection release];
	[_receivedData release];
	[_urlRequest release];
	[super dealloc];
}

- (void)doMethod:(NSString *)method withParams:(NSString *)params {
	NSURL *jsonURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/?%@&key=%@",
										   kService, method, params, kApiKey]];
	
	NSLog(@"requesting %@", jsonURL);
	
	NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:jsonURL];
	NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
	
	if (urlConnection)
		self.receivedData = [NSMutableData data];
	
	self.urlRequest = urlRequest;
	self.urlConnection = urlConnection;
	
	[urlRequest release];
	[urlConnection release];
}

#pragma mark -
#pragma mark URL Connection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[self.receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[self.receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	[_urlConnection release];
	[_receivedData release];
	[_urlRequest release];
	
	_urlConnection = nil;
	_receivedData = nil;
	_urlRequest = nil;
	
	if (self.delegate && self.errorCallback) {
		[self.delegate performSelector:self.errorCallback withObject:error];
	}
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {	
	if (self.delegate && self.callback) {
		if ([self.delegate respondsToSelector:self.callback]) {
			NSString *strResponse = [[NSString alloc] initWithData:self.receivedData encoding:NSASCIIStringEncoding];
			
			NSDictionary *jsonResponse = [strResponse JSONValue];
			[strResponse release];
			
			if (jsonResponse) {
				[self.delegate performSelector:self.callback withObject:jsonResponse];
			} else if (self.delegate && self.errorCallback) {
				[self.delegate performSelector:self.errorCallback withObject:nil];
			}

		}
	}
	
	[_urlConnection release];
	[_receivedData release];
	[_urlRequest release];
	
	_urlConnection = nil;
	_receivedData = nil;
	_urlRequest = nil;
}

@end
