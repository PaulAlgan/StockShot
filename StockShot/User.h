//
//  User.h
//  StockShot
//
//  Created by Phatthana Tongon on 6/24/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Photo, Stock;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * deviceToken;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * facebookID;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSNumber * followerCount;
@property (nonatomic, retain) NSNumber * followingCount;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * locale;
@property (nonatomic, retain) NSNumber * me;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * notiComment;
@property (nonatomic, retain) NSString * notiContact;
@property (nonatomic, retain) NSString * notiLike;
@property (nonatomic, retain) NSNumber * photoCount;
@property (nonatomic, retain) NSNumber * photoLikeCount;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSSet *have;
@property (nonatomic, retain) NSSet *watch;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addHaveObject:(Photo *)value;
- (void)removeHaveObject:(Photo *)value;
- (void)addHave:(NSSet *)values;
- (void)removeHave:(NSSet *)values;

- (void)addWatchObject:(Stock *)value;
- (void)removeWatchObject:(Stock *)value;
- (void)addWatch:(NSSet *)values;
- (void)removeWatch:(NSSet *)values;

@end
