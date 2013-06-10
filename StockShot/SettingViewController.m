//
//  SettingViewController.m
//  StockShot
//
//  Created by Phatthana Tongon on 4/23/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import "SettingViewController.h"
#import "IIViewDeckController.h"

#import "ShareSettingViewController.h"
#import "NotificationSettingViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.title = @"Setting";
    }
    return  self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [Utility menuBarButtonWithID:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btLogOutAction:(id)sender {
}

- (IBAction)btShareSettingAction:(id)sender {
    ShareSettingViewController* view = [[ShareSettingViewController alloc] initWithNibName:@"ShareSettingViewController" bundle:nil];
    [self.navigationController pushViewController:view animated:YES];
    view = nil;
}

- (IBAction)btPushNotiAction:(id)sender {
    NotificationSettingViewController* view = [[NotificationSettingViewController alloc] initWithNibName:@"NotificationSettingViewController" bundle:nil];
    [self.navigationController pushViewController:view animated:YES];
    view = nil;
}

- (IBAction)btClearHistoryAction:(id)sender {
}

- (IBAction)btPhotoPrivateAction:(id)sender {
    [btPhotoPrivate setSelected:![btPhotoPrivate isSelected]];
}

- (void)viewDidUnload {
    btPhotoPrivate = nil;
    [super viewDidUnload];
}
@end
