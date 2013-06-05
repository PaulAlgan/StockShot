//
//  TermsOfUseViewController.m
//  StockShot
//
//  Created by Phatthana Tongon on 4/23/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import "TermsOfUseViewController.h"
#import "IIViewDeckController.h"
#import "AFHTTPRequestOperation.h"

@interface TermsOfUseViewController ()

@end

@implementation TermsOfUseViewController

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
        self.title = @"Term of Use";
    }
    return  self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu"
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:self.viewDeckController
                                                                        action:@selector(toggleLeftView)];
    [self getTermOfUse];
}

//https://stockshot-kk.appspot.com/api/term_of_use

- (void)getTermOfUse
{
    NSURL *url = [NSURL URLWithString:@"https://stockshot-kk.appspot.com/api/term_of_use"];
    
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
