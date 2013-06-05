//
//  Player+addition.m
//  StockShot
//
//  Created by Phatthana Tongon on 5/4/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import "Player+addition.h"

@implementation Player(addition)

+ (Player*)createPlayerWithFacebookID:(NSString*)facebookID InManagedObjectContext:(NSManagedObjectContext *)context
{
    Player *player = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Player"];
    request.predicate = [NSPredicate predicateWithFormat:@"facebookID = %@", facebookID];
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    
    if (matches.count == 1)
    {
        player = [matches lastObject];
    }
    else if (matches.count > 1)
    {
        [Utility alertWithMessage:@"createPlayerWithFacebookID: ERROR"];
    }
    else
    {
        player = [NSEntityDescription insertNewObjectForEntityForName:@"Player"
                                             inManagedObjectContext:context];
        player.facebookID = facebookID;
    }
    return player;
}


+ (Player*)playerByFacebookID:(NSString*)facebookID InManagedObjectContext:(NSManagedObjectContext *)context
{
    Player *player = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Player"];
    request.predicate = [NSPredicate predicateWithFormat:@"facebookID = %@", facebookID];
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (matches.count > 0 || !matches)
    {
        [Utility alertWithMessage:@"playerByFacebookID: ERROR"];
    }
    else
    {
        player = [matches lastObject];
    }
    return player;
}


@end
