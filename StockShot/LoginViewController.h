//
//  LoginViewController.h
//  StockShot
//
//  Created by Phatthana Tongon on 4/26/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface LoginViewController : UIViewController
{
    IBOutlet UIButton *connectFacebookButton;
    IBOutlet UIImageView *imageView;
}
- (IBAction)touchConnectFacebook:(id)sender;

@property BOOL haveUser;
@end
