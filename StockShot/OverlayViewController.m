//
//  OverlayViewController.m
//  StockShot
//
//  Created by Phatthana Tongon on 5/30/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import "OverlayViewController.h"
#import "User+addition.h"
#import "NSData+Base64.h"
#import "AFJSONRequestOperation.h"
#import "AppDelegate.h"
#import "Stock+addition.h"
#import "OverLayView.h"
#import <FacebookSDK/FacebookSDK.h>
@interface OverlayViewController ()
{
    User *me;
    AppDelegate *appdelegate;
    UIImage *sourceImage;
    NSString *sourceMessage;
    Stock *stock;
    UIImage *sharePhoto;
    OverLayView *overlay;
}
@end

@implementation OverlayViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithImage:(UIImage*)image message:(NSString*)message
{
    self = [super init];
    if (self) {
        sourceImage = image;
        sourceMessage = message;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Share Photo";
    appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [self initOverlayButton];
    
    uploadAlert = [[UIAlertView alloc] initWithTitle:@"Stock Shot"
                                           message:@"Uploading\n\n"
                                          delegate:nil
                                 cancelButtonTitle:nil
                                 otherButtonTitles:nil, nil];
     loadAlert = [[UIAlertView alloc] initWithTitle:@"Stock Shot"
                                            message:@"Loading\n\n"
                                           delegate:nil
                                  cancelButtonTitle:nil
                                  otherButtonTitles:nil, nil];
    
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityView.frame = CGRectMake(139.0f-20.0f, 75.0f, 40, 40);
    [uploadAlert addSubview:activityView];
    [activityView startAnimating];

    UIActivityIndicatorView *activityView2 = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityView2.frame = CGRectMake(139.0f-20.0f, 75.0f, 40, 40);
    [loadAlert addSubview:activityView2];
    [activityView2 startAnimating];
    
    
    [loadAlert show];
    [self getStockDetail];
    
    imageView.image = sourceImage;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = YES;
    UIImage *buttonBG = [Utility imageWithImage:sourceImage scaledToSize:CGSizeMake(100, 100)];
    for (int i=200; i<=201; i++)
    {
        UIButton *button = (UIButton*)[filterView viewWithTag:i];
        [button setBackgroundImage:buttonBG forState:UIControlStateNormal];
    }
}

- (void)initOverlayButton
{
    UIImage *buttonBG = [Utility imageWithImage:sourceImage scaledToSize:CGSizeMake(100, 100)];
    

    for (int i=0; i<10; i++)
    {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((55)*i + 5*i, 0, 55, 55)];
        button.tag = 200+i;
        button.tintColor = [UIColor whiteColor];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        button.titleLabel.shadowColor = [UIColor lightGrayColor];
        button.titleLabel.shadowOffset = CGSizeMake(1, 1);
        [button setTitle:[NSString stringWithFormat:@"%d",i+1] forState:UIControlStateNormal];
        [button setBackgroundImage:buttonBG forState:UIControlStateNormal];
        [button addTarget:self
                   action:@selector(touchOverlay:)
         forControlEvents:UIControlEventTouchUpInside];
        [overlayScrollView addSubview:button];
    }
    overlayScrollView.contentSize = CGSizeMake((60*10)-5, 55);
}

- (void)getStockDetail
{
    NSString *stockSymbol = nil;
    NSArray *messageArray = [sourceMessage componentsSeparatedByString:@"#"];
    if (messageArray.count > 1) {
        NSLog(@"Message: %@",messageArray);
        NSLog(@"Message[0]: %@",[messageArray objectAtIndex:1]);
        NSArray *hashTagArray = [[messageArray objectAtIndex:1] componentsSeparatedByString:@" "];
        if (hashTagArray.count > 0) {
            NSLog(@"HashTag[0]: %@",[hashTagArray objectAtIndex:0]);
            stockSymbol = [hashTagArray objectAtIndex:0];
        }
    }
    
    if (stockSymbol) {
        [Datahandler getStockDetail:[stockSymbol uppercaseString] OnComplete:^(BOOL success, Stock *stockTemp)
         {
             if (success) {
                 stock = stockTemp;
                 NSLog(@"Stock: %@",[stock debugDescription]);

                 [loadAlert dismissWithClickedButtonIndex:0 animated:YES];
             }
             else
             {
                 [Datahandler getStockDetail:@"KK" OnComplete:^(BOOL success, Stock *stockTemp)
                  {
                      stock = stockTemp;
                      [loadAlert dismissWithClickedButtonIndex:0 animated:YES];
                  }];
             }
             
         }];
    }
    else{
        [Datahandler getStockDetail:@"KK" OnComplete:^(BOOL success, Stock *stockTemp)
         {
             stock = stockTemp;
//             NSLog(@"Stock: %@",[stock debugDescription]);
             [loadAlert dismissWithClickedButtonIndex:0 animated:YES];
         }];
        
    }
}

