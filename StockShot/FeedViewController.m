//
//  FeedViewController.m
//  StockShot
//
//  Created by Phatthana Tongon on 4/21/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import "FeedViewController.h"
#import "AFJSONRequestOperation.h"
#import "AppDelegate.h"
#import "User+addition.h"
#import <SDWebImage/UIImageView+WebCache.h>

static NSString *CellClassName = @"NewsCell";


@interface FeedViewController ()
{
    AppDelegate *appdelegate;
    User *me;
    BOOL feedTypeNews;
    NSArray *newsList;
    NSArray *followingNewsList;
}
@end

@implementation FeedViewController

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
    self.navigationItem.title = @"News";
    appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    cellLoader = [UINib nibWithNibName:CellClassName bundle:[NSBundle mainBundle]];

    me = [User me];
    feedTypeNews = YES;
    
    self.navigationItem.leftBarButtonItem = [Utility menuBarButtonWithID:self];
    UIButton *refreshButton = [Utility refreshButton];
    [refreshButton addTarget:self action:@selector(reloadFeed) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:refreshButton];
    
    [self getNewsTimeline:me.facebookID];
}

- (void)reloadFeed
{
    if (feedTypeNews) {
        [self getNewsTimeline:me.facebookID];
    }
    else
    {
        [self getFollowingNewsTimeline:me.facebookID];
    }
}

- (IBAction)selectFeedType:(id)sender
{
    UIButton *button = (UIButton*)sender;
    
    if (button == newsButton)
    {
        feedTypeNews = YES;
        newsButton.selected = YES;
        followingButton.selected = NO;
        newsButton.backgroundColor = [UIColor colorWithRed:27.0/255.0 green:86.0/255.0 blue:149.0/255.0 alpha:1];
        followingButton.backgroundColor = [UIColor colorWithRed:48.0/255.0 green:63.0/255.0 blue:70.0/255.0 alpha:1];
    }
    else
    {
        feedTypeNews = NO;
        newsButton.selected = NO;
        followingButton.selected = YES;
        newsButton.backgroundColor = [UIColor colorWithRed:48.0/255.0 green:63.0/255.0 blue:70.0/255.0 alpha:1];
        followingButton.backgroundColor = [UIColor colorWithRed:27.0/255.0 green:86.0/255.0 blue:149.0/255.0 alpha:1];
    }
    
    [self reloadFeed];
}
#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsCell *cell = [[NewsCell alloc] init];
    
    if (newsButton.selected) {
        if (newsList.count > 0)
        {
            NSDictionary *newsFeed = [newsList objectAtIndex:indexPath.row];
            int rowHeight = [cell getRowHeightWithNewsFeed:newsFeed];
            if (rowHeight < 46){
                return 46;
            }
            else{
                return rowHeight + 8;
            }
        }
        else{
            return 46;
        }
    }
    else
    {
        if (followingNewsList.count > 0)
        {
            NSDictionary *newsFeed = [followingNewsList objectAtIndex:indexPath.row];
            int rowHeight = [cell getRowHeightWithNewsFeed:newsFeed];
            if (rowHeight < 46){
                return 46;
            }
            else{
                return rowHeight + 8;
            }
        }
        else{
            return 46;
        }
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (newsButton.selected)
    {
        return newsList.count;
    }
    else
    {
        return followingNewsList.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NewsCell *cell = (NewsCell *)[tableView dequeueReusableCellWithIdentifier:CellClassName];
    if (!cell){
        NSArray *topLevelItems = [cellLoader instantiateWithOwner:self options:nil];
        cell = [topLevelItems objectAtIndex:0];
    }
    
    if (newsButton.selected)
    {
        if (newsList.count > 0)
        {
            NSDictionary *newsFeed = [newsList objectAtIndex:indexPath.row];
            [cell setNewsFeed:newsFeed];
        }
    }
    else
    {
        if (followingNewsList.count > 0)
        {
            NSDictionary *newsFeed = [followingNewsList objectAtIndex:indexPath.row];
            [cell setNewsFeed:newsFeed];
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Data
- (void)getFollowingNewsTimeline:(NSString*)facebookID
{
    NSURL *url = [NSURL URLWithString:@"https://stockshot-kk.appspot.com/api/get_follow_timeline"];
    NSString *params = [[NSString alloc] initWithFormat:@"facebook_id=%@&request_type=%@",facebookID,@"owner"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    [request setTimeoutInterval:7];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation
                                         JSONRequestOperationWithRequest:request
                                         success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
                                         {;
                                             NSLog(@"NEWS: %@",JSON);
                                             followingNewsList = [JSON objectForKey:@"timeline"];
                                             [feedTable reloadData];
                                         } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
                                         {
                                             [Utility alertWithMessage:[NSString stringWithFormat:@"ERROR: %@",url]];
                                             [self dismissViewControllerAnimated:YES completion:nil];
                                         }];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    
    [operation start];
    
    
}

- (void)getNewsTimeline:(NSString*)facebookID
{
    NSURL *url = [NSURL URLWithString:@"https://stockshot-kk.appspot.com/api/get_news_timeline"];
    NSString *params = [[NSString alloc] initWithFormat:@"facebook_id=%@&request_type=%@",facebookID,@"owner"];
//    NSLog(@"params: %@",params);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    [request setTimeoutInterval:7];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation
                                         JSONRequestOperationWithRequest:request
                                         success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
                                         {;
//                                             NSLog(@"NEWS: %@",JSON);
                                             newsList = [JSON objectForKey:@"timeline"];
                                             [feedTable reloadData];
                                         } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
                                         {
                                             [Utility alertWithMessage:[NSString stringWithFormat:@"ERROR: %@",url]];
                                             [self dismissViewControllerAnimated:YES completion:nil];
                                         }];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    
    [operation start];
    
    
}

@end
