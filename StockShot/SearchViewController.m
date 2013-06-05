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
static NSString *CellClassName = @"ImageViewCell";

@interface SearchViewController ()
{
    NSMutableArray *resultImages;
    NSMutableArray *resultUsers;
    NSArray *hotSearch;
    NSString *searchType;
    __gm_weak GMGridView *_gmGridView;

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
            static NSString *CellIdentifier = @"Cell";
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
            static NSString *CellIdentifier = @"Cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            cell.textLabel.text = @"Hello";
            
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
    ImageGridViewController *imageGridView = [[ImageGridViewController alloc]
                                              initWithHashTagName:[hotSearch objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:imageGridView animated:YES];
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




@end
