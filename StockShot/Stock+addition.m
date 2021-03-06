//
//  Stock+addition.m
//  StockShot
//
//  Created by Phatthana Tongon on 6/14/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import "Stock+addition.h"
#import "AppDelegate.h"
@implementation Stock(addition)

+ (Stock*)getStockWithName:(NSString*)name
{
    AppDelegate *appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    Stock *stock = nil;
    
    name = [name uppercaseString];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Stock"];
    request.predicate = [NSPredicate predicateWithFormat:@"symbol = %@",name];
    
    NSError *error = nil;
    NSArray *matches = [appdelegate.managedObjectContext executeFetchRequest:request error:&error];
    
    if (matches.count > 0)
    {
        stock = [matches lastObject];
    }
    else
    {
     
    }
    return stock;
}

+ (Stock*)stockWithName:(NSString*)name
{
    AppDelegate *appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    Stock *stock = nil;
 
    name = [name uppercaseString];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Stock"];
    request.predicate = [NSPredicate predicateWithFormat:@"symbol = %@",name];
    
    NSError *error = nil;
    NSArray *matches = [appdelegate.managedObjectContext executeFetchRequest:request error:&error];
    
    if (matches.count > 1)
    {
        NSLog(@"Stock Error!");
        [Utility alertWithMessage:@"StockError"];
    }
    else if (matches.count == 0)
    {
        stock = [NSEntityDescription insertNewObjectForEntityForName:@"Stock"
                                             inManagedObjectContext:appdelegate.managedObjectContext];
        stock.symbol = name;
    }
    else
    {
        stock = [matches lastObject];
    }
    return stock;
}

+ (NSArray*)getAllStock
{
    AppDelegate *appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];

    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Stock"];
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"symbol" ascending:YES];
    [request setSortDescriptors:@[sortByName]];
    
    NSError *error = nil;
    NSArray *matches = [appdelegate.managedObjectContext executeFetchRequest:request error:&error];
    return matches;
}

@end
