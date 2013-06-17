//
//  SuggestFriendViewController.m
//  StockShot
//
//  Created by Phatthana Tongon on 4/24/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import "SuggestFriendViewController.h"
#import "AFJSONRequestOperation.h"

#import "AppDelegate.h"
@interface SuggestFriendViewController ()
{
    UIActivityIndicatorView *loadingIndecator;
    UIBarButtonItem *loadingIndecatorButton;
    UIBarButtonItem *reloadButton;
    
    AppDelegate *appdelegate;
    NSMutableArray *suggestPlayers;
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
    
    loadingIndecator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    loadingIndecator.hidesWhenStopped = YES;
    [loadingIndecator startAnimating];
    loadingIndecator.frame = CGRectMake(0, 0, 30, 40);
    loadingIndecatorButton = [[UIBarButtonItem alloc] initWithCustomView:loadingIndecator];
    
    reloadButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                 target:self
                                                                 action:@selector(getSuggestedPlayer)];
    
    
//    self.navigationItem.rightBarButtonItem = loadingIndecatorButton;
    self.navigationItem.leftBarButtonItem = [Utility backButton:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self getSuggestedPlayer];
}

#pragma mark - Table view data source

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
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (suggestPlayers.count > 0) {
//        Player *player = [suggestPlayers objectAtIndex:indexPath.row];
//        cell.textLabel.text = player.name;
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
//    self.navigationItem.rightBarButtonItem = loadingIndecatorButton;

    NSURL *url = [NSURL URLWithString:@"https://stockshot-kk.appspot.com/api/suggested_player"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:7];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
                                         {;
                                             NSArray *players = [JSON objectForKey:@"player"];
//                                             NSLog(@"PlayerN: %d",players.count);
                                             if (!suggestPlayers) {
                                                 suggestPlayers = [[NSMutableArray alloc] init];
                                             }
                                             else{
                                                 [suggestPlayers removeAllObjects];
                                             }
                                             
                                             for (int i=0; i<players.count; i++) {
//                                                 NSDictionary *dict = [players objectAtIndex:i];
//                                                 Player *player = [Player createPlayerWithFacebookID:[dict objectForKey:@"facebook_id"]
//                                                                                                 InManagedObjectContext:appdelegate.managedObjectContext];
//                                                 
//                                                 player.username = [dict objectForKey:@"username"];
//                                                 player.name = [dict objectForKey:@"name"];
//                                                 player.firstName = [dict objectForKey:@"first_name"];
//                                                 player.lastName = [dict objectForKey:@"last_name"];
//                                                 player.facebookID = [dict objectForKey:@"facebook_id"];
//                                                 player.email = [dict objectForKey:@"email"];
//                                                 player.deviceToken = [dict objectForKey:@"device_token"];
//                                                 player.locale = [dict objectForKey:@"locale"];
//                                                 
//                                                 player.notiComment = [dict objectForKey:@"notification_comment"];
//                                                 player.notiContact = [dict objectForKey:@"notification_contact"];
//                                                 player.notiLike = [dict objectForKey:@"notification_like"];
//                                                 
//                                                 player.followerCount =
//                                                 [NSNumber numberWithLong:[[dict objectForKey:@"follower_count"] longValue]];
//                                                 player.followingCount =
//                                                 [NSNumber numberWithLong:[[dict objectForKey:@"following_count"] longValue]];
//                                                 player.photoCount =
//                                                 [NSNumber numberWithLong:[[dict objectForKey:@"photo_count"] longValue]];
//                                                 player.photoLikeCount =
//                                                 [NSNumber numberWithLong:[[dict objectForKey:@"photo_like_count"] longValue]];
//                                                 
//                                                 [suggestPlayers addObject:player];
                                             }
                                             [appdelegate saveContext];
                                             [contentTableView reloadData];
                                             
//                                             self.navigationItem.rightBarButtonItem = reloadButton;
                                             
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
