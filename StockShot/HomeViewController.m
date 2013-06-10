//
//  HomeViewController.m
//  StockShot
//
//  Created by Phatthana Tongon on 4/21/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import "HomeViewController.h"
#import "LoginViewController.h"

#import "AppDelegate.h"
#import "User+addition.h"
#import "AFJSONRequestOperation.h"
#import "ImageViewCell.h"
#import "CommentViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "TTTAttributedLabel.h"

static NSString *CellClassName = @"ImageViewCell";

@interface HomeViewController ()
{
    AppDelegate *appdelegate;
    NSMutableArray *resultImages;
    User *me;
}
@end

@implementation HomeViewController

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
    
    self.navigationItem.title = @"StockShot";
    cellLoader = [UINib nibWithNibName:CellClassName bundle:[NSBundle mainBundle]];
    appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];    
    self.navigationItem.leftBarButtonItem = [Utility menuBarButtonWithID:self];
 
    UIButton *refreshButton = [Utility refreshButton];
    [refreshButton addTarget:self action:@selector(reloadTimeline) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:refreshButton];
    
    me = [User meInManagedObjectContext:appdelegate.managedObjectContext];
    LoginViewController *loginView = [[LoginViewController alloc] init];
    if (!me)
    {
        loginView.haveUser = NO;
        [self presentViewController:loginView animated:YES completion:nil];
    }
    else
    {
        loginView.haveUser = YES;
        [self presentViewController:loginView animated:NO completion:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    me = [User me];
    if (me) {
        [self getTimeline:me.facebookID];
    }
}

- (void)reloadTimeline
{
    me = [User me];
    if (me) {
        NSLog(@"Reload Timeline: %@",me.facebookID);
        [self getTimeline:me.facebookID];
    }
}

#pragma mark - IBAction

- (IBAction)touchUserName:(id)sender
{
    UIButton *button = (UIButton*)sender;
    
//    NSLog(@"TITLE[%d]: %@",button.tag,button.titleLabel.text);
    NSDictionary *player = [[resultImages objectAtIndex:button.tag-200] objectForKey:@"player"];

    User *user = [User userWithFacebookID:[player objectForKey:@"facebook_id"] InManagedObjectContext:appdelegate.managedObjectContext];
//    NSLog(@"user: %@",[user debugDescription]);
    
    [appdelegate selectProfilePageWithUser:user];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 45;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 400;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (resultImages.count > 0)
        return resultImages.count;
    else
        return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // Return the number of rows in the section.
    return 1;
}

#pragma mark - ImageCell Delegate
- (void)touchCommentInKey:(NSString *)key
{
    NSLog(@"KEY: %@",key);
    NSDictionary *targetPhotoDict = nil;
    for (NSDictionary *dict in  resultImages){
        if ([[dict objectForKey:@"key"] isEqualToString:key]){
            targetPhotoDict = dict;
            break;
        }
    }

    CommentViewController *commentVC = [[CommentViewController alloc] initWithPhotoDict:targetPhotoDict];
    [self.navigationController pushViewController:commentVC animated:YES];
    [self setHidesBottomBarWhenPushed:NO];

}

#define IMAGE_VIEW_TAG 101
#define USERNAME 200
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *CellIdentifier = @"Header";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UIImageView *userImageView = nil;
    UIButton *userNameButton = nil;
    UIImageView *clockImageView = nil;
    UILabel *timeLabel = nil;
    
    userImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 35, 35)];
    userImageView.backgroundColor = [UIColor redColor];
    userImageView.layer.masksToBounds = NO;
    
    userNameButton = [[UIButton alloc] initWithFrame:CGRectMake(45, 0, 180, 45)];
    userNameButton.tag = USERNAME+section;
    userNameButton.backgroundColor = [UIColor clearColor];
    userNameButton.titleLabel.textColor = [UIColor whiteColor];
    userNameButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    userNameButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    userNameButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [userNameButton addTarget:self
                       action:@selector(touchUserName:) forControlEvents:UIControlEventTouchUpInside];
    
    clockImageView = [[UIImageView alloc] initWithFrame:CGRectMake(258-15, 15, 14, 14)];
    clockImageView.image = [UIImage imageNamed:@"clock.png"];
    clockImageView.backgroundColor = [UIColor clearColor];
    
    timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(275-15, 15, 55, 14)];
    timeLabel.textColor = [UIColor whiteColor];
    timeLabel.font = [UIFont boldSystemFontOfSize:14];
    timeLabel.backgroundColor = [UIColor clearColor];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    for (UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    [cell.contentView addSubview:userImageView];
    [cell.contentView addSubview:userNameButton];
    [cell.contentView addSubview:clockImageView];
    [cell.contentView addSubview:timeLabel];

    
    if (resultImages.count > 0)
    {
        NSDictionary *player = [[resultImages objectAtIndex:section] objectForKey:@"player"];
        
        cell.backgroundColor = [UIColor colorWithRed:125.0/255.0 green:136.0/255.0 blue:146.0/255.0 alpha:1.0];
        
        NSString *playerName = [player objectForKey:@"name"];
        [userNameButton setTitle:playerName forState:UIControlStateNormal];
        
        [userImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture",[player objectForKey:@"facebook_id"]]]
                       placeholderImage:[UIImage imageNamed:@"profileImage.png"]];
        
//        NSString *dateString = [[resultImages objectAtIndex:section] objectForKey:@"date"];
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSSSS";
//        [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
//        timeLabel.text = [self timeAgoWithDate:[formatter dateFromString:dateString]];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
    

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ImageViewCell *cell = (ImageViewCell *)[tableView dequeueReusableCellWithIdentifier:CellClassName];
    if (!cell)
    {
        NSArray *topLevelItems = [cellLoader instantiateWithOwner:self options:nil];
        cell = [topLevelItems objectAtIndex:0];
    }
    
    if (resultImages.count>0) {
        cell.delegate = self;
        cell.backgroundColor = [UIColor greenColor];
        NSDictionary *photo = [resultImages objectAtIndex:indexPath.section];
        NSDictionary *player = [photo objectForKey:@"player"];
        
        cell.urlStringImage = [NSString stringWithFormat:@"https://stockshot-kk.appspot.com/api/photo?photo_key=%@",[photo objectForKey:@"key"]];
        cell.message = [NSString stringWithFormat:@"%@ %@",
                        [player objectForKey:@"name"],[photo objectForKey:@"message"]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.photoKey = [photo objectForKey:@"key"];
//        cell.key  = [[resultImages objectAtIndex:indexPath.row] objectForKey:@"key"];
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - Data
- (void)getTimeline:(NSString*)facebookID
{
//    NSURL *url = [NSURL URLWithString:@"https://stockshot-kk.appspot.com/api/get_follow_timeline"];
    NSURL *url = [NSURL URLWithString:@"https://stockshot-kk.appspot.com/api/get_user_timeline"];
    //'request_type': ['owner, 'other''] 
//    NSString *params = [[NSString alloc] initWithFormat:@"facebook_id=%@",@"12341234"];
    NSString *params = [[NSString alloc] initWithFormat:@"facebook_id=%@",facebookID];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    [request setTimeoutInterval:7];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation
                                         JSONRequestOperationWithRequest:request
                                         success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
                                         {
                                             NSArray *photos = [JSON objectForKey:@"timeline"];
                                             if (!resultImages) resultImages = [[NSMutableArray alloc] init];
                                             
                                             for (int i=0; i<photos.count; i++){
                                                 [resultImages insertObject:[photos objectAtIndex:i] atIndex:0];
                                             }
                                             if (resultImages.count > 0) NSLog(@"PHOTO: %@",[resultImages objectAtIndex:0]);
                                             for (int i=0; i<[resultImages count]; i++)
                                             {
                                                 NSDictionary *player = [[resultImages objectAtIndex:i] objectForKey:@"action_player"];
                                                 User *newUser = [User userWithFacebookID:[player objectForKey:@"facebook_id"]
                                                                         InManagedObjectContext:appdelegate.managedObjectContext];
                                                 newUser.firstName = [player objectForKey:@"first_name"];
                                                 newUser.lastName = [player objectForKey:@"last_name"];
                                                 newUser.name = [player objectForKey:@"name"];
                                                 newUser.username = [player objectForKey:@"username"];                                                 
                                             }
//                                             NSLog(@"ResultImage[0]: %@",[resultImages objectAtIndex:0]);
                                             [contentTableView reloadData];
                                             [appdelegate saveContext];
                                             
                                         } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
                                         {
                                             [Utility alertWithMessage:[NSString stringWithFormat:@"ERROR: %@",url]];
                                             [self dismissViewControllerAnimated:YES completion:nil];
                                         }];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    
    [operation start];
    
}

- (NSString*)timeAgoWithDate:(NSDate *)time
{
    NSCalendar *sysCalendar = [NSCalendar currentCalendar];
    NSDate *dateNow = [NSDate date];
    int timeAgo;
    NSString *unit = [[NSString alloc] init];
    
    unsigned int unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit;
    
    NSDateComponents *breakdownInfo = [sysCalendar components:unitFlags fromDate:time  toDate:dateNow  options:0];
    
    if ([breakdownInfo month] > 0)
    {
        timeAgo = [breakdownInfo month];
        if (timeAgo>1)
            unit = @"months";
        else
            unit = @"month";
    }
    else if([breakdownInfo day] > 0)
    {
        timeAgo = [breakdownInfo day];
        if (timeAgo>1)
            unit = @"days";
        else
            unit = @"day";
    }
    else if([breakdownInfo hour] > 0)
    {
        timeAgo = [breakdownInfo hour];
        if (timeAgo>1)
            unit = @"hours";
        else
            unit = @"hour";
    }
    else if([breakdownInfo minute] > 0)
    {
        timeAgo = [breakdownInfo minute];
        if (timeAgo>1)
            unit = @"m";
        else
            unit = @"m";
    }
    else
    {
        timeAgo = [breakdownInfo second];
        if (timeAgo>1 && timeAgo < 60)
            unit = @"secs";
        else
        {
            unit = @"sec";
            timeAgo = 1;
        }
        
    }
    return [NSString stringWithFormat:@"%d%@",timeAgo,unit];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
