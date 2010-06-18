//
//  AbstractTableViewController.m
//  TableCommon
//
//  Created by Vernon Thommeret on 8/11/09.
//  Copyright 2009 Vernon Thommeret. All rights reserved.
//

#import "AbstractTableViewController.h"
#import "State.h"

@implementation AbstractTableViewController

@synthesize tableView = _tableView;
@synthesize style = _style;
@synthesize tableItems = _tableItems;
@synthesize tableHeaders = _tableHeaders;
@synthesize headerViews = _headerViews;
@synthesize parentController = _parentController;

// Provides data for table view controller; should be overidden by sublass
- (void) constructTableItems {}

// Releases the table group data (it will be recreated when next needed)
- (void) clearTableItems {
	[_tableItems release];
	[_tableHeaders release];
	
	_tableItems = nil;
	_tableHeaders = nil;
}

// Performs all work needed to refresh the data and the associated display
- (void) updateAndReload {
	[self clearTableItems];
	[self constructTableItems];
	[self.tableView reloadData];
}

#pragma mark -
#pragma mark Initialization and deallocation

- (id)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithNibName:nil bundle:nil]) {
		self.style = style;
    }
    return self;
}

- (void) dealloc {
	[self clearTableItems];
	[_headerViews release];
	[super dealloc];
}

- (void) didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];	
	[self clearTableItems];
}

#pragma mark -
#pragma mark View configuration

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	CGRect screenBounds = [UIScreen mainScreen].applicationFrame;
	
	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenBounds.size.width,
															screenBounds.size.height - kTopBarHeight - kTabBarHeight)];
	view.backgroundColor = [State sharedState].grayBackgroundColor;
	self.view = view;
	[view release];
}

#define kTopSeparatorColor	160.0 / 255.0

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	UIImageView *headerShadow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"headerShadow.png"]];
	
	CGRect screenBounds = [UIScreen mainScreen].applicationFrame;
	UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenBounds.size.width,
																		   screenBounds.size.height - kTopBarHeight - kTabBarHeight)
														  style:self.style];
	tableView.delegate = tableView.dataSource = self;
	
	tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	
	if (self.style == UITableViewStylePlain) {		
		// if the first section has a header, then add a 1px gray line to the
		// top of the table view and inset the table view content up 1px
		NSString *firstSectionTitle = [tableView.dataSource tableView:tableView titleForHeaderInSection:0];
		NSInteger topContentInset = 0;
		
		if (![firstSectionTitle isEqual:@""]) {
			topContentInset = -1;
			
			UIColor *topSeparatorColor = [[UIColor alloc] initWithRed:kTopSeparatorColor
																green:kTopSeparatorColor
																 blue:kTopSeparatorColor alpha:1];
			
			UIView *topSeparatorLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
			topSeparatorLine.backgroundColor = topSeparatorColor;
			
			tableView.tableHeaderView = topSeparatorLine;
			
			[topSeparatorColor release];
			[topSeparatorLine release];
		}
		
		// add a shadow below the table
		UIImageView *tableFooter = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"plainTableFooter.png"]];
		tableView.tableFooterView = tableFooter;
		[tableFooter release];
		
		tableView.backgroundColor = [UIColor clearColor];
		tableView.contentInset = UIEdgeInsetsMake(topContentInset, 0, -12, 0);
		
		[self.view addSubview:headerShadow];
		[self.view addSubview:tableView];
	} else { // self.style == UITableViewStyleGrouped
		tableView.backgroundColor = [State sharedState].grayBackgroundColor;
		tableView.contentInset = UIEdgeInsetsMake(4, 0, 12, 0);
		tableView.sectionFooterHeight = 0;
		
		[self.view addSubview:tableView];
		[self.view addSubview:headerShadow];
	}
	
	self.tableView = tableView;
	[tableView release];
	[headerShadow release];
}

- (void)viewDidUnload {
	[super viewDidUnload];
	self.tableView = nil;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self.tableView flashScrollIndicators];
}

