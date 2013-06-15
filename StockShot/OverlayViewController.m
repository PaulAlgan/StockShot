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
@interface OverlayViewController ()
{
    User *me;
    AppDelegate *appdelegate;
    UIImage *sourceImage;
    NSString *sourceMessage;
    Stock *stock;
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
        
//        [self getStockDetail:@"kk"];
        [Datahandler getStockDetail:@"kk" OnComplete:^(BOOL success, Stock *stockTemp)
        {
            stock = stockTemp;
        }];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Share Photo";
    appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    loadAlert = [[UIAlertView alloc] initWithTitle:@"Stock Shot"
                                           message:@"Uploading\n\n"
                                          delegate:nil
                                 cancelButtonTitle:nil
                                 otherButtonTitles:nil, nil];
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityView.frame = CGRectMake(139.0f-20.0f, 75.0f, 40, 40);
    [loadAlert addSubview:activityView];
    [activityView startAnimating];

    
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
- (IBAction)touchOverlay:(id)sender
{
    UIButton *button = (UIButton*)sender;
    int tag = button.tag-200;
    
    for (UIView *view in  overlayView.subviews){
        [view removeFromSuperview];
    }
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy MMM,dd"];
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"HH:mm:ss"];

    
    if (tag == 0)
    {
        [overlayView addSubview:overlay1];
        
        if (stock) {
            pChangeLabel1.text = [NSString stringWithFormat:@"%.2f%%",[stock.persentChange floatValue]];
            lastLabel1.text = [NSString stringWithFormat:@"%.2f",[stock.last floatValue]];
            openLabel1.text = [NSString stringWithFormat:@"%.2f",[stock.open floatValue]];
            lowLabel1.text = [NSString stringWithFormat:@"%.2f",[stock.low floatValue]];
            highLabel1.text = [NSString stringWithFormat:@"%.2f",[stock.high floatValue]];
        }
        dateLable1.text = [dateFormatter stringFromDate:date];
        timeLable1.text = [timeFormatter stringFromDate:date];
        
    }
    else if (tag == 1)
    {
        [overlayView addSubview:overlay2];
        
        if (stock) {
            pChangeLabel2.text = [NSString stringWithFormat:@"%.2f%%",[stock.persentChange floatValue]];
            lastLabel2.text = [NSString stringWithFormat:@"%.2f",[stock.last floatValue]];
        }
        dateLable2.text = [dateFormatter stringFromDate:date];
        timeLable2.text = [timeFormatter stringFromDate:date];
    }  
}
- (IBAction)touchBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)touchShare:(id)sender
{
    UIImage *image = [self mergeView:[self imageWithView:imageView] withView:[self imageWithView:overlayView]];
    [self UploadPhoto:[Utility compressToFixSize:image] message:sourceMessage];
}

- (IBAction)touchShareSocial:(id)sender
{
    
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
        [loadAlert show];
        NSURL *url = [NSURL URLWithString:@"https://stockshot-kk.appspot.com/api/upload_photo"];
        NSString *params = [[NSString alloc] initWithFormat:@"facebook_id=%@&photo=%@&message=%@&geolocation=31.23,105.34"
                            ,me.facebookID,imageDataString,message];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
        [request setTimeoutInterval:20];
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
                                             {
                                                 [loadAlert dismissWithClickedButtonIndex:0 animated:YES];
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
                                                 [loadAlert dismissWithClickedButtonIndex:0 animated:YES];
                                                 [Utility alertWithMessage:[NSString stringWithFormat:@"Upload Photo Error: %d",response.statusCode]];
                                                 [self dismissViewControllerAnimated:YES completion:^{
                                                     [appdelegate backToLastTabbar];
                                                 }];
                                             }];
        
        [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
        [operation start];
    }
    
}


// http://210.1.59.181/stockshot/GetDataStockByName.aspx?symbol=kk


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
