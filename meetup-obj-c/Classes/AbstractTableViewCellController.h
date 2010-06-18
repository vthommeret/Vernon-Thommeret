//
//  AbstractTableViewCellController.h
//  Meetup
//
//  Created by Vernon Thommeret on 8/13/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AbstractTableViewCellController : NSObject {
	UINavigationController *_navigationController;
	NSString *_key;
}

@property (nonatomic, assign) UINavigationController *navigationController;
@property (nonatomic, copy) NSString *key;

@end
