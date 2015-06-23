//
//  BSCaptureChooseSongViewController.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 2/3/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSCaptureChooseSongViewController.h"
#import "BSDataManager.h"

#import "SoundManager.h"

@interface BSCaptureChooseSongViewController ()

@end

@implementation BSCaptureChooseSongViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = ZPLocalizedString(@"Choose a Song");
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[SoundManager sharedManager] stopAllSounds:YES];
}

#pragma mark - over write
- (NSArray *)getObjectsToBind {
    return [BSDataManager sharedInstance].songsAvailable;
}

- (void)configCell:(BSBasePickerTableViewCell *)cell withObject:(NSObject *)object {
    if (object) {
        BSSongDataModel *song = (BSSongDataModel *)object;
		cell.lblTitle.text = song.name;
		[cell.btnSound configWithSong:song];
    } else {
        cell.lblTitle.text = ZPLocalizedString(@"No Music");
    }
	cell.showIcon = NO;
	cell.showSoundButton = object != nil;
}
/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    [[SoundManager sharedManager] stopAllSounds:NO];
    BSSongDataModel *song = (BSSongDataModel *)[self getObjectAtIndexPath:indexPath];
    if (song) {
        _songPlaying = [Sound soundWithContentsOfURL:song.url];
        [[SoundManager sharedManager] playSound:_songPlaying looping:NO fadeIn:NO];
    }
}*/

@end
