//
//  Stock+addition.h
//  StockShot
//
//  Created by Phatthana Tongon on 6/14/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Stock.h"

@interface Stock(addition)
{
    
}

+ (Stock*)stockWithName:(NSString*)name;
+ (Stock*)getStockWithName:(NSString*)name;
@end
