//
//  RootTableViewCellController.h
//  Tabletest
//
//  Created by Vernon Thommeret on 7/30/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractTableViewCellController.h"

@interface UploadPhotoTableViewCellController : AbstractTableViewCellController {
	NSString *_content;
}

@property (nonatomic, retain) NSString *content;

@end
