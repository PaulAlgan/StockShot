//
//  SuggestFriendViewController.m
//  StockShot
//
//  Created by Phatthana Tongon on 4/24/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import "SuggestFriendViewController.h"
#import "AFJSONRequestOperation.h"
#import "SuggestUserCell.h"
#import "AppDelegate.h"

static NSString *CellClassName = @"SuggestUserCell";

@interface SuggestFriendViewController ()
{
    UIActivityIndicatorView *loadingIndecator;
    UIBarButtonItem *loadingIndecatorButton;
    UIBarButtonItem *reloadButton;
    
    AppDelegate *appdelegate;
    NSArray *suggestPlayers;
}
@end

@implementation SuggestFriendViewController

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
    self.title = @"Suggested";
    appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    cellLoader = [UINib nibWithNibName:CellClassName bundle:[NSBundle mainBundle]];
    
    loadingIndecator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    loadingIndecator.hidesWhenStopped = YES;
    [loadingIndecator startAnimating];
    loadingIndecator.frame = CGRectMake(0, 0, 30, 40);
    loadingIndecatorButton = [[UIBarButtonItem alloc] initWithCustomView:loadingIndecator];

    reloadButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                 target:self
                                                                 action:@selector(getSuggestedPlayer)];
    self.navigationItem.leftBarButtonItem = [Utility backButton:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self getSuggestedPlayer];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[[suggestPlayers objectAtIndex:indexPath.row] objectForKey:@"photo"] count] > 0) {
        return 128;
    }
    else
    {
        return 46;
    }
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [suggestPlayers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SuggestUserCell *cell = (SuggestUserCell *)[tableView dequeueReusableCellWithIdentifier:CellClassName];
    if (!cell)
    {
        NSArray *topLevelItems = [cellLoader instantiateWithOwner:self options:nil];
        cell = [topLevelItems objectAtIndex:0];
    }
    
    if (suggestPlayers.count > 0)
    {
        NSDictionary *dict = [suggestPlayers objectAtIndex:indexPath.row];
//        cell.playerDict = dict;
        [cell setPlayerDict:dict];
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}


#pragma mark - Data
- (void)getSuggestedPlayer
{
    NSURL *url = [NSURL URLWithString:@"https://stockshot-kk.appspot.com/api/suggested_player"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:7];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
                                         {
                                             NSArray *players = [JSON objectForKey:@"player"];
                                             if (!suggestPlayers) {
                                                 suggestPlayers = [[NSArray alloc] init];
                                             }
                                             suggestPlayers = players;
                                            
//                                             NSLog(@"suggestPlayers: %@",[suggestPlayers objectAtIndex:11]);
                                             [contentTableView reloadData];
                                                                                          
                                             NSLog(@"PlayerN: %d",suggestPlayers.count);
                                         } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
                                         {
                                             [Utility alertWithMessage:[NSString stringWithFormat:@"ERROR: %@",url]];
                                             [self dismissViewControllerAnimated:YES completion:nil];
                                         }];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    
    [operation start];
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
