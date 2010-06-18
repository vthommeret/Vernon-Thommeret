//
//  DetailHeaderViewButton.h
//  Meetup
//
//  Created by Vernon Thommeret on 8/26/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
	DetailHeaderViewButtonStyleNormal,
	DetailHeaderViewButtonStyleInfo
} DetailHeaderViewButtonStyle;

@interface DetailHeaderViewButton : UIControl {
	NSString *_title;
	DetailHeaderViewButtonStyle _style;
}

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) DetailHeaderViewButtonStyle style;

- (CGSize)sizeThatFitsTitle:(NSString *)title;
- (void)enable;
- (void)disable;

@end
