//
//  BSFeedCommentsViewController.m
//  Bristol
//
//  Created by Bo on 1/20/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSFeedCommentsViewController.h"
#import "BSFeedCommentTableViewCell.h"
#import  "BSLikeTableViewCell.h"
#import "BSProfileViewController.h"
#import "BSFeedFollowedTableViewCell.h"

#import "BSHighlightAllCommentsHttpRequest.h"
#import "BSUserInfoWithUsernameHttpRequest.h"
#import "BSHighlightCommentHttpRequest.h"
#import "BSHighlightCommentsDataModel.h"
#import "BSUserFollowersHttpRequest.h"
#import "BSUserFollowingHttpRequest.h"
#import "BSHighlightMO.h"
#import "BSCommentMO.h"

#import "BSEventTracker.h"

#import "NSDate+Utilities.h"

typedef NS_ENUM(NSUInteger, BSTableViewModel)
{
    BSTableViewModel_Comments,
    BSTableViewModel_Follower,
};

@interface BSFeedCommentsViewController () <UITextViewDelegate, BSFeedCommentTableViewCellDelegate>

@property (nonatomic, strong) BSHighlightMO *highlight;
@property (nonatomic, assign) BOOL showKeyboard;

@property (weak, nonatomic) IBOutlet UITableView *commentsTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *postViewBottomLayoutConstraint;
@property (weak, nonatomic) IBOutlet UIView *postCommentsView;
@property (weak, nonatomic) IBOutlet UIButton *postBtn;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (weak, nonatomic) IBOutlet UILabel *allowCommentsLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSMutableArray *commentsAry;
@property (strong, nonatomic) NSMutableArray *userAry;
@property (strong, nonatomic) NSIndexPath *cellIndexPath;
@property (nonatomic, assign) NSInteger lastCommentId;
@property (strong, nonatomic) NSNumber *highlightID;
@property (assign, nonatomic) BSTableViewModel tableViewModel;
@property (assign, nonatomic) NSInteger atLetterLocation;
@property (strong, nonatomic) NSMutableArray *findfollowerAry;
@property (strong, nonatomic) NSMutableArray *findTest;
@property (assign, nonatomic) BOOL isTextAtUser;
@property (strong, nonatomic) NSString *commentText;
@property (nonatomic, assign) NSUInteger numberOfLines;

@end

#define kMaximumNumberOfLines 6
#define kUserCellBackGroundColor [UIColor colorWithRed:232.0/255.0f green:232.0/255.0f blue:232.0/255.0f alpha:1]
#define kUserNameLblBackGroundColor [UIColor colorWithRed:133.0/255.0f green:133.0/255.0f blue:133.0/255.0f alpha:1]
#define kCommentCellBackGroundColor [UIColor colorWithRed:193.0/255.0f green:225.0/255.0f blue:0.0/255.0f alpha:1]
#define KCommentDisabledColor [UIColor colorWithRed:207.0/255.0f green:207.0/255.0f blue:207.0/255.0f alpha:1]

@implementation BSFeedCommentsViewController

+ (instancetype)instanceFromStoryboard {
	return [[UIStoryboard storyboardWithName:@"Feed" bundle:nil] instantiateViewControllerWithIdentifier:@"BSFeedCommentsViewController"];
}

+ (instancetype)instanceWithHighlight:(BSHighlightMO *)highlight showKeyboard:(BOOL)showKeyboard {
	BSFeedCommentsViewController *vc = [BSFeedCommentsViewController instanceFromStoryboard];
	vc.highlight = highlight;
	vc.showKeyboard = showKeyboard;
	
	return vc;
}

