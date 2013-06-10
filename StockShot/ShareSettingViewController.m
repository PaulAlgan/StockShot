//
//  ShareSettingViewController.m
//  StockShot
//
//  Created by MacbookPro on 6/10/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import "ShareSettingViewController.h"
#import "User+addition.h"
#import <FacebookSDK/FacebookSDK.h>
@interface ShareSettingViewController ()
{
    User *me;
}
@end

@implementation ShareSettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Share Setting";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [Utility backButton:self];
    me  = [User me];
    if (me) {
        lblFacebookName.text = me.name;
        lblEmailName.text = me.email;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    @"id,name,email,first_name,last_name,username,locale",@"fields",
                                    nil];
    
    FBRequest *friendsRequest = [FBRequest requestWithGraphPath:@"me"
                                                     parameters:params
                                                     HTTPMethod:@"GET"];
    
    [friendsRequest startWithCompletionHandler:^(FBRequestConnection *connection,
                                                 id result,
                                                 NSError *error) {
        lblFacebookName.text = [result objectForKey:@"name"];
        lblEmailName.text = [result objectForKey:@"email"];
    }];

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