- (IBAction)touchOverlay:(id)sender
{
    UIButton *button = (UIButton*)sender;
    int tag = button.tag-200;
    
    for (UIView *view in  overlayView.subviews){
        [view removeFromSuperview];
    }
    
    if (overlay) {
        overlay = nil;
    }
    overlay = [[OverLayView alloc] initWithOverlayNumber:tag+1 stock:stock datetime:[NSDate date]];
    [overlayView addSubview:overlay.view];

}
- (IBAction)touchBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)touchShare:(id)sender
{
    UIImage *image = [self mergeView:[self imageWithView:imageView] withView:[self imageWithView:overlayView]];
    sharePhoto = image;
    [self UploadPhoto:[Utility compressToFixSize:image] message:sourceMessage];
    
    if (facebookButton.selected) {
        [self shareToFacebook];
    }
}

- (IBAction)touchShareSocial:(id)sender
{
    UIButton *button = (UIButton*)sender;
    button.selected = !button.selected;
}

#pragma mark - UItextField Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - View to Imgae
- (UIImage *) imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (UIImage*)mergeView:(UIImage*)image1 withView:(UIImage*)image2
{
    UIGraphicsBeginImageContext(image1.size);
    [image1 drawAtPoint:CGPointMake(0,0)];
    [image2 drawAtPoint:CGPointMake(0,0)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
#pragma mark - Data

- (void)UploadPhoto:(NSData*)imageData message:(NSString*)message
{
    me = [User me];
    if (me)
    {
        
        NSString *imageDataString = [[imageData base64EncodingWithLineLength:0] stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
        NSLog(@"ImageData[Length]: %d",[imageDataString length]);
        [uploadAlert show];
        NSURL *url = [NSURL URLWithString:@"https://stockshot-kk.appspot.com/api/upload_photo"];
        NSString *params = [[NSString alloc] initWithFormat:@"facebook_id=%@&photo=%@&message=%@&geolocation=31.23,105.34"
                            ,me.facebookID,imageDataString,message];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
        [request setTimeoutInterval:20];
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
                                             {
                                                 [uploadAlert dismissWithClickedButtonIndex:0 animated:YES];
                                                 if ([[JSON objectForKey:@"photo"] length] <= 0){
                                                     [Utility alertWithMessage:@"Upload fail."];
                                                 }
                                                 else{
                                                     [Utility alertWithMessage:@"Upload Done"];
                                                     NSLog(@"UPLOAD RESULT: %@",JSON);
                                                 }
                                                 
                                                 [self dismissViewControllerAnimated:NO completion:^{
                                                     [appdelegate backToLastTabbar];
                                                 }];
                                                 
                                             } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
                                             {
                                                 //                                                 NSLog(@"ERROR CODE: %d",response.statusCode);
                                                 [uploadAlert dismissWithClickedButtonIndex:0 animated:YES];
                                                 [Utility alertWithMessage:[NSString stringWithFormat:@"Upload Photo Error: %d",response.statusCode]];
                                                 [self dismissViewControllerAnimated:YES completion:^{
                                                     [appdelegate backToLastTabbar];
                                                 }];
                                             }];
        
        [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
        [operation start];
    }
    
}

- (void)shareToFacebook
{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   sharePhoto, @"picture",
                                   sourceMessage,@"name",
                                   nil];
    
    FBRequest *uploadRequest = [FBRequest requestWithGraphPath:@"me/photos"
                                                    parameters:params
                                                    HTTPMethod:@"POST"];
    [uploadRequest startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error)
    {
        NSLog(@"Result: %@",result);
    }];
}


// http://210.1.59.181/stockshot/GetDataStockByName.aspx?symbol=kk


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
