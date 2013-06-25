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

#import "User+addition.h"
#import "AppDelegate.h"
#import "LoginViewController.h"

@interface SettingViewController ()
{
    User *me;
    AppDelegate *appdelegate;
}
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
    
    appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btLogOutAction:(id)sender
{
    me = [User me];
    me.me = [NSNumber numberWithBool:NO];
    [appdelegate saveContext];
    
    [self.viewDeckController setCenterController:appdelegate.tabBarController];
    LoginViewController *loginView = [[LoginViewController alloc] init];
    loginView.haveUser = NO;
    [appdelegate.tabBarController presentViewController:loginView animated:NO completion:^{ }];

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
