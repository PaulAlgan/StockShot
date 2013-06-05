//
//  User+addition.h
//  StockShot
//
//  Created by Phatthana Tongon on 4/26/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import "User.h"

@interface User(addition)
+ (User*)meInManagedObjectContext:(NSManagedObjectContext *)context;
+ (User*)me;
+ (User*)userWithFacebookID:(NSString*)facebookID InManagedObjectContext:(NSManagedObjectContext *)context;

@end
