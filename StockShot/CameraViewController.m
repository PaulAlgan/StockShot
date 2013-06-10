//
//  CameraViewController.m
//  StockShot
//
//  Created by Phatthana Tongon on 4/21/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.

#import "CameraViewController.h"
#import "EditImageViewController.h"
#import "AppDelegate.h"
#import "UIImage+fixOrientation.h"
@interface CameraViewController ()
{
    AppDelegate *appdelegate;
    UIImagePickerController *imagePicker;
    BOOL cameraReady;
}
@end

@implementation CameraViewController

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
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    backButton.imageView.contentMode = UIViewContentModeCenter;
    self.navigationController.navigationBar.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cameraIsReady:)
                                                 name:AVCaptureSessionDidStartRunningNotification object:nil];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
//    self.navigationController.navigationBar.hidden = YES;
//    [self hideTabBar:self.tabBarController];
//    [self hidesBottomBarWhenPushed];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
//    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    cameraReady = NO;
    if (!imagePicker) {
        imagePicker = [[UIImagePickerController alloc] init];
    }
    
    imagePicker.view.frame = CGRectMake(7, 44, 306, 306);
	imagePicker.delegate = self;
    
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        NSLog(@"asdf");
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    else{
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.showsCameraControls = NO;
        imagePicker.wantsFullScreenLayout = NO;
        [self.view addSubview:imagePicker.view];
    }
	
	// Hide the controls:
//	imagePicker.navigationBarHidden = NO;
	
	// Make camera view full screen:
    
    
}

- (void)cameraIsReady:(NSNotification *)notification
{
    NSLog(@"Ready");
    cameraReady = YES;
}

#pragma mark - IBAction

- (IBAction)touchBack:(id)sender
{
    NSLog(@"TouchBack");

//    [appdelegate backToLastTabbar];
//    [self.view setHidden:YES];
//    [self.view removeFromSuperview];
    
    [self dismissViewControllerAnimated:NO completion:^{
        [appdelegate backToLastTabbar];
    }];
    
}
- (IBAction)takeImage:(id)sender
{
    if (cameraReady) {
        [imagePicker takePicture];
    }
    
}

- (IBAction)chooseFromLibrary:(id)sender
{
//    if (imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera){
//        [self.view addSubview:imagePicker.view];
//    }
    
    UIImagePickerController *libaryPicker = [[UIImagePickerController alloc] init];
//    [libaryPicker.view setFrame:CGRectMake(0, 80, 320, 350)];
    [libaryPicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [libaryPicker setDelegate:self];
    libaryPicker.allowsEditing = YES;

    [self presentViewController:libaryPicker animated:YES completion:^{}];
        
}


#pragma mark - Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"SELECT DONE");
    UIImage *image = nil;
    
    if ([picker sourceType] == UIImagePickerControllerSourceTypePhotoLibrary) {
        NSLog(@"UIImagePickerControllerSourceTypePhotoLibrary");
        image = [Utility scaleImage:[info objectForKey:UIImagePickerControllerOriginalImage] withEditingInfo:info];
//        image = [info objectForKey:UIImagePickerControllerEditedImage];
        [picker dismissViewControllerAnimated:YES completion:^(void)
        {
            UIImage  *resultImage = nil;
            NSLog(@"ImageSize: %@",NSStringFromCGSize(image.size));
            if (image.size.width != image.size.height){
                if (image.size.width > image.size.height){
                    resultImage = [Utility imageByCropping:image toRect:CGRectMake(0, (image.size.width-image.size.height)/2.0,
                                                                                   image.size.width, image.size.width)];
                    
                }
                else{
                    resultImage = [Utility imageByCropping:image toRect:CGRectMake((image.size.height-image.size.width)/2.0, 0,
                                                                                   image.size.height, image.size.height)];
                }
            }
            else
            {
                resultImage = image;
            }
            NSLog(@"ImageResultSize: %@",NSStringFromCGSize(resultImage.size));
            resultImage = [self imageWithImage:resultImage scaledToSize:CGSizeMake(720, 720)];
            NSLog(@"ImageResultSize: %@",NSStringFromCGSize(resultImage.size));
            EditImageViewController *editImageView = [[EditImageViewController alloc] initWithImage:resultImage];
            [self.navigationController pushViewController:editImageView animated:NO];
        }];
    }
    else if ([picker sourceType] == UIImagePickerControllerSourceTypeCamera)
    {
        NSLog(@"UIImagePickerControllerSourceTypeCamera");
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        UIImage *resultImage = nil;
        CGRect cropRect = CGRectMake(0, 0, image.size.width, image.size.width);
        NSLog(@"WIDTH: %lf",cropRect.size.width);
        CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], cropRect);
        resultImage = [UIImage imageWithCGImage:imageRef scale:image.scale orientation:image.imageOrientation];
        CGImageRelease(imageRef);
//        image = resultImage;
        resultImage = [self imageWithImage:[resultImage fixOrientation] scaledToSize:CGSizeMake(720, 720)];
//        NSLog(@"IMG W: %lf",resultImage.size.width);
        
        EditImageViewController *editImageView = [[EditImageViewController alloc]
                                                  initWithImage:resultImage];
        [self.navigationController pushViewController:editImageView animated:YES];
    }
    
//    [NSThread detachNewThreadSelector:@selector(useImage:) toTarget:self withObject:image];
}

- (void)useImage:(UIImage*)image
{
    UIImage *resultImage = [self imageWithImage:[image fixOrientation] scaledToSize:CGSizeMake(100, 100)];
//    NSLog(@"IMG W: %lf",image.size.width);

    
    EditImageViewController *editImageView = [[EditImageViewController alloc]
                                              initWithImage:resultImage];
    [self.navigationController pushViewController:editImageView animated:YES];

}


- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


//- (void)hideTabBar:(UITabBarController *) tabbarcontroller
//{
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration:0.0];
//    
//    for(UIView *view in tabbarcontroller.view.subviews)
//    {
//        if([view isKindOfClass:[UITabBar class]])
//        {
//            [view setFrame:CGRectMake(view.frame.origin.x, 480, view.frame.size.width, view.frame.size.height)];
//        }
//        else
//        {
//            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 480)];
//        }
//    }
//    
//    [UIView commitAnimations];
//}
//
//- (void)showTabBar:(UITabBarController *) tabbarcontroller
//{
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration:0.0];
//    for(UIView *view in tabbarcontroller.view.subviews)
//    {
//        NSLog(@"%@", view);
//        
//        if([view isKindOfClass:[UITabBar class]])
//        {
//            [view setFrame:CGRectMake(view.frame.origin.x, 431, view.frame.size.width, view.frame.size.height)];
//            
//        }
//        else
//        {
//            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 431)];
//        }
//    }
//    
//    [UIView commitAnimations];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
