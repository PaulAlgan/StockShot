//
//  HomeViewController.h
//  StockShot
//
//  Created by Phatthana Tongon on 4/21/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IIViewDeckController.h"
#import "TTTAttributedLabel.h"
#import "ImageViewCell.h"
@interface HomeViewController : UIViewController
<TTTAttributedLabelDelegate,ImageViewCellDelegate>
{
    IBOutlet UITableView *contentTableView;
    UINib *cellLoader;

}
@end
