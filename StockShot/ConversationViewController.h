//
//  ConversationViewController.h
//  StockShot
//
//  Created by Phatthana Tongon on 5/24/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConversationViewController : UIViewController
<NSFetchedResultsControllerDelegate,UITextViewDelegate, UIScrollViewDelegate>
{
    UINib *cellLoader;
    IBOutlet UITableView *contentTableView;
    IBOutlet UIView *textInputView;
    IBOutlet UITextView *chatTextView;
    IBOutlet UIButton *sendButton;
}
@property (nonatomic,strong) NSString *targetID;
- (IBAction)sendMessage:(id)sender;
@end
