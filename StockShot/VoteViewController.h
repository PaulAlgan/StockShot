//
//  VoteViewController.h
//  StockShot
//
//  Created by Phatthana Tongon on 4/23/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VoteViewController : UIViewController
<UITableViewDataSource, UITableViewDelegate>
{
    
    __weak IBOutlet UITableView *tableVote;
}

@end
