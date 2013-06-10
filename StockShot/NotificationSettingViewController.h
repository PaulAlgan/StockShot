//
//  NotificationSettingViewController.h
//  StockShot
//
//  Created by MacbookPro on 6/10/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationSettingViewController : UIViewController
<UITableViewDataSource, UITableViewDelegate>
{
    
    __weak IBOutlet UITableView *tableNoti;

    IBOutletCollection(UITableViewCell) NSArray *cellLikeCollection;
    
    
    IBOutletCollection(UITableViewCell) NSArray *cellCommentCollection;

    IBOutletCollection(UITableViewCell) NSArray *cellContactCollection;
}


- (IBAction)btLikeAction:(id)sender;
- (IBAction)btCommentAction:(id)sender;
- (IBAction)btContactAction:(id)sender;


@end
