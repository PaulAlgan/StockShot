//
//  EditProfileViewController.m
//  StockShot
//
//  Created by Phatthana Tongon on 6/2/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import "EditProfileViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface EditProfileViewController ()

@end

@implementation EditProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithUser:(User*)user
{
    self = [super init];
    if (self) {
        self.user = user;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [profileImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture",self.user.facebookID]]
                     placeholderImage:[UIImage imageNamed:@"profileImage.png"]];
    
    nameLabel.text = [NSString stringWithFormat:@"%@ %@",self.user.firstName,self.user.lastName];
    userNameLabel.text = self.user.username;
    statusLabel.text = @"Status";
    emailLabel.text = self.user.email;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
