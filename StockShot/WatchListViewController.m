//
//  WatchListViewController.m
//  StockShot
//
//  Created by Phatthana Tongon on 4/23/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import "WatchListViewController.h"
#import "IIViewDeckController.h"
#import "User+addition.h"
#import "Stock+addition.h"
static NSString *CellClassName = @"WatchCell";

@interface WatchListViewController ()
{
    User *me;
    NSArray *watchList;
}
@end

@implementation WatchListViewController

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
        self.title = @"Watch List";
    }
    return  self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    cellLoader = [UINib nibWithNibName:CellClassName bundle:[NSBundle mainBundle]];
    self.navigationItem.leftBarButtonItem = [Utility menuBarButtonWithID:self];
    watchListTableView.separatorColor = [UIColor clearColor];
    watchListTableView.backgroundColor = [UIColor clearColor];
    
    me = [User me];
    if (me.facebookID){
       watchList = [me.watch allObjects];
        for (Stock *stock in watchList)
        {
            NSLog(@"Watch: %@",[stock debugDescription]);
        }
    }
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return watchList.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *CellIdentifier = @"Header";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WatchCell *cell = (WatchCell *)[tableView dequeueReusableCellWithIdentifier:CellClassName];
    if (!cell){
        NSArray *topLevelItems = [cellLoader instantiateWithOwner:self options:nil];
        cell = [topLevelItems objectAtIndex:0];
    }
    
    if (watchList.count>0) {
        Stock *stock = [watchList objectAtIndex:indexPath.row];
        [cell setStock:stock];
    }
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
