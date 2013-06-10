//
//  FeedViewController.h
//  StockShot
//
//  Created by Phatthana Tongon on 4/21/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IIViewDeckController.h"
#import "NewsCell.h"

@interface FeedViewController : UIViewController
{
    UINib *cellLoader;

    IBOutlet UITableView *feedTable;
    IBOutlet UIButton *newsButton;
    IBOutlet UIButton *followingButton;
}

- (IBAction)selectFeedType:(id)sender;
@end
