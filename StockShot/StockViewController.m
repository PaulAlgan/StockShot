//
//  StockViewController.m
//  StockShot
//
//  Created by Phatthana Tongon on 6/15/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import "StockViewController.h"
#import "Stock+addition.h"
@interface StockViewController ()
{

}
@end

@implementation StockViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithStock:(Stock*)stockTemp
{
    self = [super init];
    if (self) {
        self.stock = stockTemp;
        self.title = [NSString stringWithFormat:@"#%@",self.stock.symbol];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [Utility backButton:self];
    symbolLabel.text = self.stock.symbol;
    
    
    [Datahandler getStockDetail:[self.stock.symbol uppercaseString] OnComplete:^(BOOL success, Stock *stockMatch) {
        if (success) {
            self.stock = stockMatch;
            lastLabel.text = [NSString stringWithFormat:@"%.2f",[self.stock.last floatValue]];
            percentChangeLabel.text = self.stock.persentChange;
            previousCloseLabel.text = self.stock.previousClose;
            openLabel.text = self.stock.open;
            highLabel.text = self.stock.high;
            lowLabel.text = self.stock.low;
            volumeLabel.text = self.stock.volume;
            marketCapLabel.text = self.stock.marketCap;
            peRatioLabel.text = self.stock.peRatio;
            pbRationLabel.text = self.stock.pbRatio;
            dividendLabel.text = self.stock.dividendYield;

        }
    }];

    
    //    timeLastUpdatLabel.text = self.stock.symbol;
//    dateLastUpdatLabel.text = self.stock.symbol;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
