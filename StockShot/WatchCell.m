//
//  WatchCell.m
//  StockShot
//
//  Created by Phatthana Tongon on 6/19/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import "WatchCell.h"

@implementation WatchCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setStock:(Stock *)stock
{
    _stock = stock;
    NSLog(@"SetStock: %@",stock.debugDescription);
    symbolLabel.text = [NSString stringWithFormat:@"#%@",_stock.symbol];
    lastLabel.text = _stock.last;
    percentChangeLabel.text = [NSString stringWithFormat:@"%.2lf%%",[_stock.persentChange doubleValue]];
    
    
    UIColor *greanColor = [UIColor colorWithRed:76.0/255.0 green:181.0/255.0 blue:74.0/255.0 alpha:1];
    UIColor *redColor = [UIColor colorWithRed:240.0/255.0 green:69.0/255.0 blue:38.0/255.0 alpha:1];
    if ([_stock.persentChange floatValue] >= 0){
        percentChangeLabel.textColor = greanColor;
    }
    else{
        percentChangeLabel.textColor = redColor;
    }
}

@end
