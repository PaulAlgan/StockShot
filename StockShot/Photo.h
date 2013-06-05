//
//  Photo.h
//  StockShot
//
//  Created by Phatthana Tongon on 5/28/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface Photo : NSManagedObject

@property (nonatomic, retain) NSString * key;
@property (nonatomic, retain) User *belongto;

@end
