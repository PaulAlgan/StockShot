//
//  LikedViewController.m
//  StockShot
//
//  Created by Phatthana Tongon on 4/23/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import "LikedViewController.h"
#import "IIViewDeckController.h"
@interface LikedViewController ()

@end

@implementation LikedViewController

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
        self.title = @"Likes";
    }
    return  self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIButton *refreshButton = [Utility refreshButton];
    [refreshButton addTarget:self action:@selector(reloadPhotos) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [Utility menuBarButtonWithID:self];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:refreshButton];

}

- (void)reloadPhotos
{
    NSLog(@"LIKE reloadPhotos");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
