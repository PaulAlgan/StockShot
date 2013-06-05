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
    IBOutlet UILabel *nameLabel;
    IBOutlet UILabel *userNameLabel;
    IBOutlet UILabel *statusLabel;
    IBOutlet UILabel *emailLabel;
}
@property (nonatomic,retain) User *user;
- (id)initWithUser:(User*)user;

@end
