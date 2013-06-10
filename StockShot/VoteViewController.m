//
//  VoteViewController.m
//  StockShot
//
//  Created by Phatthana Tongon on 4/23/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import "VoteViewController.h"
#import "IIViewDeckController.h"

@interface VoteViewController ()
{
    UIView* reuseView;
}
@end

@implementation VoteViewController

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
        self.title = @"Vote";
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

- (void)viewDidUnload {
    reuseView = nil;
    
    tableVote = nil;
    [super viewDidUnload];
}


#pragma Table DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.view.frame.size.height - 100;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentity"];
    
    if (cell == NULL) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellIdentity"];
    }
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (reuseView == nil) {
        reuseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
        [reuseView setBackgroundColor:[UIColor clearColor]];
        
        UILabel* lbl = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, self.view.frame.size.width - 70, 44)];
        [lbl setTextColor:[UIColor whiteColor]];
        [lbl setBackgroundColor:[UIColor lightGrayColor]];
        [lbl setText:@"  เสี่ยเจริญจะฮุป TIPCO จริงหรือไม่"];
        [reuseView addSubview:lbl];
        lbl = nil;
        
        UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-70, 0, 65, 44)];
        [button setTitle:@"Share" forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor darkTextColor]];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setExclusiveTouch:YES];
        [reuseView addSubview:button];
        button = nil;
    }
    
    
    return reuseView;
}

@end
