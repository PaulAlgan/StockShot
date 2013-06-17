//
//  Photo+addition.m
//  StockShot
//
//  Created by Phatthana Tongon on 6/18/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import "Photo+addition.h"
#import "AppDelegate.h"
@implementation Photo(addition)

+ (Photo*)photoWithKey:(NSString*)key
{
    AppDelegate *appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    Photo *photo = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.predicate = [NSPredicate predicateWithFormat:@"key = %@",key];
    
    NSError *error = nil;
    NSArray *matches = [appdelegate.managedObjectContext executeFetchRequest:request error:&error];
    
    if (matches.count > 1)
    {
        NSLog(@"Stock Error!");
        [Utility alertWithMessage:@"StockError"];
    }
    else if (matches.count == 0)
    {
        photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo"
                                              inManagedObjectContext:appdelegate.managedObjectContext];
        photo.key = key;
    }
    else
    {
        photo = [matches lastObject];
    }
    return photo;
}

@end
