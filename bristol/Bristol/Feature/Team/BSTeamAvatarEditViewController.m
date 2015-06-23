//
//  BSTeamAvatarEditViewController.m
//  Bristol
//
//  Created by Yangfan Huang on 3/19/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSTeamAvatarEditViewController.h"
#import "BSTeamAvatarSelectionCollectionViewCell.h"
#import <RSKTouchView.h>
#import <RSKImageScrollView.h>
#import <UIImage+RSKImageCropper.h>
#import "BSEventTracker.h"

@interface BSTeamAvatarEditViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *avatarSection;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet RSKTouchView *guideView;
@property (weak, nonatomic) IBOutlet UIImageView *maskImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *colorSelectorCenterConstraint;
@property (weak, nonatomic) IBOutlet UIView *colorSelectorView;
@property (weak, nonatomic) IBOutlet UIView *colorSectionView;
@property (weak, nonatomic) IBOutlet UIButton *blackBtn;

@property (nonatomic) NSInteger selectedAvatarIndex;
@property (nonatomic) UIColor *selectedColor;
@property (nonatomic) NSString *selectedImageName;
@property (nonatomic) RSKImageScrollView *imageScrollView;
@end

@implementation BSTeamAvatarEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	[self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
	
	if (self.modifiedAvatar) {
		self.avatarImageView.image = self.modifiedAvatar;
		[self _setColorSectionHidden:YES];
	} else if (self.team.avatar_url) {
		[self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:self.team.avatar_url] placeholderImage:[UIImage imageNamed:@"team_avatar_icon"]];
		[self _setColorSectionHidden:YES];
	} else {
		self.selectedAvatarIndex = 1;
		self.selectedColor = self.blackBtn.backgroundColor;
		self.selectedImageName = @"team_avatar_1";
		
		[self _previewPreDefinedImage];
	}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnCancelTapped:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnOkTapped:(id)sender {
	[BSEventTracker trackTap:@"done" page:self properties:@{@"selected_avatar":@(self.selectedAvatarIndex)}];
	if (self.selectedAvatarIndex > 0) {
		if (self.delegate) {
			[self.delegate didEditAvatar:self.avatarImageView.image];
		}
		[self dismissViewControllerAnimated:YES completion:nil];
	} else if (self.imageScrollView && self.imageScrollView.zoomView && self.imageScrollView.zoomView.image) {
		[BSUIGlobal showLoadingWithMessage:nil];
		
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
			UIImage *image = [self _cropImage];
			
			dispatch_async(dispatch_get_main_queue(), ^{
				[BSUIGlobal hideLoading];
				
				if (self.delegate) {
					[self.delegate didEditAvatar:image];
				}
				//UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
				[self dismissViewControllerAnimated:YES completion:nil];
			});
		});
	}
}

- (void) _setColorSectionHidden:(BOOL) hidden {
	self.colorSectionView.alpha = hidden ? 0.7 : 1.0;
	self.colorSelectorView.hidden = hidden;
}

- (CGRect) _cropRect
{
	CGRect cropRect = CGRectZero;
	float zoomScale = 1.0 / self.imageScrollView.zoomScale;
	
	cropRect.origin.x = round((self.imageScrollView.contentOffset.x + self.maskImageView.frame.origin.x)* zoomScale);
	cropRect.origin.y = round(self.imageScrollView.contentOffset.y * zoomScale);
	cropRect.size.width = CGRectGetWidth(self.maskImageView.bounds) * zoomScale;
	cropRect.size.height = CGRectGetHeight(self.imageScrollView.bounds) * zoomScale;
	
	cropRect = CGRectIntegral(cropRect);
	
	return cropRect;
}

- (UIImage *) _cropImage {
	UIImage *image = self.imageScrollView.zoomView.image;

	CGRect cropRect = [self _cropRect];
	
	// Step 1: check and correct the crop rect.
	CGSize imageSize = image.size;
	CGFloat x = CGRectGetMinX(cropRect);
	CGFloat y = CGRectGetMinY(cropRect);
	CGFloat width = CGRectGetWidth(cropRect);
	CGFloat height = CGRectGetHeight(cropRect);
	
	UIImageOrientation imageOrientation = image.imageOrientation;
	if (imageOrientation == UIImageOrientationRight || imageOrientation == UIImageOrientationRightMirrored) {
		cropRect.origin.x = y;
		cropRect.origin.y = round(imageSize.width - CGRectGetWidth(cropRect) - x);
		cropRect.size.width = height;
		cropRect.size.height = width;
	} else if (imageOrientation == UIImageOrientationLeft || imageOrientation == UIImageOrientationLeftMirrored) {
		cropRect.origin.x = round(imageSize.height - CGRectGetHeight(cropRect) - y);
		cropRect.origin.y = x;
		cropRect.size.width = height;
		cropRect.size.height = width;
	} else if (imageOrientation == UIImageOrientationDown || imageOrientation == UIImageOrientationDownMirrored) {
		cropRect.origin.x = round(imageSize.width - CGRectGetWidth(cropRect) - x);
		cropRect.origin.y = round(imageSize.height - CGRectGetHeight(cropRect) - y);
	}
	
	// Step 2: create an image using the data contained within the specified rect.
	CGImageRef croppedCGImage = CGImageCreateWithImageInRect(image.CGImage, cropRect);
	UIImage *croppedImage = [UIImage imageWithCGImage:croppedCGImage scale:1.0f orientation:imageOrientation];
	CGImageRelease(croppedCGImage);
	
	// Step 3: fix orientation of the cropped image.
	croppedImage = [croppedImage fixOrientation];

	// Step 4: apply mask
	UIImage *maskImage = [UIImage imageNamed:@"team_avatar_maskforcode"];
	CGImageRef maskRef = maskImage.CGImage;
	CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef), CGImageGetHeight(maskRef), CGImageGetBitsPerComponent(maskRef), CGImageGetBitsPerPixel(maskRef), CGImageGetBytesPerRow(maskRef), CGImageGetDataProvider(maskRef), nil, NO);
	
	CGImageRef maskedImageRef = CGImageCreateWithMask(croppedImage.CGImage, mask);
	UIImage *maskedImage = [UIImage imageWithCGImage:maskedImageRef];
	
	CGImageRelease(mask);
	CGImageRelease(maskedImageRef);
	
	// Step 5: draw, 555x693 pixel in max
	CGFloat widthScale = maskedImage.size.width / 555;
	CGFloat heightScale = maskedImage.size.height / 693;
	CGFloat scale = MAX(1.0, MAX(widthScale, heightScale));
	
	CGRect rect = CGRectMake(0, 0, maskedImage.size.width / scale, maskedImage.size.height / scale);
	UIGraphicsBeginImageContext(rect.size);
	[maskedImage drawInRect:rect];
	UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return result;
}

