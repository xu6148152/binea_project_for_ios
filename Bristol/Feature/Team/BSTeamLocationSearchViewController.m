//
//  BSTeamLocationSearchViewController.m
//  Bristol
//
//  Created by Yangfan Huang on 3/26/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSTeamLocationSearchViewController.h"
#import "BSQueryPlacesByNameHttpRequest.h"
#import "BSBaseTableViewCell.h"

@interface BSTeamLocationSearchViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) NSArray *cities;
@property (nonatomic) BSQueryPlacesByNameHttpRequest *request;
@end

@implementation BSTeamLocationSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	self.navigationController.navigationBarHidden = YES;
	[self.textField becomeFirstResponder];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTextChange:) name:UITextFieldTextDidChangeNotification object:self.textField];
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self.textField];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) _scheduleSearch:(NSString *)keyword {
	if (self.request) {
		[self.request cancelRequest];
		self.request = nil;
	}
	
	if (!keyword || keyword.length == 0) {
		self.cities = nil;
		[self.tableView reloadData];
		return;
	}
	
	BSQueryPlacesByNameHttpRequest *request = [BSQueryPlacesByNameHttpRequest requestWithName:keyword];
	self.request = request;
	
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		if (request != self.request) {
			return;
		}
		
		[request postRequestWithSucceedBlock:^(BSHttpResponseDataModel *result) {
			if (request == self.request) {
				self.request = nil;
				self.cities = ((BSCitiesDataModel *)result.dataModel).cities;
				[self.tableView reloadData];
			}
		} failedBlock:^(BSHttpResponseDataModel *result) {
			if (request == self.request) {
				self.request = nil;
				self.cities = nil;
				[self.tableView reloadData];
			}
		}];
	});
}

#pragma mark - Navigation
- (IBAction)onBtnBackTapped:(id)sender {
	self.navigationController.navigationBarHidden = NO;
	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onBtnSearchTapped:(id)sender {
	[self.textField resignFirstResponder];
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.cities ? self.cities.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	BSBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BSLocationNameTableViewCell" forIndexPath:indexPath];
	cell.textLabel.text = ((BSHighlightPlaceDataModel*)self.cities[indexPath.row]).nameLocalized;
	return cell;
}

#pragma - UITableViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[self.textField resignFirstResponder];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	BSHighlightPlaceDataModel *place = self.cities[indexPath.row];
	if (self.delegate) {
		[self.delegate didSelectLocationName:place.nameLocalized latitude:place.latitude longitude:place.longitude];
	}
	self.navigationController.navigationBarHidden = NO;
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextFieldDelegate
-(void) handleTextChange:(NSNotification *)notification {
	[self _scheduleSearch:self.textField.text];
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[self.textField resignFirstResponder];
	return YES;
}
@end
