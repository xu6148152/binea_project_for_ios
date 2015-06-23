//
//  BSBasePickerTableViewController.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 2/3/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSBaseViewController.h"
#import "BSBasePickerTableViewCell.h"

typedef void (^SelectedObjectDidChangeBlock) (id object);

@interface BSBasePickerTableViewController : BSBaseTableViewController
{
	@protected
	NSUInteger _selectedObjectIndex;
}
@property(nonatomic, strong) id selectedObject;
@property(nonatomic, strong) SelectedObjectDidChangeBlock selectedObjectDidChangedBlock;

- (NSArray *)getObjectsToBind;
- (void)reloadData;
- (void)configCell:(BSBasePickerTableViewCell *)cell withObject:(id )object;

- (id)getObjectAtIndexPath:(NSIndexPath *)indexPath;

@end
