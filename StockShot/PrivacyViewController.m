//
//  PrivacyViewController.m
//  StockShot
//
//  Created by Phatthana Tongon on 4/23/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import "PrivacyViewController.h"
#import "IIViewDeckController.h"
#import "AFHTTPRequestOperation.h"

@interface PrivacyViewController ()

@end

@implementation PrivacyViewController

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
        self.title = @"Privacy Policy";
    }
    return  self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [Utility menuBarButtonWithID:self];
    [self getPrivacy];
}

- (void)getPrivacy
{
    NSURL *url = [NSURL URLWithString:@"https://stockshot-kk.appspot.com/api/private_policy"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject){
//        NSLog(@"HTTP RESULT: %@",[operation responseString]);
        [contentWebView loadHTMLString:[operation responseString] baseURL:nil];
    
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    [operation start];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
