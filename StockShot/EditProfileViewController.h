//
//  EditProfileViewController.h
//  StockShot
//
//  Created by Phatthana Tongon on 6/2/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User+addition.h"
@interface EditProfileViewController : UIViewController
{
    IBOutlet UIImageView *profileImageView;
    IBOutlet UITextField *nameLabel;
    IBOutlet UITextField *userNameLabel;
    IBOutlet UITextField *statusLabel;
    IBOutlet UITextField *emailLabel;
    
    IBOutlet UIScrollView *mainScrollView;
    IBOutlet UIView *contentView;
}
@property (nonatomic,retain) User *user;
- (IBAction)touchUpdateDone:(id)sender;

- (id)initWithUser:(User*)user;

@end
