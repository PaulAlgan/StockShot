//
//  FacebookFriendViewController.m
//  StockShot
//
//  Created by Phatthana Tongon on 4/24/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import "FacebookFriendViewController.h"
#import "AFJSONRequestOperation.h"
#import <FacebookSDK/FacebookSDK.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "User+addition.h"
#import "AppDelegate.h"
@interface FacebookFriendViewController ()
{
    AppDelegate *appdelegate;
    NSMutableArray *facebookFriends;
    NSMutableDictionary *friendsDict;
    NSMutableArray *users;
    User *me;
}
@end

@implementation FacebookFriendViewController

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
    self.title = @"Facebook";
    self.navigationItem.leftBarButtonItem = [Utility backButton:self];
    
    appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [self getFriendList];
    
    me = [User meInManagedObjectContext:appdelegate.managedObjectContext];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return users.count;
}

- (UITableViewCell *)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UIButton *followBt;
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        followBt = [[UIButton alloc] initWithFrame:CGRectMake(232, 5, 75, 35)];
        followBt.backgroundColor = [UIColor grayColor];
        [followBt addTarget:self action:@selector(touchFollowBt:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:followBt];
    }
    else
    {
        [followBt removeFromSuperview];
        followBt = [[UIButton alloc] initWithFrame:CGRectMake(232, 5, 75, 35)];
        followBt.backgroundColor = [UIColor grayColor];
        [followBt addTarget:self action:@selector(touchFollowBt:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:followBt];
    }
    if (users.count > 0)
    {
        followBt.titleLabel.font = [UIFont systemFontOfSize:14];
        followBt.tag = 1000000+indexPath.row;
        NSDictionary *user = [users objectAtIndex:indexPath.row];
        if ([[user objectForKey:@"result"] intValue] == 1)
        {
            NSDictionary *dict = [user objectForKey:@"player"];
            cell.textLabel.text = [dict objectForKey:@"name"];
            followBt.backgroundColor = [UIColor colorWithRed:48.0/255.0 green:63.0/255.0 blue:70.0/255.0 alpha:1];
            
            if ([[user objectForKey:@"following"] intValue] == 1){
                [followBt setTitle:@"Following" forState:UIControlStateNormal];
            }
            else{
                [followBt setTitle:@"Follow" forState:UIControlStateNormal];
            }
            cell.imageView.image = nil;
//            NSLog(@"USER: %@",user);
        }
        else
        {
            NSDictionary *dict = [friendsDict objectForKey:[user objectForKey:@"facebook_id"]];
            if (dict) { // FB USER
                cell.textLabel.text = [dict objectForKey:@"name"];
                [cell.imageView setImageWithURL:[NSURL URLWithString:[[[dict objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"]]
                               placeholderImage:nil];
//                NSLog(@"URL: %@",[[[dict objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"]);
                
            }
            else{
                cell.textLabel.text = [user objectForKey:@"facebook_id"];
            }
            followBt.backgroundColor = [UIColor colorWithRed:228.0/255.0 green:0 blue:19.0/255.0 alpha:1];
            [followBt setTitle:@"Invite" forState:UIControlStateNormal];
            
        }
        
    }
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)touchFollowBt:(UIButton*)button
{
    long tag = button.tag;
    NSLog(@"TAG: %ld",tag);
    NSDictionary *user = [users objectAtIndex:tag-1000000];
    [self followUserID:[user objectForKey:@"facebook_id"]];
    
}

#pragma mark - Data
- (void)getUser
{
    NSString *facebookIDlist = [[NSString alloc] init];
    
    if (facebookFriends.count > 0)
    {
        NSDictionary *facebookDict = [facebookFriends objectAtIndex:0];
//        facebookIDlist = [facebookDict objectForKey:@"id"];
        facebookIDlist = @"12341234,680725568, 12341235,1234";
        for (int i=1; i<facebookFriends.count; i++)
        {
            facebookDict = [facebookFriends objectAtIndex:i];
            facebookIDlist = [facebookIDlist stringByAppendingFormat:@",%@",[facebookDict objectForKey:@"id"]];
        }
    }
    NSURL *url = [NSURL URLWithString:@"https://stockshot-kk.appspot.com/api/check_player"];
    NSString *params = [[NSString alloc] initWithFormat:@"facebook_id_list=%@&facebook_id=%@",facebookIDlist,me.facebookID];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    [request setTimeoutInterval:20];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
                                         {
                                             if (!users) {
                                                 users = [[NSMutableArray alloc] init];
                                             }
                                             else{
                                                 [users removeAllObjects];
                                             }
                                             users = JSON;
                                             NSLog(@"User[%d]: %@",users.count,[users objectAtIndex:0]);
                                             [userTable reloadData];
                                         } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
                                         {
                                             [Utility alertWithMessage:[NSString stringWithFormat:@"ERROR: %@",url]];
                                             [self dismissViewControllerAnimated:YES completion:nil];
                                         }];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    
    [operation start];
    
    
}

- (void)getFriendList
{
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    @"picture,id,name,last_name,first_name",@"fields",
                                    @"100",@"limit",
                                    nil];
    FBRequest *friendsRequest = [FBRequest requestWithGraphPath:@"me/friends"
                                                     parameters:params
                                                     HTTPMethod:@"GET"];
    [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection,
                                                  NSDictionary* result,
                                                  NSError *error) {
        if (!facebookFriends) {
            facebookFriends = [[NSMutableArray alloc] init];
        }
        facebookFriends = [result objectForKey:@"data"];
        
        if (!friendsDict) {
            friendsDict = [[NSMutableDictionary alloc] init];
        }
        
        for (int i=0; i<facebookFriends.count; i++)
        {
            [friendsDict setObject:[facebookFriends objectAtIndex:i]
                            forKey:[[facebookFriends objectAtIndex:i] objectForKey:@"id"]];
        }
        NSLog(@"FRIEND: %@",[facebookFriends objectAtIndex:0]);
        
        [self getUser];
    }];
}

- (void)followUserID:(NSString*)userID
{
    if (me) {
        NSURL *url = [NSURL URLWithString:@"https://stockshot-kk.appspot.com/api/follow"];
        NSString *params = [[NSString alloc] initWithFormat:@"facebook_id=%@&target_id=%@",me.facebookID,userID];
        
        NSLog(@"URL: %@",[url absoluteString]);
        NSLog(@"params: %@",params);
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
        [request setTimeoutInterval:20];

        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
                                             {
                                                 NSLog(@"Result: %@",JSON);
                                                 [Utility alertWithMessage:[NSString stringWithFormat:@"Follow: %@",[JSON objectForKey:@"result"]]];
                                                 
                                             } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
                                             {
                                                 [Utility alertWithMessage:[NSString stringWithFormat:@"ERROR: %@",url]];
                                                 [self dismissViewControllerAnimated:YES completion:nil];
                                             }];
        [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
        
        [operation start];

    }
}

//https://stockshot-kk.appspot.com/api/follow
//https://stockshot-kk.appspot.com/api/check_player

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
