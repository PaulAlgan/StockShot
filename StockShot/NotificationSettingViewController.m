//
//  NotificationSettingViewController.m
//  StockShot
//
//  Created by MacbookPro on 6/10/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import "NotificationSettingViewController.h"

@interface NotificationSettingViewController ()

@end

@implementation NotificationSettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Notification";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [Utility menuBarButtonWithID:self];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    tableNoti = nil;
    cellLikeCollection = nil;
    cellCommentCollection = nil;
    cellContactCollection = nil;
    [super viewDidUnload];
}

#pragma Table DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == NULL) {
        //
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"test";
}

- (IBAction)btLikeAction:(id)sender {
    for (UITableViewCell* cell in cellLikeCollection) {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    int tag = ((UIButton*)sender).tag;
    UITableViewCell* cell = [cellLikeCollection objectAtIndex:tag];
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
}

- (IBAction)btCommentAction:(id)sender {
    for (UITableViewCell* cell in cellCommentCollection) {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    int tag = ((UIButton*)sender).tag;
    UITableViewCell* cell = [cellCommentCollection objectAtIndex:tag];
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
}

- (IBAction)btContactAction:(id)sender {
    for (UITableViewCell* cell in cellContactCollection) {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    int tag = ((UIButton*)sender).tag;
    UITableViewCell* cell = [cellContactCollection objectAtIndex:tag];
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
}
@end
