//
//  AbstractViewController.h
//  TableCommon
//
//  Created by Vernon Thommeret on 8/11/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AbstractTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
	UITableView *_tableView;
	UITableViewStyle _style;
	NSMutableArray *_tableHeaders;
	NSMutableArray *_tableItems;
	NSMutableDictionary *_headerViews;
	UIViewController *_parentController;
}

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, assign) UITableViewStyle style;
@property (nonatomic, retain) NSMutableArray *tableHeaders;
@property (nonatomic, retain) NSMutableArray *tableItems;
@property (nonatomic, retain) NSMutableDictionary *headerViews;
@property (nonatomic, assign) UIViewController *parentController;

- (id)initWithStyle:(UITableViewStyle)style;
- (void) updateAndReload;

@end

#pragma mark -
#pragma mark PlainSectionHeaderView and GroupedSectionHeaderView Interfaces

@interface AbstractSectionHeaderView : UIView
{
	NSString *_title;
}

@property (nonatomic, copy) NSString *title;

@end

@interface PlainSectionHeaderView : AbstractSectionHeaderView
@end

@interface GroupedSectionHeaderView : AbstractSectionHeaderView
@end

#pragma mark -
#pragma mark TableViewCellController Protocol

/*
 A protocol that our TableViewCellControllers should conform to. We delegate our table view
 data source and delegate methods to individual, specialized table view cell controllers rather
 than sticking all the code in the table view controller. See Matt Gallagher's article about
 hetereogeneous table view cells above.
 */
@protocol TableViewCellController

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

@optional

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end
