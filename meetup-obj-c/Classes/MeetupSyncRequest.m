//
//  MeetupSyncRequest.m
//  Meetup
//
//  Created by Vernon Thommeret on 7/17/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import "MeetupSyncRequest.h"
#import "JSON.h"

@implementation MeetupSyncRequest

+ (NSDictionary *) doMethod:(NSString *)method withParams:(NSString *)params {
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/?%@&key=%@",
									   kService, method, params, kApiKey]];
	NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
	
	NSData *urlData;
	NSURLResponse *response;
	NSError *error;
	urlData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
	
	NSString *responseString = [[NSString alloc] initWithData:urlData encoding:NSASCIIStringEncoding];
	NSLog(@"%@", responseString);
	NSDictionary *responseDict = [responseString JSONValue];
	[responseString release];
	
	return responseDict;
}

@end
