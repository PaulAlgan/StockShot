//
//  ChatMessage+addition.m
//  StockShot
//
//  Created by Phatthana Tongon on 5/22/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import "ChatMessage+addition.h"

@implementation ChatMessage(addition)

+ (ChatMessage*)messageByTime:(NSString*)time
                     message:(NSString*)message
                 receiver:(NSString*)receiverID
                   sender:(NSString*)senderID
                   status:(NSString*)status InManagedObjectContext:(NSManagedObjectContext *)context
{
    ChatMessage *chatMessage = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ChatMessage"];
    request.predicate = [NSPredicate predicateWithFormat:@"time = %@ AND message = %@", time,message];
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (matches.count > 1 || !matches)
    {
        [Utility alertWithMessage:@"chatByTime: ERROR"];
    }
    else if (matches.count == 0)
    {
        chatMessage = [NSEntityDescription insertNewObjectForEntityForName:@"ChatMessage"
                                                inManagedObjectContext:context];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSSSS";
        [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];

        chatMessage.time = time;
        chatMessage.timeDate = [formatter dateFromString:time];
        chatMessage.message = message;
        chatMessage.to = receiverID;
        chatMessage.from = senderID;
    }
    else
    {
        chatMessage = [matches lastObject];
    }
    return chatMessage;
}

+ (NSArray *)allChatMessageContext:(NSManagedObjectContext *)context {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ChatMessage"];
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    return matches;
}

@end
