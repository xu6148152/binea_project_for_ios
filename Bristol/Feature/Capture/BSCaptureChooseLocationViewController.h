//
//  BSCaptureChooseLocationViewController.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 2/3/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSBasePickerTableViewController.h"

@class BSHighlightPlacesDataModel;

@interface BSCaptureChooseLocationViewController : BSBasePickerTableViewController

@property(nonatomic, strong) BSHighlightPlacesDataModel *placesDataModel;
@property(nonatomic, copy) ZPVoidBlock didStartRequest;
@property(nonatomic, copy) ZPVoidBlock didSuccessRequest;
@property(nonatomic, copy) ZPVoidBlock didFaildRequest;

@end
