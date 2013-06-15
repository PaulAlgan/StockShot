//
//  StockViewController.h
//  StockShot
//
//  Created by Phatthana Tongon on 6/15/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Stock.h"
@interface StockViewController : UIViewController
{
    IBOutlet UILabel *symbolLabel;
    IBOutlet UILabel *lastLabel;
    
    IBOutlet UILabel *percentChangeLabel;
    IBOutlet UILabel *previousCloseLabel;
    IBOutlet UILabel *openLabel;
    IBOutlet UILabel *highLabel;
    IBOutlet UILabel *lowLabel;
    IBOutlet UILabel *volumeLabel;
    IBOutlet UILabel *marketCapLabel;
    IBOutlet UILabel *peRatioLabel;
    IBOutlet UILabel *pbRationLabel;
    IBOutlet UILabel *dividendLabel;
    IBOutlet UILabel *timeLastUpdatLabel;
    IBOutlet UILabel *dateLastUpdatLabel;
}
- (id)initWithStock:(Stock*)stockTemp;
@property (nonatomic,retain) Stock *stock;
@end