#pragma mark -
#pragma mark Table View Delegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	if (tableView.style == UITableViewStylePlain) {
		return 26.0;
	} else { // tableView.style == UITableViewStyleGrouped
		return 38.0;
	}
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	NSString *title = [self tableView:tableView titleForHeaderInSection:section];
	
	if ([title isEqual:@""]) {
		return nil;
	} else {
		if (self.headerViews == nil) {
			NSMutableDictionary *headerViews = [[NSMutableDictionary alloc] initWithCapacity:10];
			self.headerViews = headerViews;
			[headerViews release];
		}
		
		AbstractSectionHeaderView *headerView = [self.headerViews objectForKey:title];
		
		if (headerView == nil) {
			AbstractSectionHeaderView *headerView;
			
			if (tableView.style == UITableViewStylePlain) {
				headerView = [[PlainSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
			} else { // tableView.style == UITableViewStyleGrouped
				headerView = [[GroupedSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
			}
			
			headerView.title = title;
			
			if (headerView != nil) {
				[self.headerViews setObject:headerView forKey:title];
			}
			
			return [headerView autorelease];
		} else {
			return headerView;
		}
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (!self.tableItems) [self constructTableItems];
	
	NSObject<TableViewCellController> *cellData = [[self.tableItems objectAtIndex:indexPath.section]
												   objectAtIndex:indexPath.row];
	
	return [cellData tableView:tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath];
}

// forward tableView:didSelectRowAtIndexPath: to a cell controller
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (!self.tableItems) [self constructTableItems];
	
	NSObject<TableViewCellController> *cellData = [[self.tableItems objectAtIndex:indexPath.section]
												   objectAtIndex:indexPath.row];
	
	if ([cellData respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
		[cellData tableView:tableView didSelectRowAtIndexPath:indexPath];
	}
}

#pragma mark -
#pragma mark Table View Data Source Methods

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (!self.tableItems) [self constructTableItems];
	
	if ([self.tableHeaders count] == 0 || [[self.tableItems objectAtIndex:section] count] == 0) {
		return @"";
	} else {
		return [self.tableHeaders objectAtIndex:section];
	}
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
	if (!self.tableItems) [self constructTableItems];
	return [self.tableItems count];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (!self.tableItems) [self constructTableItems];
	return [[self.tableItems objectAtIndex:section] count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (!self.tableItems) [self constructTableItems];
	
	UITableViewCell *cell = [[[self.tableItems objectAtIndex:indexPath.section]
							  objectAtIndex:indexPath.row] tableView:(UITableView *)tableView
							 cellForRowAtIndexPath:indexPath];
	
	UIView *emptyView = [[UIView alloc] initWithFrame:CGRectZero];
	cell.backgroundView = emptyView;
	cell.selectedBackgroundView = emptyView;
	[emptyView release];
	
	return cell;
}

@end

#pragma mark -
#pragma mark AbstractSectionHeaderView Implementation

@implementation AbstractSectionHeaderView

@synthesize title = _title;

- (void)dealloc {
	[_title release];
	[super dealloc];
}

@end

#pragma mark -
#pragma mark PlainSectionHeaderView Implementation

@implementation PlainSectionHeaderView

- (void)drawRect:(CGRect)rect {
	// draw the background
	[[UIImage imageNamed:@"plainSectionHeader.png"] drawAtPoint:CGPointMake(0, 0)];
	
	// draw the shadow
	[[UIColor colorWithRed:142./255 green:146./255 blue:147./255 alpha:1] set];
	[self.title drawAtPoint:CGPointMake(12, 3) withFont:[UIFont boldSystemFontOfSize:16.0]];
	
	// draw the text
	[[UIColor whiteColor] set];
	[self.title drawAtPoint:CGPointMake(12, 2) withFont:[UIFont boldSystemFontOfSize:16.0]];
}

@end

#pragma mark -
#pragma mark GroupedSectionHeaderView Implementation

@implementation GroupedSectionHeaderView

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		self.backgroundColor = [State sharedState].grayBackgroundColor;
	}
	
	return self;
}

#define kGroupedSectionHeaderTextColor	89.0 / 255.0

- (void)drawRect:(CGRect)rect {
	// first draw a white shadow
	[[UIColor colorWithWhite:1 alpha:.5] set];
	[self.title drawAtPoint:CGPointMake(18.0, 10) withFont:[UIFont boldSystemFontOfSize:17.0]];
	
	// then draw the dark text
	[[UIColor colorWithRed:kGroupedSectionHeaderTextColor
					 green:kGroupedSectionHeaderTextColor
					  blue:kGroupedSectionHeaderTextColor
					 alpha:1.0] set];
	[self.title drawAtPoint:CGPointMake(18.0, 9) withFont:[UIFont boldSystemFontOfSize:17.0]];
}

@end
