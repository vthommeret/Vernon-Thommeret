//
//  MeetupSyncRequest.h
//  Meetup
//
//  Created by Vernon Thommeret on 7/17/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Allows you to execute a synchronous request against the Meetup API. This method
 generally should not be used as it is blocking.
 */
@interface MeetupSyncRequest : NSObject {}

+ (NSDictionary *) doMethod:(NSString *)method withParams:(NSString *)params;

@end
