//
//  SearchViewController.m
//  StockShot
//
//  Created by Phatthana Tongon on 5/4/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import "SearchViewController.h"
#import "IIViewDeckController.h"
#import "AFJSONRequestOperation.h"
#import "GMGridView.h"
#import <QuartzCore/QuartzCore.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "ImageGridViewController.h"
#import "User+addition.h"
#import "AppDelegate.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ProfileViewController.h"
static NSString *CellClassName = @"ImageViewCell";

@interface SearchViewController ()
{
    NSMutableArray *resultImages;
    NSMutableArray *resultUsers;
    NSArray *hotSearch;
    NSString *searchType;
    __gm_weak GMGridView *_gmGridView;
    User *me;
    AppDelegate *appdelegate;
}
@end

@implementation SearchViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (id)init{
    self = [super init];
    if (self) {
        cellLoader = [UINib nibWithNibName:CellClassName bundle:[NSBundle mainBundle]];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Explore";
    appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    searchType = [[NSString alloc] init];
    searchType = @"user";
    [self.searchDisplayController.searchResultsTableView registerNib:cellLoader forHeaderFooterViewReuseIdentifier:CellClassName];

    self.navigationItem.leftBarButtonItem = [Utility menuBarButtonWithID:self];
    UIButton *refreshButton = [Utility refreshButton];
    [refreshButton addTarget:self action:@selector(reloadPhotos) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:refreshButton];
    
    resultImages = [[NSMutableArray alloc] init];
    [self loadGridView];
    _gmGridView.hidden = YES;
}

- (void)reloadPhotos
{
    NSLog(@"ReloadPhotos");
}


- (void)loadGridView
{
    
}

#pragma mark GMGridViewDataSource
//////////////////////////////////////////////////////////////

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{    
    if ([searchType isEqualToString:@"hashtag"])
        return hotSearch.count;
    else
        return resultUsers.count;
}
    
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.searchDisplayController.searchResultsTableView)
    {
        if ([searchType isEqualToString:@"hashtag"])
        {
            static NSString *CellIdentifier = @"TagCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            if (hotSearch.count)
            {
                cell.textLabel.text = [hotSearch objectAtIndex:indexPath.row];
            }
            
            return cell;
        }
        else
        {
            static NSString *CellIdentifier = @"UserCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            }
            
            if (resultUsers.count > 0)
            {
                User *user = [resultUsers objectAtIndex:indexPath.row];
                cell.textLabel.text = user.username;
                cell.detailTextLabel.text = user.name;
                [cell.imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture",user.facebookID]]
                               placeholderImage:[UIImage imageNamed:@"profileImage.png"]];
            }
            
            
            return cell;
        }
        
    }
    else
    {
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.textLabel.text = @"Hello";
        return cell;
    }

}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([searchType isEqualToString:@"hashtag"])
    {
        ImageGridViewController *imageGridView = [[ImageGridViewController alloc]
                                                  initWithHashTagName:[hotSearch objectAtIndex:indexPath.row]];
        [self.navigationController pushViewController:imageGridView animated:YES];
    }
    else
    {
        ProfileViewController *profileVC = [[ProfileViewController alloc] initWithUser:[resultUsers objectAtIndex:indexPath.row]];
        [self.navigationController pushViewController:profileVC animated:YES];
    }
    
}

#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    NSLog(@"BEGIN SEARCH");
    [self getHotSerach];
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    NSLog(@"SEARCH: %@",searchBar.text);
    if ([searchType isEqualToString:@"hashtag"])
    {
//        [self getPhotoFromHashTag:searchBar.text];
    }
    else
    {
        [self getPhotoFromHashTag:searchBar.text];
    }
    _gmGridView.hidden = NO;
//    NSLog(@"%f %f %f %f"
//          ,self.searchDisplayController.searchResultsTableView.frame.origin.x
//          ,self.searchDisplayController.searchResultsTableView.frame.origin.y
//          ,self.searchDisplayController.searchResultsTableView.frame.size.width
//          ,self.searchDisplayController.searchResultsTableView.frame.size.height);

}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
//    NSLog(@"shouldReloadTableForSearchString");
//    [self filterContentForSearchText:searchString scope:
//     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
//
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    NSLog(@"shouldReloadTableForSearchScope");
    
    if (searchOption == 0) {
        searchType = @"user";
    }
    else{
        searchType = @"hashtag";
    }
    [self.searchDisplayController.searchResultsTableView reloadData];

