//
//  ChatMessage+addition.h
//  StockShot
//
//  Created by Phatthana Tongon on 5/22/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChatMessage.h"

@interface ChatMessage(addition)
+ (ChatMessage*)messageByTime:(NSString*)time
                      message:(NSString*)message
                     receiver:(NSString*)receiverID
                       sender:(NSString*)senderID
                       status:(NSString*)status InManagedObjectContext:(NSManagedObjectContext *)context;

+ (NSArray *)allChatMessageContext:(NSManagedObjectContext *)context;
@end
