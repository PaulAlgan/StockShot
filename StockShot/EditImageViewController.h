//
//  EditImageViewController.h
//  ImagePicker
//
//  Created by Phatthana Tongon on 4/8/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import 
@interface EditImageViewController : UIViewController
<UITextFieldDelegate>
{
    IBOutlet UIImageView *rawImageView;
    IBOutlet UIImageView *filterImageView;
    IBOutlet UIButton *doneButton;
    IBOutlet UIButton *cancelButton;
    IBOutlet UITextField *captionTextField;
    IBOutlet UIView *filterView;
    UIAlertView *loadAlert;
}
- (IBAction)touchDone:(id)sender;
- (IBAction)touchCancel:(id)sender;
- (id)initWithImage:(UIImage*)image;
@property (nonatomic,retain) UIImage *rawImage;

- (IBAction)selectFilter:(id)sender;
@end
