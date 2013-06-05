//
//  Conversation.h
//  StockShot
//
//  Created by Phatthana Tongon on 5/22/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ChatMessage;

@interface Conversation : NSManagedObject

@property (nonatomic, retain) NSString * toUserID;
@property (nonatomic, retain) NSString * toUserName;
@property (nonatomic, retain) NSString * time;
@property (nonatomic, retain) ChatMessage *lastmessage;

@end
