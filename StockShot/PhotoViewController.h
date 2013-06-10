//
//  PhotoViewController.h
//  StockShot
//
//  Created by Phatthana Tongon on 6/11/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentViewController.h"
#import "ImageViewCell.h"
@interface PhotoViewController : UIViewController
<ImageViewCellDelegate>
{
    UINib *cellLoader;

    IBOutlet UITableView *contentTableView;
}
@property (nonatomic, retain) NSDictionary *photo;
@end
