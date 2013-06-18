//
//  Stock.h
//  StockShot
//
//  Created by Phatthana Tongon on 6/19/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface Stock : NSManagedObject

@property (nonatomic, retain) NSString * dividendYield;
@property (nonatomic, retain) NSString * high;
@property (nonatomic, retain) NSString * last;
@property (nonatomic, retain) NSString * low;
@property (nonatomic, retain) NSString * marketCap;
@property (nonatomic, retain) NSString * open;
@property (nonatomic, retain) NSString * pbRatio;
@property (nonatomic, retain) NSString * peRatio;
@property (nonatomic, retain) NSString * persentChange;
@property (nonatomic, retain) NSString * previousClose;
@property (nonatomic, retain) NSString * symbol;
@property (nonatomic, retain) NSString * volume;
@property (nonatomic, retain) User *watchBy;

@end
