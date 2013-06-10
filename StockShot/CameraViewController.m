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
    UIImage *image = nil;
    
    if ([picker sourceType] == UIImagePickerControllerSourceTypePhotoLibrary) {
        NSLog(@"UIImagePickerControllerSourceTypePhotoLibrary");
        image = [Utility scaleImage:[info objectForKey:UIImagePickerControllerOriginalImage] withEditingInfo:info];
        [picker dismissViewControllerAnimated:YES completion:^(void)
        {
            UIImage  *resultImage = nil;
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
            resultImage = [self imageWithImage:resultImage scaledToSize:CGSizeMake(720, 720)];
            EditImageViewController *editImageView = [[EditImageViewController alloc] initWithImage:resultImage];
            [self.navigationController pushViewController:editImageView animated:NO];
            editImageView = nil;
        }];
    }
    else if ([picker sourceType] == UIImagePickerControllerSourceTypeCamera)
    {
        NSLog(@"UIImagePickerControllerSourceTypeCamera");
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        UIImage *resultImage = nil;
        CGRect cropRect = CGRectMake(0, 0, image.size.width, image.size.width);
        CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], cropRect);
        resultImage = [UIImage imageWithCGImage:imageRef scale:image.scale orientation:image.imageOrientation];
        CGImageRelease(imageRef);
        resultImage = [self imageWithImage:[resultImage fixOrientation] scaledToSize:CGSizeMake(720, 720)];
        
        EditImageViewController *editImageView = [[EditImageViewController alloc]
                                                  initWithImage:resultImage];
        [self.navigationController pushViewController:editImageView animated:YES];
        editImageView = nil;
    }    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
