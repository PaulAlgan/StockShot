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
@interface SearchViewController : UITableViewController
<UISearchDisplayDelegate, UISearchBarDelegate,UITextFieldDelegate,GMGridViewActionDelegate,GMGridViewDataSource>
{
    UINib *cellLoader;
}
@end
