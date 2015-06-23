//
//  BSProfileVideoPlayControlViewController.m
//  Bristol
//
//  Created by Gary Wong on 5/14/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSProfileVideoPlayControlViewController.h"
#import "BSEventTracker.h"

@interface BSSwitch : UISwitch
@property(nonatomic, strong) NSString *name;
@end

@implementation BSSwitch

@end


@interface BSProfileVideoPlayControlViewController ()

@property (weak, nonatomic) IBOutlet BSSwitch *swhAutoPlayVideo;
@property (weak, nonatomic) IBOutlet BSSwitch *swhAutoPlayAudio;
@property (weak, nonatomic) IBOutlet BSSwitch *swhLoopingVideo;
@property (weak, nonatomic) IBOutlet BSSwitch *swhTapToFullscreen;


@end

@implementation BSProfileVideoPlayControlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _swhAutoPlayVideo.name = kFeedAutoPlayVideo;
    _swhAutoPlayAudio.name = kFeedAutoPlayAudio;
    _swhLoopingVideo.name = kFeedLoopingVideo;
    _swhTapToFullscreen.name = kFeedTapToFullscreen;
    for (BSSwitch *swh in @[_swhAutoPlayVideo, _swhAutoPlayAudio, _swhLoopingVideo, _swhTapToFullscreen]) {
        swh.on = [UserDefaults boolForKey:swh.name];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [UserDefaults synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:kFeedConfigurationDidChangedNotification object:nil];
}

- (IBAction)swhValueChanged:(BSSwitch *)sender {
    [UserDefaults setBool:sender.on forKey:sender.name];
	[BSEventTracker trackAction:[NSString stringWithFormat:@"switch_%@", sender.name] page:self properties:@{@"on":(sender.on?@"yes":@"no")}];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65.0f;
}

@end
