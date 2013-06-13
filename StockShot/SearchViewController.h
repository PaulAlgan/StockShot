//
//  SearchViewController.h
//  StockShot
//
//  Created by Phatthana Tongon on 5/4/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageViewCell.h"
#import "GMGridView.h"
@interface SearchViewController : UIViewController
<UITextFieldDelegate,GMGridViewActionDelegate,GMGridViewDataSource>
{
    UINib *cellLoader;
    IBOutlet UIView *searchView;
    IBOutlet UITextField *searchTextField;
    IBOutlet UIButton *cancelButton;
    IBOutlet UITableView *resultTableView;
    IBOutlet UIButton *userTypeButton;
    IBOutlet UIButton *hashTagTypeButton;
    
}
- (IBAction)touchCancel:(id)sender;
- (IBAction)touchContentType:(id)sender;
@end
