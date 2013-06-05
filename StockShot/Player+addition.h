//
//  Player+addition.h
//  StockShot
//
//  Created by Phatthana Tongon on 5/4/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import "Player.h"
@interface Player(addition)
{
    
}

+ (Player*)playerByFacebookID:(NSString*)facebookID InManagedObjectContext:(NSManagedObjectContext *)context;
+ (Player*)createPlayerWithFacebookID:(NSString*)facebookID InManagedObjectContext:(NSManagedObjectContext *)context;

@end
