//
//  Conversation+addition.h
//  StockShot
//
//  Created by Phatthana Tongon on 5/22/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Conversation.h"
@class ChatMessage;

@interface Conversation(addition)
{
    
}

+ (Conversation *)conversationWithUser:(NSString *)userID lastMessage:(ChatMessage*)lastMessage context:(NSManagedObjectContext *)context;
+ (NSArray *)allConversationContext:(NSManagedObjectContext *)context;

@end
