//
//  StockViewController.m
//  StockShot
//
//  Created by Phatthana Tongon on 6/15/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import "StockViewController.h"
#import "Stock+addition.h"
#import "User+addition.h"
#import "AppDelegate.h"
@interface StockViewController ()
{
    User *me;
    AppDelegate *appdelegate;
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
    
    appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    me = [User me];
    
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

    if (me.facebookID) {
        if ([me.watch containsObject:self.stock]) {
            [self setWatch:YES];
        }
    }

}

- (void)setWatch:(BOOL)watched
{
    if (watched) {
        addWatchListButton.selected = YES;
        addWatchListButton.backgroundColor = [UIColor colorWithRed:33.0/255.0 green:107.0/255.0 blue:166.0/255.0 alpha:1];
    }
    else
    {
        addWatchListButton.selected = NO;
        addWatchListButton.backgroundColor = [UIColor colorWithRed:63.0/255.0 green:80.0/255.0 blue:88.0/255.0 alpha:1];
    }
}

#pragma mark - IBAction
- (IBAction)touchAddWatchList:(id)sender
{
    me = [User me];
    if (me.facebookID)
    {
        if (addWatchListButton.selected)
        {
            [Datahandler removeWatchListWithSymbol:self.stock.symbol
                                            userID:me.facebookID
                                        OnComplete:^(BOOL success, NSString *result) {
                                            if (success) {
                                                if ([result isEqualToString:@"success"])
                                                {
                                                    [Utility alertWithMessage:@"Remove from Watch List Done."];
                                                    [self setWatch:NO];
                                                }
                                                else
                                                {
                                                    [Utility alertWithMessage:@"Remove from Watch List Fail."];
                                                }
                                            }
                                            [Datahandler requestUserInfo:me.facebookID OnComplete:^(BOOL success, User *user) { }];
                                        }];

        }
        else
        {
            [Datahandler addWatchListWithSymbol:self.stock.symbol
                                         userID:me.facebookID
                                     OnComplete:^(BOOL success, NSString *result) {
                                         if (success) {
                                             if ([result isEqualToString:@"success"])
                                             {
                                                 [Utility alertWithMessage:@"Add to Watch List Done."];
                                                 [self setWatch:YES];
                                             }
                                             else
                                             {
                                                 [Utility alertWithMessage:@"Add to Watch List Fail."];
                                             }
                                         }
                                         [Datahandler requestUserInfo:me.facebookID OnComplete:^(BOOL success, User *user) { }];
                                     }];

        }
        
    }
    else
    {
        [Utility alertWithMessage:@"Please Login"];
    }

}

- (IBAction)touchCamera:(id)sender
{
    [appdelegate setCurrentSymbol:self.stock.symbol];
    [appdelegate.tabBarController setSelectedIndex:2];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
