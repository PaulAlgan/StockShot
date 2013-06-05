//
//  FindInviteFriendViewController.h
//  StockShot
//
//  Created by Phatthana Tongon on 4/23/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MFMessageComposeViewController.h>
@interface FindInviteFriendViewController : UIViewController
<UITabBarControllerDelegate, UITableViewDataSource,ABPeoplePickerNavigationControllerDelegate,
MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate>
{
    IBOutlet UITableView *contentTableView;
}
@end
