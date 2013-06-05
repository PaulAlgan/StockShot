//
//  MenuViewController.m
//  StockShot
//
//  Created by Phatthana Tongon on 4/21/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import "MenuViewController.h"

#import "AppDelegate.h"
#import "WatchListViewController.h"
#import "FindInviteFriendViewController.h"
#import "LikedViewController.h"
#import "VoteViewController.h"
#import "SettingViewController.h"
#import "PrivacyViewController.h"
#import "TermsOfUseViewController.h"
#import "ProfileViewController.h"
#import "User+addition.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AppDelegate.h"
@interface MenuViewController ()
{
    User *me;
    AppDelegate *appdelegate;
}
@end

@implementation MenuViewController

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
    appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//    menuTableView.separatorColor = [UIColor colorWithRed:135.0/255.0 green:144.0/255.0 blue:146.0/255.0 alpha:1.0];
    menuTableView.separatorColor = [UIColor clearColor];
    menuTableView.backgroundColor = [UIColor clearColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    me = [User me];
    
    userName.text = me.name;
    [profileImageView setImageWithURL:[NSURL URLWithString:
                                       [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture"
                                        ,me.facebookID]]
                     placeholderImage:[UIImage imageNamed:@"profileImage.png"]];

}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 33;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 6;
    }
    else
        return 2;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
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

- (UITableViewCell *)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UIView *background = [[UIView alloc] initWithFrame:CGRectMake(5, 0, 310, 32)];
    background.backgroundColor = [UIColor colorWithRed:48.0/255.0 green:63.0/255.0 blue:70.0/255.0 alpha:1.0];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 32, 310, 1)];
    line.backgroundColor = [UIColor colorWithRed:202.0/255.0 green:210.0/255.0 blue:214.0/255.0 alpha:0.7];


    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    for (UIView *view in cell.contentView.subviews){
        [view removeFromSuperview];
    }

//    [cell.contentView addSubview:background];
//    [background sendSubviewToBack:cell.contentView];

    
    if (indexPath.section == 0)
    {
        switch (indexPath.row)
        {
            case 0:
                cell.textLabel.text = @"Profile";
                cell.imageView.image = [UIImage imageNamed:@"01.png"];
                break;
                
            case 1:
                cell.textLabel.text = @"Hashtag Watch List";
                cell.imageView.image = [UIImage imageNamed:@"02.png"];
                break;
                
            case 2:
                cell.textLabel.text = @"Find & Invite Friend";
                cell.imageView.image = [UIImage imageNamed:@"03.png"];
                break;
                
            case 3:
                cell.textLabel.text = @"Liked by You";
                cell.imageView.image = [UIImage imageNamed:@"04.png"];
                break;
                
            case 4:
                cell.textLabel.text = @"Vote";
                cell.imageView.image = [UIImage imageNamed:@"05.png"];
                break;
                
            case 5:
                cell.textLabel.text = @"Setting";
                cell.imageView.image = [UIImage imageNamed:@"06.png"];
                break;
                
            default:
                break;
        }
        
        if (indexPath.row != 5) {
            [cell.contentView addSubview:line];
            [line sendSubviewToBack:cell.contentView];
        }
    }
    else
    {
        
        switch (indexPath.row)
        {
            case 0:
                cell.textLabel.text = @"Privacy Policy";
                break;
                
            case 1:
                cell.textLabel.text = @"Term of Use";
                break;
                
            default:
                break;
        }
        if (indexPath.row != 1) {
            [cell.contentView addSubview:line];
            [line sendSubviewToBack:cell.contentView];
        }
    
    }
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
    cell.contentView.backgroundColor = [UIColor colorWithRed:48.0/255.0 green:63.0/255.0 blue:70.0/255.0 alpha:1.0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.viewDeckController toggleLeftView];
    
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            [self.viewDeckController setCenterController:appdelegate.tabBarController];
            me = [User me];
            [appdelegate selectProfilePageWithUser:me];
        }
        else if (indexPath.row == 1)
        {
            WatchListViewController *watchListView = [[WatchListViewController alloc] init];
            UINavigationController *watchListNavi = [[UINavigationController  alloc] initWithRootViewController:watchListView];
            [self.viewDeckController setCenterController:watchListNavi];
        }
        else if (indexPath.row == 2)
        {
            FindInviteFriendViewController *findFriend = [[FindInviteFriendViewController alloc] init];
            UINavigationController *findFriendNavi = [[UINavigationController alloc] initWithRootViewController:findFriend];
            [self.viewDeckController setCenterController:findFriendNavi];
        }
        else if (indexPath.row == 3)
        {
            LikedViewController *likedView = [[LikedViewController alloc] init];
            UINavigationController *likedNavi = [[UINavigationController alloc] initWithRootViewController:likedView];
            [self.viewDeckController setCenterController:likedNavi];
        }
        else if (indexPath.row == 4)
        {
            VoteViewController *voteView = [[VoteViewController alloc] init];
            UINavigationController *voteNavi = [[UINavigationController alloc] initWithRootViewController:voteView];
            [self.viewDeckController setCenterController:voteNavi];
        }
        else if (indexPath.row == 5)
        {
            SettingViewController *settingView = [[SettingViewController alloc] init];
            UINavigationController *settingNavi = [[UINavigationController alloc] initWithRootViewController:settingView];
            [self.viewDeckController setCenterController:settingNavi];
        }

    }
    else
    {
        if (indexPath.row == 0)
        {
            PrivacyViewController *privacyView = [[PrivacyViewController alloc] init];
            UINavigationController *privacyNavi = [[UINavigationController alloc] initWithRootViewController:privacyView];
            [self.viewDeckController setCenterController:privacyNavi];
        }
        else if (indexPath.row == 1)
        {
            TermsOfUseViewController *termOfUseView = [[TermsOfUseViewController alloc] init];
            UINavigationController *termOfUseNavi = [[UINavigationController alloc] initWithRootViewController:termOfUseView];
            [self.viewDeckController setCenterController:termOfUseNavi];
        }

    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
