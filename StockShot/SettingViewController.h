//
//  SettingViewController.h
//  StockShot
//
//  Created by Phatthana Tongon on 4/23/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UIViewController
{
    
    __weak IBOutlet UIButton *btPhotoPrivate;
}

- (IBAction)btLogOutAction:(id)sender;
- (IBAction)btShareSettingAction:(id)sender;
- (IBAction)btPushNotiAction:(id)sender;
- (IBAction)btClearHistoryAction:(id)sender;
- (IBAction)btPhotoPrivateAction:(id)sender;

@end
