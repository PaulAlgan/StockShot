//
//  ThirdViewController.m
//  StockShot
//
//  Created by Phatthana Tongon on 5/5/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import "ThirdViewController.h"
#import "CameraViewController.h"
#import "AppDelegate.h"
@interface ThirdViewController ()
{
    CameraViewController *cameraView;
    AppDelegate *appdelegate;
}
@end

@implementation ThirdViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [appdelegate hideStatusBar];
    
    cameraView = [[CameraViewController alloc] init];
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:cameraView];
    [self.tabBarController presentViewController:navigation animated:NO completion:nil];
    

//    [self.tabBarController.view addSubview:navigation.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
