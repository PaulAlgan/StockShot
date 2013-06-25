//
//  CameraViewController.h
//  StockShot
//
//  Created by Phatthana Tongon on 4/21/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface CameraViewController : UIViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    IBOutlet UIButton *shutterButton;
    IBOutlet UIButton *libratyButton;
    IBOutlet UIButton *backButton;

    IBOutlet UIView *cameraView;
    IBOutlet UIView *gridView;
    IBOutlet UIButton *flashButton;
}
- (IBAction)touchBack:(id)sender;
- (IBAction)takeImage:(id)sender;
- (IBAction)chooseFromLibrary:(id)sender;

- (IBAction)swapCamera:(id)sender;
- (IBAction)changeFlashType:(id)sender;
- (IBAction)swapGridView:(id)sender;
@end