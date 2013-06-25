//
//  OverLayView.m
//  StockShot
//
//  Created by Phatthana Tongon on 6/25/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import "OverLayView.h"

@interface OverLayView ()

@end

@implementation OverLayView

- (id)initWithOverlayNumber:(int)number stock:(Stock*)stock datetime:(NSDate*)dateTime
{
    NSString *xibName = [NSString stringWithFormat:@"OverlayView%d",number];
    self = [super initWithNibName:xibName bundle:nil];
    if (self) {
        _stock = stock;
        _datetime = dateTime;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.stock)
    {
        symbolLabel.text = self.stock.symbol;
        pChangeLabel.text = [NSString stringWithFormat:@"%.2f%%",[self.stock.persentChange floatValue]];
        lastLabel.text = [NSString stringWithFormat:@"%.2f",[self.stock.last floatValue]];
        openLabel.text = [NSString stringWithFormat:@"%.2f",[self.stock.open floatValue]];
        lowLabel.text = [NSString stringWithFormat:@"%.2f",[self.stock.low floatValue]];
        highLabel.text = [NSString stringWithFormat:@"%.2f",[self.stock.high floatValue]];
        volumeLabel.text = [NSString stringWithFormat:@"%.2f",[self.stock.volume floatValue]];
        pbRatioLabel.text = [NSString stringWithFormat:@"%.2f",[self.stock.pbRatio floatValue]];
        peRatioLabel.text = [NSString stringWithFormat:@"%.2f",[self.stock.peRatio floatValue]];
        marketCapLabel.text = [NSString stringWithFormat:@"%.2f",[self.stock.marketCap floatValue]/1000000.0];
        dividendYieldLabel.text = [NSString stringWithFormat:@"%.2f%%",[self.stock.dividendYield floatValue]];
    }
    
    NSDate *date = self.datetime;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy MMM,dd"];
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"HH:mm:ss"];
    dateLable.text = [dateFormatter stringFromDate:date];
    timeLable.text = [timeFormatter stringFromDate:date];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