//    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
//     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


#pragma mark - Data
- (void)getHotSerach
{
    NSURL *url = [NSURL URLWithString:@"https://stockshot-kk.appspot.com/api/hot_search"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:7];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
                                         {
                                             NSLog(@"JSON: %@",JSON);
                                             hotSearch = [JSON objectForKey:@"keyword"];
                                             [self.searchDisplayController.searchResultsTableView reloadData];
                                             
                                         } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
                                         {
                                             [Utility alertWithMessage:[NSString stringWithFormat:@"ERROR: %@",url]];
                                             [self dismissViewControllerAnimated:YES completion:nil];
                                         }];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    
    [operation start];
}

- (void)getPhotoFromHashTag:(NSString*)hashTag
{
    me = [User me];
    NSURL *url = [NSURL URLWithString:@"https://stockshot-kk.appspot.com/api/search"];
    NSString *params = [[NSString alloc] initWithFormat:@"hashtag=%@",hashTag];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    [request setTimeoutInterval:7];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
                                         {
                                             //                                             NSLog(@"JSON: %@",JSON);
//                                             resultImages = [JSON objectForKey:@"photo"];
                                             resultUsers = [JSON objectForKey:@"user"];
//                                             NSLog(@"Photo: %@",[resultImages objectAtIndex:0]);
//                                             NSLog(@"User[%d]: %@",resultUsers.count,resultUsers);
                                             
                                             NSMutableArray *usersTemp = [[NSMutableArray alloc] init];
                                             for (int i=0; i<resultUsers.count; i++)
                                             {
                                                 NSDictionary *userDict = [resultUsers objectAtIndex:i];
                                                 if (![[userDict objectForKey:@"facebook_id"] isEqualToString:me.facebookID])
                                                 {
                                                     User *user = [User userWithFacebookID:[userDict objectForKey:@"id"] InManagedObjectContext:appdelegate.managedObjectContext];
                                                     
                                                     user.username = [userDict objectForKey:@"username"];
                                                     user.name = [userDict objectForKey:@"name"];
                                                     user.firstName = [userDict objectForKey:@"first_name"];
                                                     user.lastName = [userDict objectForKey:@"last_name"];
                                                     user.facebookID = [userDict objectForKey:@"facebook_id"];
                                                     user.email = [userDict objectForKey:@"email"];
                                                     user.deviceToken = [userDict objectForKey:@"device_token"];
                                                     user.locale = [userDict objectForKey:@"locale"];
                                                     
                                                     user.notiComment = [userDict objectForKey:@"notification_comment"];
                                                     user.notiContact = [userDict objectForKey:@"notification_contact"];
                                                     user.notiLike = [userDict objectForKey:@"notification_like"];
                                                     
                                                     user.followerCount =
                                                     [NSNumber numberWithLong:[[userDict objectForKey:@"follower_count"] longValue]];
                                                     user.followingCount =
                                                     [NSNumber numberWithLong:[[userDict objectForKey:@"following_count"] longValue]];
                                                     user.photoCount =
                                                     [NSNumber numberWithLong:[[userDict objectForKey:@"photo_count"] longValue]];
                                                     user.photoLikeCount =
                                                     [NSNumber numberWithLong:[[userDict objectForKey:@"photo_like_count"] longValue]];
                                                     [usersTemp addObject:user];
                                                 }
                                             }
                                             resultUsers = [NSArray arrayWithArray:usersTemp];
                                             NSLog(@"ResultUser: %@",resultUsers);
                                             [self.searchDisplayController.searchResultsTableView reloadData];
                                         } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
                                         {
                                             [Utility alertWithMessage:[NSString stringWithFormat:@"ERROR: %@",url]];
                                         }];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    [operation start];
}



@end
