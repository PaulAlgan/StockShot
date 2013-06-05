//
//  ChatViewController.h
//  StockShot
//
//  Created by Phatthana Tongon on 4/21/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatRoomCell.h"
#import "User.h"
#import "IIViewDeckController.h"

@interface ChatViewController : UIViewController <NSFetchedResultsControllerDelegate>
{
    UINib *cellLoader;
    IBOutlet UITableView *contentTableView;
}
- (void)chatToUser:(User*)targetUser;
@end
