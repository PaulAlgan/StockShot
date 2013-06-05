//
//  ChatMessage.h
//  StockShot
//
//  Created by Phatthana Tongon on 5/28/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Conversation;

@interface ChatMessage : NSManagedObject

@property (nonatomic, retain) NSString * from;
@property (nonatomic, retain) NSString * message;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSString * time;
@property (nonatomic, retain) NSDate * timeDate;
@property (nonatomic, retain) NSString * to;
@property (nonatomic, retain) Conversation *conversation;

@end
