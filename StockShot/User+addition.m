//
//  User+addition.m
//  StockShot
//
//  Created by Phatthana Tongon on 4/26/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import "User+addition.h"
#import "AppDelegate.h"
@implementation User(addition)

+ (User*)me
{
    AppDelegate *appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    User *user = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    request.predicate = [NSPredicate predicateWithFormat:@"me = 1"];
    NSError *error = nil;
    NSArray *matches = [appdelegate.managedObjectContext executeFetchRequest:request error:&error];
    
    if (matches.count > 0)
    {
        user = [matches lastObject];
    }
    else
    {
        
    }

    return user;
}
+ (User*)meInManagedObjectContext:(NSManagedObjectContext *)context
{
    User *user = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];

    
    if (matches.count > 0)
    {
        user = [matches lastObject];
    }
    else
    {
        
    }
    
    
    return user;
}

+ (User*)userWithFacebookID:(NSString*)facebookID InManagedObjectContext:(NSManagedObjectContext *)context
{
    User *user = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    request.predicate = [NSPredicate predicateWithFormat:@"facebookID = %@", facebookID];

    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (matches.count > 0)
    {
        user = [matches lastObject];
        user.facebookID = facebookID;
    }
    else
    {
        user = [NSEntityDescription insertNewObjectForEntityForName:@"User"
                                           inManagedObjectContext:context];
        user.facebookID = facebookID;
        user.me = [NSNumber numberWithBool:NO];
    }    
    return user;
}

@end
