//
//  OverlayViewController.h
//  StockShot
//
//  Created by Phatthana Tongon on 5/30/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OverlayViewController : UIViewController
<UITextFieldDelegate>
{
    IBOutlet UIView *overlayView;
    IBOutlet UIImageView *imageView;
    UIAlertView *loadAlert;

    // DEMO VIEW
    IBOutlet UIView *overlay1;
    IBOutlet UITextField *textField1;
    IBOutlet UIView *overlay2;
    IBOutlet UITextField *textField2;
    IBOutlet UIImageView *resultImageView;
    
    IBOutlet UIButton *facebookButton;
    IBOutlet UIButton *twitterButton;
    IBOutlet UIButton *emailButton;
    
}

- (id)initWithImage:(UIImage*)image message:(NSString*)message;

- (IBAction)touchOverlay:(id)sender;
- (IBAction)touchShare:(id)sender;
- (IBAction)touchBack:(id)sender;
- (IBAction)touchShareSocial:(id)sender;
@end
