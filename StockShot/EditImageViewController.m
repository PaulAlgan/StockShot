//
//  EditImageViewController.m
//  ImagePicker
//
//  Created by Phatthana Tongon on 4/8/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import "EditImageViewController.h"
#import "UIImage+fixOrientation.h"
#import "GPUImage.h"
#import "AppDelegate.h"
#import "AFJSONRequestOperation.h"
#import "User+addition.h"
#import "NSData+Base64.h"
#import "OverlayViewController.h"
@interface EditImageViewController ()
{
    AppDelegate *appdelegate;
    
    GPUImageOutput<GPUImageInput> *filter;
    GPUImagePicture *stillImageSource;
    GPUImagePicture *previewImageSource;
    User *me;
    BOOL keyboardShow;
}
@end


@implementation EditImageViewController
@synthesize rawImage=_rawImage;

- (id)initWithImage:(UIImage*)image
{
    self = [super init];
    if (self) {
        // Custom initialization
        _rawImage = image;
    }
    return self;
}


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
    self.title = @"Filter";
    appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if (_rawImage) {
        rawImageView.image = _rawImage;
    }
    
    stillImageSource = [[GPUImagePicture alloc] initWithImage:_rawImage];
    
    previewImageSource = [[GPUImagePicture alloc] initWithImage:[Utility imageWithImage:_rawImage scaledToSize:CGSizeMake(100, 100)]];

    loadAlert = [[UIAlertView alloc] initWithTitle:@"Stock Shot"
                                           message:@"Uploading\n\n"
                                          delegate:nil
                                 cancelButtonTitle:nil
                                 otherButtonTitles:nil, nil];
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityView.frame = CGRectMake(139.0f-20.0f, 75.0f, 40, 40);
    [loadAlert addSubview:activityView];
    [activityView startAnimating];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"TestNotification"
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = YES;    

    for (int i=200; i<=203; i++)
    {
        UIButton *button = (UIButton*)[filterView viewWithTag:i];
        switch (i)
        {
            case 200:
                filter = [[GPUImageMissEtikateFilter alloc] init];
                [button setTitle:@"Etikate" forState:UIControlStateNormal];
                break;
                
            case 201:
                filter = [[GPUImageSoftEleganceFilter alloc] init];
                [button setTitle:@"Elegance" forState:UIControlStateNormal];
                break;
                
            case 202:
                filter = [[GPUImageVignetteFilter alloc] init];
                [(GPUImageVignetteFilter*)filter setVignetteEnd:0.8];
                [button setTitle:@"Vignette" forState:UIControlStateNormal];
                break;
                
            case 203:
                filter = [[GPUImageGrayscaleFilter alloc] init];
                [button setTitle:@"Inkwell" forState:UIControlStateNormal];
                break;
                
            default:
                break;
        }
        
        [previewImageSource addTarget:filter];
        [previewImageSource processImage];
        [button setBackgroundImage:[filter imageFromCurrentlyProcessedOutput] forState:UIControlStateNormal];
        [previewImageSource removeAllTargets];
        [filter cleanupOutputImage];

    }
}

- (IBAction)selectFilter:(id)sender
{
    UIButton *button = (UIButton*)sender;
    int tag = button.tag-200;
        
    switch (tag)
    {
        case 0:
            filter = [[GPUImageMissEtikateFilter alloc] init];
            break;
        
        case 1:
            filter = [[GPUImageSoftEleganceFilter alloc] init];
            break;
            
        case 2:
            filter = [[GPUImageVignetteFilter alloc] init];
            [(GPUImageVignetteFilter*)filter setVignetteEnd:0.8];
            break;
            
        case 3:
            filter = [[GPUImageGrayscaleFilter alloc] init];
            break;
            
        default:
            break;
    }
    
    [stillImageSource addTarget:filter];
    [stillImageSource processImage];
    filterImageView.image = [filter imageFromCurrentlyProcessedOutput];

    [stillImageSource removeAllTargets];
    [filter cleanupOutputImage];
}

- (IBAction)touchDone:(id)sender
{
    UIImage *resultImage = nil;
    if (filterImageView.image == nil) {
        resultImage = rawImageView.image;
    }
    else{
        NSLog(@"Image NOT NIL");
        resultImage = filterImageView.image;
    }
    OverlayViewController *overlayViewController = [[OverlayViewController alloc] initWithImage:resultImage
                                                                                        message:captionTextField.text];
    [self.navigationController pushViewController:overlayViewController animated:YES];
//    [self UploadPhoto:[Utility compressToFixSize:filterImageView.image]
//              message:@"message"];
}

- (IBAction)touchCancel:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UItextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
    
    if (keyboardShow) {
        viewFrame.origin.y = viewFrame.origin.y - keyboardFrameEndRelative.size.height;
    }
    else{
        viewFrame.origin.y = 0;
    }
    self.view.frame = viewFrame;
    [UIView commitAnimations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
