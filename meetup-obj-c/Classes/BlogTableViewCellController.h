//
//  BlogTableViewCellController.h
//  Meetup
//
//  Created by Vernon Thommeret on 8/14/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractTableViewCellController.h"

@interface BlogTableViewCellController : AbstractTableViewCellController {
	NSString *_content;
}

@property (nonatomic, retain) NSString *content;

@end
