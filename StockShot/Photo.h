//
//  Photo.h
//  StockShot
//
//  Created by Phatthana Tongon on 6/18/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface Photo : NSManagedObject

@property (nonatomic, retain) NSString * key;
@property (nonatomic, retain) NSString * createDate;
@property (nonatomic, retain) NSString * likeCount;
@property (nonatomic, retain) NSString * message;
@property (nonatomic, retain) User *belongto;

@end
