//
//  ShareSettingViewController.m
//  StockShot
//
//  Created by MacbookPro on 6/10/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import "ShareSettingViewController.h"

@interface ShareSettingViewController ()

@end

@implementation ShareSettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Share Setting";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [Utility backButton:self];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btFacebookSetting:(id)sender {
}

- (IBAction)btEmailSetting:(id)sender {
}
- (void)viewDidUnload {
    lblFacebookName = nil;
    lblEmailName = nil;
    [super viewDidUnload];
}
@end
