//
//  ZPAssistanceActionsViewController.m
//  ZPFoundation
//
//  Created by Guichao Huang (Gary) on 10/23/14.
//  Copyright (c) 2014 Zepp US Inc. All rights reserved.
//

#import "ZPAssistanceActionsViewController.h"
#import "ZPAssistanceActionsManager.h"
#import "ZPAssistanceActionProtocol.h"
#import "UIView+Addition.h"

@interface ZPAssistanceActionTableViewCell : UITableViewCell
{
	UIView *_indicatorView;
}
@property (nonatomic, assign) BOOL isDefault;

@end

@implementation ZPAssistanceActionTableViewCell

- (void)setIsDefault:(BOOL)isDefault {
	if (_isDefault != isDefault) {
		_isDefault = isDefault;

		if (isDefault) {
			if (!_indicatorView) {
				_indicatorView = [[UIView alloc] init];
				_indicatorView.backgroundColor = [UIColor colorWithRed:.66 green:.72 blue:1 alpha:.9];
				[self addSubview:_indicatorView];
			}
		}
		_indicatorView.hidden = !isDefault;
	}
}

- (void)layoutSubviews {
	[super layoutSubviews];

	_indicatorView.frame = CGRectMake(0, 0, 5, self.height);
}

@end



#pragma mark - ZPAssistanceActionsViewController
@interface ZPAssistanceActionsViewController ()
{
	UIBarButtonItem *_editButton;
}
@end

static NSString *kDefaultCellId = @"defaultCellId";
@implementation ZPAssistanceActionsViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	self.title = @"Actions";
	_editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(_editButtonTapped)];
	self.navigationItem.rightBarButtonItem = _editButton;

	self.tableView.dataSource = self;
	self.tableView.delegate = self;
	self.tableView.allowsSelectionDuringEditing = YES;
	self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
	[self.tableView registerClass:[ZPAssistanceActionTableViewCell class] forCellReuseIdentifier:kDefaultCellId];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];

	[self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (void)_editButtonTapped {
	[self.tableView setEditing:!self.tableView.editing animated:YES];
	_editButton.title = self.tableView.editing ? @"Done" : @"Edit";
	[self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [ZPAssistanceActionsManager sharedInstance].actions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	ZPAssistanceActionTableViewCell *cell = (ZPAssistanceActionTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kDefaultCellId forIndexPath:indexPath];

	NSObject <ZPAssistanceActionProtocol> *action = [ZPAssistanceActionsManager sharedInstance].actions[indexPath.row];
	cell.textLabel.text = action.name;
	cell.selectionStyle = UITableViewCellSelectionStyleDefault;
	if (tableView.editing) {
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	else {
		cell.accessoryType = [action conformsToProtocol:@protocol(ZPAssistanceMultipleActions)] ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
	}
	cell.isDefault = [ZPAssistanceActionsManager sharedInstance].defaultAction == action;

	return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
	if (tableView.editing) {
		return @"Select default action in status bar";
	}
	else
		return nil;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableview shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)tableView:(UITableView *)tableview canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (tableView.editing) {
		[[ZPAssistanceActionsManager sharedInstance] setDefaultActionIndex:indexPath.row];
		[tableView reloadData];
	}
	else {
		NSObject <ZPAssistanceActionProtocol> *action = [ZPAssistanceActionsManager sharedInstance].actions[indexPath.row];
		if ([action conformsToProtocol:@protocol(ZPAssistanceSingleAction)]) {
			[(NSObject < ZPAssistanceSingleAction > *) action performAction];

			[tableView deselectRowAtIndexPath:indexPath animated:YES];
		}
		else if ([action conformsToProtocol:@protocol(ZPAssistanceMultipleActions)]) {
			[(NSObject < ZPAssistanceMultipleActions > *) action performActionWithNavigationController : self.navigationController animated : YES];
		}
	}
}

@end
