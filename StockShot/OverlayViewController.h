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
    UIAlertView *uploadAlert;
    UIAlertView *loadAlert;
    IBOutlet UIView *filterView;
    IBOutlet UIScrollView *overlayScrollView;
    
    // DEMO VIEW
    IBOutlet UIView *overlay1;
    IBOutlet UILabel *symbolLabel1;
    IBOutlet UITextField *textField1;
    IBOutlet UILabel *pChangeLabel1;
    IBOutlet UILabel *dateLable1;
    IBOutlet UILabel *timeLable1;
    IBOutlet UILabel *lastLabel1;
    IBOutlet UILabel *lowLabel1;
    IBOutlet UILabel *highLabel1;
    IBOutlet UILabel *openLabel1;
    
    IBOutlet UIView *overlay2;
    IBOutlet UILabel *symbolLabel2;
    IBOutlet UITextField *textField2;
    IBOutlet UILabel *pChangeLabel2;
    IBOutlet UILabel *dateLable2;
    IBOutlet UILabel *timeLable2;
    IBOutlet UILabel *lastLabel2;
    
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
