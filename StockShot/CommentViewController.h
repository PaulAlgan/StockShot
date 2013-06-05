//
//  CommentViewController.h
//  StockShot
//
//  Created by Phatthana Tongon on 6/5/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentViewController : UIViewController
<UIScrollViewDelegate>
{
    UINib *cellLoader;
    IBOutlet UITableView *contentTableView;
    IBOutlet UIView *textInputView;
    IBOutlet UITextView *chatTextView;
    IBOutlet UIButton *sendButton;

}
- (id)initWithPhotoDict:(NSDictionary*)dict;
- (IBAction)sendMessage:(id)sender;
@property (nonatomic,retain) NSDictionary *photoDict;
@end
