//
//  ProfileViewController.h
//  StockShot
//
//  Created by Phatthana Tongon on 5/21/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
//#import "AQGridView.h"
@class User;
@interface ProfileViewController : UIViewController
{
    IBOutlet UIImageView *profileImageView;
    IBOutlet UILabel *userNameLabel;
    IBOutlet UILabel *statusLabel;
    IBOutlet UIButton *photoButton;
    IBOutlet UIButton *followerButton;
    IBOutlet UIButton *followingButton;
    IBOutlet UIButton *editProfileButton;
    IBOutlet UIButton *chatButton;
    IBOutlet UIButton *followButton;
    IBOutlet UIView *contentView;
}
- (id)initWithUser:(User*)user;
- (IBAction)touchFollower:(id)sender;
- (IBAction)touchFollowing:(id)sender;
- (IBAction)touchChat:(id)sender;
- (IBAction)touchEditProfile:(id)sender;

@property (nonatomic,retain) User *user;
@end