- (void)viewDidLoad {
	[super viewDidLoad];

	self.title = ZPLocalizedString(@"COMMENTS").uppercaseString;
    self.findfollowerAry = [[NSMutableArray alloc] init];
    self.findTest = [[NSMutableArray alloc] init];
	self.commentTextView.textColor = KCommentDisabledColor;
    self.commentTextView.textContainer.maximumNumberOfLines = kMaximumNumberOfLines;
	[self.commentsTableView setGlobalUI];
	self.postBtn.enabled = NO;

	self.refreshControl = [[UIRefreshControl alloc] init];
	[self.refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
	[self.commentsTableView addSubview:self.refreshControl];
    
	if (_highlight.is_can_commentValue) {
		if (self.showKeyboard) {
			[self.commentTextView becomeFirstResponder];
		}
	} else {
		self.commentTextView.hidden = YES;
		self.allowCommentsLbl.hidden = NO;
		self.postBtn.enabled = NO;
		[self.allowCommentsLbl setText:@"Only friend can comment."];
		[self.postBtn setImage:[UIImage imageNamed:@"profile_private_icon"] forState:UIControlStateDisabled];
		[self.postBtn setTitle:@"" forState:UIControlStateDisabled];
	}

    [self refreshData];
    
    [_commentsTableView registerNib:[UINib nibWithNibName:BSFeedFollowedTableViewCell.className bundle:nil] forCellReuseIdentifier:BSFeedFollowedTableViewCell.className];
    
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
	
    [self.tabBarController.tabBar setHidden:YES];
    [self.commentsTableView reloadData];
    
    NSData *data = [UserDefaults objectForKey:kDraftData];
    if (data) {
        NSMutableDictionary *draftDic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        self.highlightID = self.highlight.identifier;
        if (draftDic) {
            NSString *draft = [draftDic objectForKey:self.highlightID];
            if (draft && draft.length > 0) {
                self.commentTextView.text = draft;
            }
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];

    NSString *draft = [self.commentTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSData *data = [UserDefaults objectForKey:kDraftData];
    NSMutableDictionary *draftDic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    self.highlightID = self.highlight.identifier;
    
    if (!draftDic) {
        draftDic = [[NSMutableDictionary alloc] init];
    }
    
    if (draft && draft.length > 0) {
        [draftDic setObject:draft forKey:self.highlightID];
    } else {
        if ([draftDic objectForKey:self.highlightID]) {
            [draftDic setObject:@"" forKey:self.highlightID];
        }
    }
    
    [UserDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:draftDic] forKey:kDraftData];
    [UserDefaults synchronize];
}

#pragma mark - Pull to refresh the view
- (void)refreshData {
	if (self.highlight) {
		BSHighlightAllCommentsHttpRequest *request = [BSHighlightAllCommentsHttpRequest request];
		request.highlightId = [self.highlight.identifier integerValue];
		request.olderThanCommentId = self.lastCommentId;
		[request postRequestWithSucceedBlock: ^(BSHttpResponseDataModel *result) {
		    BSHighlightCommentsDataModel *commentsDataModel = result.dataModel;
            for (BSCommentMO *comment in commentsDataModel.comments) {
                [_highlight addCommentsObject:comment];
            }
            self.highlight.comments_count = @(self.highlight.commentsSet.count);
            [[BSDataManager sharedInstance] save];
			NSArray *sortedComments = [commentsDataModel.comments sortedArrayUsingComparator:^NSComparisonResult(id  __nonnull obj1, id  __nonnull obj2) {
				return [((BSCommentMO *)obj1).created_at isLaterThanDate:((BSCommentMO *)obj2).created_at];
			}];
            self.commentsAry = [NSMutableArray arrayWithArray:sortedComments];
            
            BSCommentMO *highlightMessage = [BSCommentMO createEntity];
            highlightMessage.content = self.highlight.message;
            highlightMessage.created_at = self.highlight.created_at;
            highlightMessage.user = self.highlight.user;
            
            [self.commentsAry insertObject:highlightMessage atIndex:0];
            [self.commentsTableView reloadData];
			[self.commentsTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.commentsAry.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
			
		    [self.refreshControl endRefreshing];
		} failedBlock: ^(BSHttpResponseDataModel *result) {
		    [self.refreshControl endRefreshing];
		}];
	}
}

- (void)_pulldownRefreshComments {
    [self.refreshControl beginRefreshing];
    [self.commentsTableView setContentOffset:CGPointMake(0, -self.refreshControl.height - [UIApplication sharedApplication].statusBarFrame.size.height) animated:YES];
    
    [self refreshData];
}

#pragma mark - BSFeedCommentTableViewCellDelegate
- (void)_showProfileForUser:(BSUserMO *)user {
    if (user) {
        [self.navigationController pushViewController:[BSProfileViewController instanceFromStoryboardWithUser:user] animated:YES];
    }
}

- (void)feedCommentCell:(BSFeedCommentTableViewCell *)commentCell didSelectMention:(NSString *)mention {
    if (mention.length > 0) {
        BSUserInfoWithUsernameHttpRequest *request = [BSUserInfoWithUsernameHttpRequest request];
        request.userName = mention;
        [request postRequestWithSucceedBlock:^(BSHttpResponseDataModel *result) {
            [self _showProfileForUser:result.dataModel];
        } failedBlock:nil];
    }
}

#pragma mark UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rowNumber;
    return rowNumber = self.tableViewModel == BSTableViewModel_Comments ? [self.commentsAry count] : [self.findfollowerAry count];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 62;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tableViewModel == BSTableViewModel_Comments) {
            BSFeedCommentTableViewCell *cell = [_commentsTableView dequeueReusableCellWithIdentifier:BSFeedCommentTableViewCell.className forIndexPath:indexPath];
            BSCommentMO *comment = [self.commentsAry objectAtIndex:indexPath.row];
            [cell configWithDataModel:comment showCommenter:NO];
            cell.delegate = self;
            
            return cell;
    }  else {
        BSUserMO *follower = [self.findfollowerAry objectAtIndex:indexPath.row];
        BSFeedFollowedTableViewCell *cell = [_commentsTableView dequeueReusableCellWithIdentifier:BSFeedFollowedTableViewCell.className forIndexPath:indexPath];
        [cell configWithUser:follower];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tableViewModel == BSTableViewModel_Follower && self.isTextAtUser && _numberOfLines != 7) {
        BSFeedFollowedTableViewCell *cell = (BSFeedFollowedTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        NSString *commentStr = [NSString stringWithFormat:@"%@@%@ ",[self.commentTextView.text substringToIndex:self.atLetterLocation], cell.lblID.text];
        self.commentTextView.text = commentStr;
    }
}

#pragma mark - UIGestureRecognizer delegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (self.tableViewModel == BSTableViewModel_Follower && [NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}

#pragma mark - Keyboard show or hide notification
- (void)keyboardWillShow:(NSNotification *)aNotification {
	NSDictionary *userInfo = [aNotification userInfo];
	NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
	CGRect keyboardRect = [aValue CGRectValue];
	int height = keyboardRect.size.height;
    NSTimeInterval animationDuration = [[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
	self.postViewBottomLayoutConstraint.constant = height;
    
    [self.commentsTableView setNeedsUpdateConstraints];
	[self.postCommentsView setNeedsUpdateConstraints];
	[UIView animateWithDuration:animationDuration animations: ^{
        [self.commentsTableView layoutIfNeeded];
	    [self.postCommentsView layoutIfNeeded];
	}];
    
    NSInteger rowsNumber = [self.commentsTableView numberOfRowsInSection:0];
    if (rowsNumber > 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.commentsTableView numberOfRowsInSection:0] - 1 inSection:0];
        [self.commentsTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

- (void)keyboardWillHide:(NSNotification *)aNotification {
	self.postViewBottomLayoutConstraint.constant = 0;
    NSTimeInterval animationDuration = [[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
	[self.postCommentsView setNeedsUpdateConstraints];
	[UIView animateWithDuration:animationDuration animations: ^{
	    [self.postCommentsView layoutIfNeeded];
	}];
}

#pragma mark - UITextView Delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
	if ([text isEqualToString:@"\n"]) {
		[textView resignFirstResponder];
	}

    if ([text isEqualToString:@"@"]) {
        self.tableViewModel = BSTableViewModel_Follower;
        self.isTextAtUser = YES;
        self.atLetterLocation = range.location;
		
        BSUserFollowingHttpRequest *aRequest = [BSUserFollowingHttpRequest request];
        BSUserMO *currentUser = [BSDataManager sharedInstance].currentUser;
        aRequest.user_id = currentUser.identifierValue;
        [aRequest postRequestWithSucceedBlock:^(BSHttpResponseDataModel *result) {
            BSUsersDataModel *usersDataModel = result.dataModel;
            self.userAry = self.findfollowerAry = [NSMutableArray arrayWithArray:usersDataModel.users];
            [self.commentsTableView reloadData];
        } failedBlock:nil];
    }

	return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    if ([textView.text length] > 0) {
        self.allowCommentsLbl.hidden = YES;
        textView.textColor = [UIColor blackColor];
    } else {
        self.allowCommentsLbl.hidden = NO;
    }
    
    if (self.atLetterLocation == self.commentTextView.text.length) {
        self.isTextAtUser = NO;
    }
    
    NSLayoutManager *layoutManager = [textView layoutManager];
    NSUInteger index, numberOfGlyphs = [layoutManager numberOfGlyphs];
    NSRange lineRange;
    for (_numberOfLines = 0, index = 0; index < numberOfGlyphs; _numberOfLines++)
    {
        (void) [layoutManager lineFragmentRectForGlyphAtIndex:index
                                               effectiveRange:&lineRange];
        index = NSMaxRange(lineRange);
    }
    
    if (_numberOfLines > kMaximumNumberOfLines) {
        textView.text = _commentText;
        _commentTextView.textContainer.lineBreakMode = NSLineBreakByCharWrapping;
    }
    else {
        if (_numberOfLines == kMaximumNumberOfLines) {
            _commentTextView.textContainer.lineBreakMode = NSLineBreakByCharWrapping;
        }
        _commentTextView.textContainer.lineBreakMode = NSLineBreakByWordWrapping;
        _commentText = textView.text;
    }

    NSString *postStr = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (postStr.length <= 0 || !postStr) {
        self.postBtn.enabled = NO;
        [self.postBtn setTitleColor:KCommentDisabledColor forState:UIControlStateDisabled];
    }
    else {
        self.postBtn.enabled = YES;
        [self.postBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        NSMutableArray *tempAry = [[NSMutableArray alloc] init];
        if (self.tableViewModel == BSTableViewModel_Follower && self.isTextAtUser == YES) {
            if (self.atLetterLocation >= textView.text.length) {
                self.atLetterLocation = textView.text.length - 1;
            }
            NSString *findStr = [textView.text substringFromIndex:(self.atLetterLocation + 1)];
            if (findStr.length == 0) {
                self.findfollowerAry = self.userAry;
            } else{
                for (BSUserMO *user in self.userAry) {
                    if ([user.name_id.uppercaseString hasPrefix:findStr.uppercaseString]) {
                        [tempAry addObject:user];
                    }
                }
                self.findfollowerAry = tempAry;
            }
            [self.commentsTableView reloadData];
        }
    }
}

- (IBAction)postBtnClick:(id)sender {
    NSString *postContent = self.commentTextView.text;
    if (postContent && postContent.length > 0) {
        [BSUIGlobal showLoadingWithMessage:nil];
        
        BSHighlightCommentHttpRequest *request = [BSHighlightCommentHttpRequest request];
        request.highlightId = self.highlight.identifierValue;
        request.content = postContent;
        [request postRequestWithSucceedBlock: ^(BSHttpResponseDataModel *result) {
            [BSUIGlobal hideLoading];
			[BSEventTracker trackResult:YES eventName:@"post_comment" page:self properties:@{@"video_id":self.highlight.identifier}];
            self.commentTextView.text = nil;
            
            BSHighlightCommentsDataModel *commentsDataModel = result.dataModel;
            for (BSCommentMO *comment in commentsDataModel.comments) {
				comment.user = [BSDataManager sharedInstance].currentUser;
                [_highlight addCommentsObject:comment];
            }
			self.highlight.comments_countValue += 1;
            [[BSDataManager sharedInstance] save];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kCommentDidPostedNotification object:self.highlightID];
            NSArray *commentDataAry = commentsDataModel.comments;
            BSCommentMO *comment = [commentDataAry firstObject];
            
            [self.commentsAry addObject:comment];
            NSIndexPath *insertIndexPath = [NSIndexPath indexPathForRow:(self.commentsAry.count - 1) inSection:0];
            NSArray *insertAry = [NSArray arrayWithObject:insertIndexPath];
            
            [self.commentsTableView beginUpdates];
            [self.commentsTableView insertRowsAtIndexPaths:insertAry withRowAnimation:UITableViewRowAnimationFade];
            [self.commentsTableView endUpdates];
            [self.commentsTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(self.commentsAry.count - 1) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            
        } failedBlock:nil];
    }
}

- (IBAction)tapAction:(id)sender {
    if (self.tableViewModel == BSTableViewModel_Comments) {
        [self.commentTextView resignFirstResponder];
    }
}

@end
