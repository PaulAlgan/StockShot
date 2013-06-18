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
+ (void)getRandomPhotosOnComplete:(void (^)(BOOL success, NSArray *photos))block;

+ (void)addWatchListWithSymbol:(NSString*)symbol
                        userID:(NSString*)userID OnComplete:(void (^)(BOOL success, NSString *result))block;
+ (void)removeWatchListWithSymbol:(NSString*)symbol
                           userID:(NSString*)userID OnComplete:(void (^)(BOOL success, NSString *result))block;
@end
