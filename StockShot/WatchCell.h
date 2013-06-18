//
//  WatchCell.h
//  StockShot
//
//  Created by Phatthana Tongon on 6/19/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WatchCell : UITableViewCell
{
    IBOutlet UILabel *symbolLabel;
    IBOutlet UILabel *lastLabel;
    IBOutlet UILabel *percentChangeLabel;
}
@property (nonatomic,retain) Stock *stock;
- (void)setStock:(Stock *)stock;
@end
