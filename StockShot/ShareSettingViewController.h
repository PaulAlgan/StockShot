//
//  ShareSettingViewController.h
//  StockShot
//
//  Created by MacbookPro on 6/10/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareSettingViewController : UIViewController
{
    __weak IBOutlet UILabel *lblFacebookName;
    
    __weak IBOutlet UILabel *lblEmailName;
}

- (IBAction)btFacebookSetting:(id)sender;
- (IBAction)btEmailSetting:(id)sender;

@end
