//
//  Conversation+addition.m
//  StockShot
//
//  Created by Phatthana Tongon on 5/22/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import "Conversation+addition.h"
#import "ChatMessage+addition.h"
@implementation Conversation(addition)


+ (Conversation *)conversationWithUser:(NSString *)userID lastMessage:(ChatMessage*)lastMessage context:(NSManagedObjectContext *)context {
    Conversation *converstion = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Conversation"];
    request.predicate = [NSPredicate predicateWithFormat:@"toUserID = %@", userID];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"lastmessage.timeDate" ascending:NO];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || ([matches count] > 1)) {
        // handle error
    } else if ([matches count] == 0) {
        NSLog(@"NEW CONVERSION");
        converstion = [NSEntityDescription insertNewObjectForEntityForName:@"Conversation" inManagedObjectContext:context];
        converstion.toUserID = userID;

    } else
    {
        converstion = [matches lastObject];
        
        if (lastMessage) {
            if ([lastMessage.timeDate compare:converstion.lastmessage.timeDate] == NSOrderedDescending) {
                [converstion setLastmessage:lastMessage];
            }
        }
    }
    return converstion;
}

+ (NSArray *)allConversationContext:(NSManagedObjectContext *)context {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Conversation"];
    //    request.predicate = [NSPredicate predicateWithFormat:@"to = %@ OR from = %@", userID, userID];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"lastmessage.timeDate" ascending:NO];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    return matches;
}

@end
