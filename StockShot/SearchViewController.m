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
#import "Stock+addition.h"
#import "AppDelegate.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ProfileViewController.h"
#import "StockViewController.h"
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
    BOOL keyboardShow;
    NSArray *likePhotos;
}
@end

@implementation SearchViewController


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

    self.navigationItem.leftBarButtonItem = [Utility menuBarButtonWithID:self];
    UIButton *refreshButton = [Utility refreshButton];
    [refreshButton addTarget:self action:@selector(reloadPhotos) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:refreshButton];
    
    resultImages = [[NSMutableArray alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"TestNotification"
                                               object:nil];
    
    [self loadGridView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [Datahandler getRandomPhotosOnComplete:^(BOOL success, NSArray *photos) {
        if (success) {
            NSLog(@"Photos: %@",photos);
        }
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [searchTextField resignFirstResponder];
}

- (void)reloadPhotos
{
    NSLog(@"ReloadPhotos");
}


- (void)loadGridView
{
    NSInteger spacing = 5;
    
    GMGridView *gmGridView = [[GMGridView alloc] initWithFrame:CGRectMake(5, 58, 310, 397)];
    gmGridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    gmGridView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:gmGridView];
    _gmGridView = gmGridView;
    _gmGridView.style = GMGridViewStyleSwap;
    _gmGridView.itemSpacing = spacing;
    _gmGridView.centerGrid = NO;
    _gmGridView.enableEditOnLongPress = NO;
    _gmGridView.actionDelegate = self;
    _gmGridView.dataSource = self;
    _gmGridView.mainSuperView = self.view;
    [_gmGridView setClipsToBounds:YES];
}

#pragma mark - IBAction
- (IBAction)touchCancel:(id)sender
{
    [searchTextField resignFirstResponder];
}

- (IBAction)touchContentType:(id)sender
{
    UIButton *button = (UIButton*)sender;
    
    if (button == userTypeButton)
    {
        userTypeButton.selected = YES;
        userTypeButton.backgroundColor = [UIColor colorWithRed:33.0/255.0 green:107.0/255.0 blue:166.0/255.0 alpha:1];
        
        hashTagTypeButton.selected = NO;
        hashTagTypeButton.backgroundColor = [UIColor colorWithRed:63.0/255.0 green:80.0/255.0 blue:88.0/255.0 alpha:1];

    }
    else
    {
        userTypeButton.selected = NO;
        userTypeButton.backgroundColor = [UIColor colorWithRed:63.0/255.0 green:80.0/255.0 blue:88.0/255.0 alpha:1];
        
        hashTagTypeButton.selected = YES;
        hashTagTypeButton.backgroundColor = [UIColor colorWithRed:33.0/255.0 green:107.0/255.0 blue:166.0/255.0 alpha:1];
    }
    
    [resultTableView reloadData];
    
}
# pragma mark Keyboard Notifications

- (void)keyboardWillShow:(NSNotification *)notification {
    keyboardShow = YES;
    [self resizeViewWithOptions:[notification userInfo]];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    keyboardShow = NO;
    [self resizeViewWithOptions:[notification userInfo]];
}

- (void)resizeViewWithOptions:(NSDictionary *)options
{
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    [[options objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[options objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[options objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:animationCurve];
    [UIView setAnimationDuration:animationDuration];
    
    CGRect viewFrame = self.view.frame;
    NSLog(@"viewFrame y: %@", NSStringFromCGRect(viewFrame));
    
    CGRect keyboardFrameEndRelative = [self.view convertRect:keyboardEndFrame fromView:nil];
    NSLog(@"self.view: %@", self.view);
    NSLog(@"keyboardFrameEndRelative: %@", NSStringFromCGRect(keyboardFrameEndRelative));
    
    viewFrame.size.height =  keyboardFrameEndRelative.origin.y;// - textInputView.frame.size.height;
    self.view.frame = viewFrame;
    
    CGRect cancelRect = cancelButton.frame;
    CGRect searchRect = searchView.frame;
    if (keyboardShow) {
        cancelRect.origin.x = 269;
        searchRect.size.width = 260;
    }
    else{
        cancelRect.origin.x = 320;
        searchRect.size.width = 310;
    }
    cancelButton.frame = cancelRect;
    searchView.frame = searchRect;
    
    [UIView commitAnimations];
}

#pragma mark GMGridViewDataSource
- (NSInteger)numberOfItemsInGMGridView:(GMGridView *)gridView
{
    return likePhotos.count;
}

- (CGSize)GMGridView:(GMGridView *)gridView sizeForItemsInInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    return CGSizeMake(70, 70);
}
#pragma mark GMGridViewActionDelegate

- (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)position
{
    NSLog(@"Did tap at index %d", position);
//    PhotoViewController *photoViewController = [[PhotoViewController alloc] init];
//    photoViewController.photo = [userPhotos objectAtIndex:position];
//    [self.navigationController pushViewController:photoViewController animated:YES];
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
    if (likePhotos.count > 0)
    {
//        NSDictionary *photo = [userPhotos objectAtIndex:index];
//        [imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://stockshot-kk.appspot.com/api/photo?photo_key=%@",[photo objectForKey:@"key"]]]
//                  placeholderImage:[UIImage imageNamed:@"profileImage.png"]];
    }
    return cell;
}


- (BOOL)GMGridView:(GMGridView *)gridView canDeleteItemAtIndex:(NSInteger)index
{
    return NO; //index % 2 == 0;
}


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
    if (hashTagTypeButton.selected)
        return hotSearch.count;
    else
        return resultUsers.count;
}
    
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (hashTagTypeButton.selected)
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (hashTagTypeButton.selected)
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

#pragma mark UITextField Delegate Methods
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"Begin Edit");
    [self getHotSerach];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    Stock *stock = [Stock getStockWithName:[textField.text uppercaseString]];
    if (stock) {
        StockViewController *stockVC = [[StockViewController alloc] initWithStock:stock];
        [self.navigationController  pushViewController:stockVC animated:YES];
    }
   
    [searchTextField resignFirstResponder];
    NSLog(@"SEARCH: %@",textField.text);
    
    [self searchFromString:textField.text];
    
    return  YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"End Edit");
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
                                             [resultTableView reloadData];
                                         } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
                                         {
                                             [Utility alertWithMessage:[NSString stringWithFormat:@"ERROR: %@",url]];
                                             [self dismissViewControllerAnimated:YES completion:nil];
                                         }];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    
    [operation start];
}

- (void)searchFromString:(NSString*)hashTag
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
                                             [resultTableView reloadData];
                                         } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
                                         {
                                             [Utility alertWithMessage:[NSString stringWithFormat:@"ERROR: %@",url]];
                                         }];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    [operation start];
}



@end
