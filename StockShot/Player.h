//
//  Player.h
//  StockShot
//
//  Created by Phatthana Tongon on 5/4/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Player : NSManagedObject

@property (nonatomic, retain) NSNumber * photoLikeCount;
@property (nonatomic, retain) NSString * deviceToken;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * facebookID;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSNumber * followerCount;
@property (nonatomic, retain) NSNumber * followingCount;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * locale;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * notiComment;
@property (nonatomic, retain) NSString * notiContact;
@property (nonatomic, retain) NSString * notiLike;
@property (nonatomic, retain) NSNumber * photoCount;
@property (nonatomic, retain) NSString * username;

@end
