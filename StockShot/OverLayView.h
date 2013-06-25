//
//  OverLayView.h
//  StockShot
//
//  Created by Phatthana Tongon on 6/25/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Stock+addition.h"
@interface OverLayView : UIViewController
{
    IBOutlet UILabel *symbolLabel;
    IBOutlet UILabel *pChangeLabel;
    IBOutlet UILabel *dateLable;
    IBOutlet UILabel *timeLable;
    IBOutlet UILabel *lastLabel;
    IBOutlet UILabel *lowLabel;
    IBOutlet UILabel *highLabel;
    IBOutlet UILabel *openLabel;
    IBOutlet UILabel *volumeLabel;
    IBOutlet UILabel *pbRatioLabel;
    IBOutlet UILabel *peRatioLabel;
    IBOutlet UILabel *marketCapLabel;
    IBOutlet UILabel *dividendYieldLabel;
}
@property (nonatomic, retain) Stock *stock;
@property (nonatomic, retain) NSDate *datetime;
- (id)initWithOverlayNumber:(int)number stock:(Stock*)stock datetime:(NSDate*)dateTime;
@end
