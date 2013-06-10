//
//  LoginViewController.m
//  StockShot
//
//  Created by Phatthana Tongon on 4/26/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import "LoginViewController.h"
#import "User+addition.h"
#import "AppDelegate.h"
#import "AFJSONRequestOperation.h"

@interface LoginViewController ()
{
    AppDelegate *appdelegate;
}
@end

@implementation LoginViewController
@synthesize haveUser;

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
    
    if (self.haveUser)
    {
        imageView.hidden = NO;
        [self openSession];
    }
    else
    {
        imageView.hidden = YES;
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)openSession {
    // if the session is open, then load the data for our view controller
    
    if (FBSession.activeSession.isOpen)
    {
        NSLog(@"Open DONE");
        
        //680725568?fields=id,name,email,first_name,last_name,username,locale
        
        NSMutableDictionary * params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        @"id,name,email,first_name,last_name,username,locale",@"fields",
                                        nil];
        
        FBRequest *friendsRequest = [FBRequest requestWithGraphPath:@"me"
                                                         parameters:params
                                                         HTTPMethod:@"GET"];
        
        [friendsRequest startWithCompletionHandler:^(FBRequestConnection *connection,
                                                     id result,
                                                     NSError *error) {
            NSLog(@"Result: %@",result);
            
            User *user = [User userWithFacebookID:[result objectForKey:@"id"] InManagedObjectContext:appdelegate.managedObjectContext];
            if (!self.haveUser) {
                user.name = [result objectForKey:@"name"];
                user.username = [result objectForKey:@"username"];
                user.firstName = [result objectForKey:@"first_name"];
                user.lastName = [result objectForKey:@"last_name"];
                user.locale = [result objectForKey:@"locale"];
                user.email = [result objectForKey:@"email"];
                user.me = [NSNumber numberWithBool:YES];
                [appdelegate saveContext];
            }
            
            [self getPlayerWithUser:user deviceToken:@""];
//            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        
    }
    else
    {
        // if the session isn't open, we open it here, which may cause UX to log in the user
        NSLog(@"NOT OPEN");
        [FBSession openActiveSessionWithReadPermissions:[Utility facebookPermission]
                                           allowLoginUI:YES
                                      completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                                          if (!error) {
                                              [self openSession];
                                          } else {
                                              [[[UIAlertView alloc] initWithTitle:@"Error"
                                                                          message:error.localizedDescription
                                                                         delegate:nil
                                                                cancelButtonTitle:@"OK"
                                                                otherButtonTitles:nil]
                                               show];
                                          }
                                      }];
    }
}


- (IBAction)touchConnectFacebook:(id)sender
{
    [self openSession];
}


- (void)getPlayerWithUser:(User*)user deviceToken:(NSString*)deviceToken
{
    NSURL *url = [NSURL URLWithString:@"https://stockshot-kk.appspot.com/api/player"];
    NSString *params = [[NSString alloc] initWithFormat:@"facebook_id=%@&name=%@&username=%@&first_name=%@&last_name=%@&email=%@&locale=%@&device_token=%@&request_type=%@"
                        ,user.facebookID
                        ,user.name
                        ,user.username
                        ,user.firstName
                        ,user.lastName
                        ,user.email
                        ,user.locale
                        ,deviceToken,
                        @"register"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    [request setTimeoutInterval:7];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
                                         {
                                             NSDictionary *dictionary = [NSDictionary dictionaryWithDictionary:JSON];
                                             NSLog(@"getPlayerWithUser: %@",dictionary);
                                             [self dismissViewControllerAnimated:YES completion:nil];
                                             User *user = [User me];

                                             user.username = [dictionary objectForKey:@"username"];
                                             user.name = [dictionary objectForKey:@"name"];
                                             user.firstName = [dictionary objectForKey:@"first_name"];
                                             user.lastName = [dictionary objectForKey:@"last_name"];
                                             user.facebookID = [dictionary objectForKey:@"facebook_id"];
                                             user.email = [dictionary objectForKey:@"email"];
                                             user.deviceToken = [dictionary objectForKey:@"device_token"];
                                             user.locale = [dictionary objectForKey:@"locale"];
                                             
                                             user.notiComment = [dictionary objectForKey:@"notification_comment"];
                                             user.notiContact = [dictionary objectForKey:@"notification_contact"];
                                             user.notiLike = [dictionary objectForKey:@"notification_like"];
                                             
                                             user.followerCount =
                                             [NSNumber numberWithLong:[[dictionary objectForKey:@"follower_count"] longValue]];
                                             user.followingCount =
                                             [NSNumber numberWithLong:[[dictionary objectForKey:@"following_count"] longValue]];
                                             user.photoCount =
                                             [NSNumber numberWithLong:[[dictionary objectForKey:@"photo_count"] longValue]];
                                             user.photoLikeCount =
                                             [NSNumber numberWithLong:[[dictionary objectForKey:@"photo_like_count"] longValue]];
                                             
                                             [appdelegate saveContext];
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