- (void) _previewPreDefinedImage {
	if (!self.selectedImageName || self.selectedImageName.length == 0) {
		return;
	}
	
	self.imageScrollView.zoomView.image = nil;
	
	UIImage *image = [UIImage imageNamed:self.selectedImageName];
	UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0);

	CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
	[image drawInRect:rect];
	[self.selectedColor set];
	UIRectFillUsingBlendMode(rect, kCGBlendModeScreen);
	[image drawInRect:rect blendMode:kCGBlendModeDestinationIn alpha:1.0];
	image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	self.avatarImageView.image = image;
}

#pragma mark - select color
- (IBAction)btnColorTapped:(id)sender {
	if (self.selectedAvatarIndex == 0) {
		return;
	}
	
	if (self.colorSelectorView.hidden) {
		[self _setColorSectionHidden:NO];
		self.colorSelectorCenterConstraint.constant = ((UIButton *)sender).centerX;
	} else {
		[UIView animateWithDuration:kDefaultAnimateDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
			self.colorSelectorCenterConstraint.constant = ((UIButton *)sender).centerX;
			[self.colorSelectorView layoutIfNeeded];
		} completion:nil];
	}
	
	self.selectedColor = ((UIButton *)sender).backgroundColor;
	[self _previewPreDefinedImage];
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return 10;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	BSTeamAvatarSelectionCollectionViewCell *cell = (BSTeamAvatarSelectionCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"BSTeamAvatarSelectionCollectionViewCell" forIndexPath:indexPath];
	
	if (indexPath.row == 0) {
		[cell configureAvatarImage:[UIImage imageNamed:@"team_avatar_takephoto_icon"]];
		[cell setAvatarSelected:NO];
	} else {
		[cell configureAvatarImage:[UIImage imageNamed:[NSString stringWithFormat:@"team_avatar_%ld", (long)indexPath.row]]];
		[cell setAvatarSelected:indexPath.row == self.selectedAvatarIndex];
	}
	
	return cell;
}

#pragma mark - UICollectionViewDelegate
- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	[collectionView deselectItemAtIndexPath:indexPath animated:YES];

	if (indexPath.row == 0) {
		void (^showImagePicker) (BOOL isCamera) = ^(BOOL isCamera) {
			[BSUIGlobal showImagePickerControllerInViewController:self additionalConstruction:^(UIImagePickerController *picker) {
				picker.sourceType = isCamera ? UIImagePickerControllerSourceTypeCamera : UIImagePickerControllerSourceTypePhotoLibrary;
			} didFinishPickingMedia:^(NSDictionary *info) {
				UIImage *image = info[UIImagePickerControllerEditedImage];
				if (image) {
					self.avatarImageView.image = nil;
					[self _setColorSectionHidden:YES];
					
					if (!self.imageScrollView) {
						self.imageScrollView = [[RSKImageScrollView alloc] initWithFrame:self.avatarImageView.frame];
						self.guideView.receiver = self.imageScrollView;
						[self.avatarSection insertSubview:self.imageScrollView belowSubview:self.guideView];
					}
					[self.imageScrollView displayImage:image];
					
					float widthScale = self.maskImageView.width / image.size.width;
					float heightScale = self.maskImageView.height / image.size.height;
					float minimunScale = MAX(widthScale, heightScale);
					self.imageScrollView.minimumZoomScale = minimunScale;
					self.imageScrollView.maximumZoomScale = minimunScale > 4.0 ? minimunScale * 4.0 : 4.0;
				}
			} didCancel:nil];
		};
		
		[BSUIGlobal showActionSheetTitle:nil isDestructive:YES actionTitle:ZPLocalizedString(@"Choose a Photo") actionHandler:^{
			showImagePicker(NO);
		} additionalConstruction:^(BSUIActionSheet *actionSheet) {
			if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
				[actionSheet addButtonWithTitle:ZPLocalizedString(@"Take a Photo") isDestructive:NO handler: ^{
					showImagePicker(YES);
				}];
			}
		}];
	} else if (indexPath.row != self.selectedAvatarIndex) {
		[self _setColorSectionHidden:NO];
		self.selectedImageName = [NSString stringWithFormat:@"team_avatar_%ld", (long)indexPath.row];
		[self _previewPreDefinedImage];
	}
	
	self.selectedAvatarIndex = indexPath.row;
	[collectionView reloadData];
}

@end
