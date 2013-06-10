//
//  EditProfileViewController.m
//  StockShot
//
//  Created by Phatthana Tongon on 6/2/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import "EditProfileViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AFJSONRequestOperation.h"
#import "AppDelegate.h"
@interface EditProfileViewController ()
{
    AppDelegate *appdelegate;
    UITextField *currentTextField;
    BOOL keyboardShow;
}
@end

@implementation EditProfileViewController

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
    self.navigationItem.leftBarButtonItem = [Utility backButton:self];
    UIButton *doneButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [doneButton setImage:[UIImage imageNamed:@"check_bt.png"] forState:UIControlStateNormal];
    [doneButton addTarget:self
                   action:@selector(touchUpdateDone:)
         forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
    
    [mainScrollView addSubview:contentView];
    mainScrollView.contentSize = contentView.frame.size;
    
    [profileImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture",self.user.facebookID]]
                     placeholderImage:[UIImage imageNamed:@"profileImage.png"]];
    
    nameLabel.text = self.user.name;
    userNameLabel.text = self.user.username;
    statusLabel.text = @"Status";
    emailLabel.text = self.user.email;
        
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"TestNotification"
                                               object:nil];
}

- (IBAction)touchUpdateDone:(id)sender
{
//    NSLog(@"EDIT DONE");
    [self updatePlayer];
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
//    NSLog(@"viewFrame y: %@", NSStringFromCGRect(viewFrame));
    
    CGRect keyboardFrameEndRelative = [self.view convertRect:keyboardEndFrame fromView:nil];
//    NSLog(@"self.view: %@", self.view);
//    NSLog(@"keyboardFrameEndRelative: %@", NSStringFromCGRect(keyboardFrameEndRelative));
    
    viewFrame.size.height =  keyboardFrameEndRelative.origin.y;// - textInputView.frame.size.height;
    self.view.frame = viewFrame;
    
    [UIView commitAnimations];
}


#pragma mark - Data
- (void)updatePlayer
{
    NSURL *url = [NSURL URLWithString:@"https://stockshot-kk.appspot.com/api/player"];
    NSString *params = [[NSString alloc] initWithFormat:@"facebook_id=%@&name=%@&username=%@&first_name=%@&last_name=%@&email=%@&locale=%@&device_token=%@&request_type=%@"
                        ,self.user.facebookID
                        ,nameLabel.text
                        ,userNameLabel.text
                        ,self.user.firstName
                        ,self.user.lastName
                        ,emailLabel.text
                        ,self.user.locale
                        ,self.user.deviceToken,
                        @"register"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    [request setTimeoutInterval:7];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
                                         {
                                             NSDictionary *dictionary = [NSDictionary dictionaryWithDictionary:JSON];
                                             [self dismissViewControllerAnimated:YES completion:nil];
//                                             User *user = [User me];
                                             
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
                                             [self.navigationController popViewControllerAnimated:YES];
                                             NSLog(@"UPDATE USER DONE!");
                                             
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
