//
//  Datahandler.h
//  StockShot
//
//  Created by Phatthana Tongon on 6/15/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Stock.h"
@interface Datahandler : NSObject
{
    
}
+ (void)getAllStockOnComplete:(void (^)(bool success, NSArray *allstock))block;
+ (void)getStockDetail:(NSString*)stockName OnComplete:(void (^)(BOOL success, Stock *stock))block;
@end
