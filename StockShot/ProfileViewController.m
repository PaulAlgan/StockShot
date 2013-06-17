//
//  ProfileViewController.m
//  StockShot
//
//  Created by Phatthana Tongon on 5/21/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import "ProfileViewController.h"
#import "User+addition.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AFJSONRequestOperation.h"
#import "GMGridView.h"
#import "OptionsViewController.h"
#import "EditProfileViewController.h"
#import "AppDelegate.h"
#import "PhotoViewController.h"
@interface ProfileViewController ()
<GMGridViewDataSource, GMGridViewSortingDelegate, GMGridViewTransformationDelegate, GMGridViewActionDelegate>
{
    AppDelegate *appdelegate;
    NSMutableArray *userPhotos;
    __gm_weak GMGridView *_gmGridView;
    User *me;
}
@end

@implementation ProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithUser:(User*)user
{
    self = [super init];
    if (self) {
        self.user = user;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if (self.navigationController.viewControllers.count > 1){
        self.navigationItem.leftBarButtonItem = [Utility backButton:self];
    }
    else{
        self.navigationItem.leftBarButtonItem = [Utility menuBarButtonWithID:self];
    }

    self.title = @"Profile";
    
    if ([self.user.me boolValue]){
        chatButton.hidden = YES;
        editProfileButton.hidden = NO;
        followButton.hidden = YES;
    }
    else{
        chatButton.hidden = NO;
        editProfileButton.hidden = YES;
        followButton.hidden = NO;
        
        CGRect contentRect = contentView.frame;
        contentRect.origin.y += 35;
        contentRect.size.height -= 40;
        contentView.frame = contentRect;
    }
    
    [self loadGridView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
//    NSLog(@"ProfileView: %@",NSStringFromCGRect(self.view.frame));
    [self reloadUserData];
    [self getImageListWithUserID:self.user.facebookID];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
//    NSLog(@"viewDidAppear");
}

- (void)setUser:(User *)user
{
    _user = user;
    [userPhotos removeAllObjects];
    [_gmGridView reloadData];
}

- (void)reloadUserData
{
//    NSLog(@"User: %@",[self.user debugDescription]);
    [profileImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture",self.user.facebookID]]
                     placeholderImage:[UIImage imageNamed:@"profileImage.png"]];
    userNameLabel.text = self.user.name;
    [followerButton setTitle:[NSString stringWithFormat:@"%d",[self.user.followerCount intValue]]
                    forState:UIControlStateNormal];
    [followingButton setTitle:[NSString stringWithFormat:@"%d",[self.user.followingCount intValue]]
                     forState:UIControlStateNormal];
    [photoButton setTitle:[NSString stringWithFormat:@"%d",[self.user.photoCount intValue]]
                 forState:UIControlStateNormal];

}

#pragma mark - IBAction
- (IBAction)touchChat:(id)sender
{
    [appdelegate chatWithUser:self.user];
}

- (IBAction)touchEditProfile:(id)sender
{
    EditProfileViewController *editProfile = [[EditProfileViewController alloc] initWithUser:self.user];
    [self.navigationController pushViewController:editProfile animated:YES];
}

- (IBAction)touchFollow:(id)sender
{
    [self followPlayerID:self.user.facebookID];
}
- (IBAction)touchFollower:(id)sender
{
    
}

- (IBAction)touchFollowing:(id)sender
{
    
}

- (void)loadGridView
{
    NSInteger spacing = 5;
    
    GMGridView *gmGridView = [[GMGridView alloc] initWithFrame:CGRectMake(0, 3,
                                                                          contentView.frame.size.width,
                                                                          contentView.frame.size.height-3)];
    gmGridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    gmGridView.backgroundColor = [UIColor clearColor];
    [contentView addSubview:gmGridView];
    _gmGridView = gmGridView;
    _gmGridView.style = GMGridViewStyleSwap;
    _gmGridView.itemSpacing = spacing;
    _gmGridView.centerGrid = NO;
    _gmGridView.enableEditOnLongPress = NO;
    _gmGridView.actionDelegate = self;
    _gmGridView.dataSource = self;
    _gmGridView.mainSuperView = contentView;
    [_gmGridView setClipsToBounds:YES];
}

#pragma mark GMGridViewDataSource
- (NSInteger)numberOfItemsInGMGridView:(GMGridView *)gridView
{
    return userPhotos.count;
}

- (CGSize)GMGridView:(GMGridView *)gridView sizeForItemsInInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    return CGSizeMake(70, 70);
}
#pragma mark GMGridViewActionDelegate

- (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)position
{
    NSLog(@"Did tap at index %d", position);
    PhotoViewController *photoViewController = [[PhotoViewController alloc] init];
    photoViewController.photo = [userPhotos objectAtIndex:position];
    [self.navigationController pushViewController:photoViewController animated:YES];
}

- (void)GMGridViewDidTapOnEmptySpace:(GMGridView *)gridView
{
    NSLog(@"Tap on empty space");
}

#define IMAGE_VIEW_TAG 101

- (GMGridViewCell *)GMGridView:(GMGridView *)gridView cellForItemAtIndex:(NSInteger)index
{
    CGSize size = [self GMGridView:gridView sizeForItemsInInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    
    GMGridViewCell *cell = [gridView dequeueReusableCell];
    UIImageView *imageView;
    
    if (!cell)
    {
        cell = [[GMGridViewCell alloc] init];
        cell.deleteButtonIcon = [UIImage imageNamed:@"close_x.png"];
        cell.deleteButtonOffset = CGPointMake(-15, -15);
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        imageView.tag = IMAGE_VIEW_TAG;
        imageView.backgroundColor = [UIColor redColor];
        imageView.layer.masksToBounds = NO;
        cell.contentView = imageView;
    }
    else
    {
        imageView = (UIImageView*)[cell.contentView viewWithTag:IMAGE_VIEW_TAG];
    }
//    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (userPhotos.count > 0)
    {
        NSDictionary *photo = [userPhotos objectAtIndex:index];
        [imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://stockshot-kk.appspot.com/api/photo?photo_key=%@",[photo objectForKey:@"key"]]]
                  placeholderImage:[UIImage imageNamed:@"profileImage.png"]];
    }
    return cell;
}

- (BOOL)GMGridView:(GMGridView *)gridView shouldAllowShakingBehaviorWhenMovingCell:(GMGridViewCell *)view atIndex:(NSInteger)index
{
    return NO;
}

- (BOOL)GMGridView:(GMGridView *)gridView canDeleteItemAtIndex:(NSInteger)index
{
    return NO; //index % 2 == 0;
}

#pragma mark - Data
- (void)getImageListWithUserID:(NSString*)userID
{
    NSURL *url = [NSURL URLWithString:@"https://stockshot-kk.appspot.com/api/player"];
    NSString *params = [[NSString alloc] initWithFormat:@"facebook_id=%@&request_type=%@"
                        ,userID
                        ,@"request_info"];
    
//    NSLog(@"PARA: %@",params);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    [request setTimeoutInterval:7];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
                                         {
                                             NSDictionary *dictionary = [NSDictionary dictionaryWithDictionary:JSON];
//                                             NSLog(@"USER RESULT: %@",JSON);
                                             [self dismissViewControllerAnimated:YES completion:nil];
                                             
                                             self.user.username = [dictionary objectForKey:@"username"];
                                             self.user.name = [dictionary objectForKey:@"name"];
                                             self.user.firstName = [dictionary objectForKey:@"first_name"];
                                             self.user.lastName = [dictionary objectForKey:@"last_name"];
                                             self.user.facebookID = [dictionary objectForKey:@"facebook_id"];
                                             self.user.email = [dictionary objectForKey:@"email"];
                                             self.user.deviceToken = [dictionary objectForKey:@"device_token"];
                                             self.user.locale = [dictionary objectForKey:@"locale"];
                                             
                                             self.user.notiComment = [dictionary objectForKey:@"notification_comment"];
                                             self.user.notiContact = [dictionary objectForKey:@"notification_contact"];
                                             self.user.notiLike = [dictionary objectForKey:@"notification_like"];
                                             
                                             self.user.followerCount =
                                             [NSNumber numberWithLong:[[dictionary objectForKey:@"follower_count"] longValue]];
                                             self.user.followingCount =
                                             [NSNumber numberWithLong:[[dictionary objectForKey:@"following_count"] longValue]];
                                             self.user.photoCount =
                                             [NSNumber numberWithLong:[[dictionary objectForKey:@"photo_count"] longValue]];
                                             self.user.photoLikeCount =
                                             [NSNumber numberWithLong:[[dictionary objectForKey:@"photo_like_count"] longValue]];
                                             [appdelegate saveContext];
                                             NSArray *photos = [dictionary objectForKey:@"photo"];
//                                             NSLog(@"photo: %@",photos);
                                             
                                             if (!userPhotos) userPhotos = [[NSMutableArray alloc] init];
                                             else [userPhotos removeAllObjects];

                                             userPhotos = [NSArray arrayWithArray:photos];
                                             [_gmGridView reloadData];
                                             [self reloadUserData];
                                             [self dismissViewControllerAnimated:YES completion:nil];
                                         } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
                                         {
                                             [Utility alertWithMessage:[NSString stringWithFormat:@"ERROR: %@",url]];
                                             [self dismissViewControllerAnimated:YES completion:nil];
                                         }];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    [operation start];
}

- (void)followPlayerID:(NSString*)targetID
{
    me = [User me];
    if (me) {
        NSURL *url = [NSURL URLWithString:@"https://stockshot-kk.appspot.com/api/follow"];
        NSString *params = [[NSString alloc] initWithFormat:@"facebook_id=%@&target_id=%@",me.facebookID,targetID];
        
//        NSLog(@"URL: %@",[url absoluteString]);
//        NSLog(@"params: %@",params);
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
