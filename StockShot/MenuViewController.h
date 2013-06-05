//
//  MenuViewController.h
//  StockShot
//
//  Created by Phatthana Tongon on 4/21/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IIViewDeckController.h"

@interface MenuViewController : UIViewController
<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView *menuTableView;
    IBOutlet UILabel *userName;
    IBOutlet UIImageView *profileImageView;
}
@end
