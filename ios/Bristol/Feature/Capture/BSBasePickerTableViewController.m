//
//  BSBasePickerTableViewController.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 2/3/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSBasePickerTableViewController.h"

@interface BSBasePickerTableViewController ()
{
    NSArray *_aryObjects;
}

@end

@implementation BSBasePickerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self.tableView registerNib:[UINib nibWithNibName:BSBasePickerTableViewCell.className bundle:nil] forCellReuseIdentifier:BSBasePickerTableViewCell.className];
    _aryObjects = [self getObjectsToBind];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
	[self _selectSelectedCell];
}

- (void)setSelectedObject:(id)selectedObject {
    if (_selectedObject != selectedObject) {
        _selectedObject = selectedObject;
        ZPInvokeBlock(_selectedObjectDidChangedBlock, selectedObject);
    }
    
    [self _selectSelectedCell];
}

- (void)_selectSelectedCell {
    if ([_aryObjects containsObject:_selectedObject]) {
        _selectedObjectIndex = [_aryObjects indexOfObject:_selectedObject] + 1;
    }
	if (_selectedObjectIndex >= (_aryObjects.count + 1)) {
		_selectedObjectIndex = 0;
	}
	[self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:_selectedObjectIndex inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
}

- (NSArray *)getObjectsToBind {
    NSAssert(NO, OverwriteRequiredMessage);
    return nil;
}

- (void)reloadData {
    _aryObjects = [self getObjectsToBind];
    [self.tableView reloadData];
    
    [self _selectSelectedCell];
}

- (void)configCell:(BSBasePickerTableViewCell *)cell withObject:(id)object {
    NSAssert(NO, OverwriteRequiredMessage);
}

- (id)getObjectAtIndexPath:(NSIndexPath *)indexPath {
    id object = nil;
    if (indexPath.row == 0) {
        object = nil;
    } else {
        object = _aryObjects[indexPath.row - 1];
    }
    return object;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _aryObjects.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BSBasePickerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BSBasePickerTableViewCell.className forIndexPath:indexPath];
    
    [self configCell:cell withObject:[self getObjectAtIndexPath:indexPath]];
	[cell setIsHighlight:_selectedObjectIndex == indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_selectedObjectIndex != indexPath.row) {
        BSBasePickerTableViewCell *cellOld = (BSBasePickerTableViewCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:_selectedObjectIndex inSection:indexPath.section]];
        [cellOld setIsHighlight:NO];
        
        BSBasePickerTableViewCell *cellNew = (BSBasePickerTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        [cellNew setIsHighlight:YES];
        
        _selectedObjectIndex = indexPath.row;
        ZPInvokeBlock(_selectedObjectDidChangedBlock, [self getObjectAtIndexPath:indexPath]);
    }
	[self.navigationController popViewControllerAnimated:YES];
}

@end
