//
//  ChatRoomCell.m
//  StockShot
//
//  Created by Phatthana Tongon on 5/5/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import "ChatRoomCell.h"

@implementation ChatRoomCell
@synthesize roomName;
@synthesize message;
@synthesize time;
@synthesize unreadN;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setRoomName:(NSString *)_roomName
{
    roomNameLabel.text = _roomName;
    NSLog(@"RoomName: %@",_roomName);
}

- (void)setMessage:(NSString *)_message
{
    messageLabel.text = _message;
}

- (void)setTime:(NSDate *)_time
{
    NSCalendar *sysCalendar = [NSCalendar currentCalendar];
    NSDate *dateNow = [NSDate date];
    int timeAgo;
    NSString *unit = [[NSString alloc] init];
    
    unsigned int unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit;
    
    NSDateComponents *breakdownInfo = [sysCalendar components:unitFlags fromDate:_time  toDate:dateNow  options:0];
    
    if ([breakdownInfo month] > 0)
    {
        timeAgo = [breakdownInfo month];
        if (timeAgo>1)
            unit = @"months";
        else
            unit = @"month";
    }
    else if([breakdownInfo day] > 0)
    {
        timeAgo = [breakdownInfo day];
        if (timeAgo>1)
            unit = @"days";
        else
            unit = @"day";
    }
    else if([breakdownInfo hour] > 0)
    {
        timeAgo = [breakdownInfo hour];
        if (timeAgo>1)
            unit = @"hours";
        else
            unit = @"hour";
    }
    else if([breakdownInfo minute] > 0)
    {
        timeAgo = [breakdownInfo minute];
        if (timeAgo>1)
            unit = @"mins";
        else
            unit = @"min";
    }
    else
    {
        timeAgo = [breakdownInfo second];
        if (timeAgo>1)
            unit = @"secs";
        else
            unit = @"sec";
    }

    timeLabel.text = [NSString stringWithFormat:@"%d %@ ago",timeAgo,unit];
    
}

//- (float)setUserName:(NSString*)user Text:(NSString*)detail Time:(NSString*)time ImageURL:(NSString*)urlImage
//{
//    int timeAgo;
//    float w;
//    NSString *unit = [[NSString alloc] init];
//    
//    NSDateFormatter *df = [[NSDateFormatter alloc] init];
//    //Wed Dec 01 17:08:03 +0000 2010
//    [df setDateFormat:@"eee MMM dd HH:mm:ss ZZZZ yyyy"];
//    NSCalendar *sysCalendar = [NSCalendar currentCalendar];
//    
//    NSDate *date1 = [df dateFromString:time];
//    NSDate *date2 = [NSDate date];
//    unsigned int unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit;
//    
//    NSDateComponents *breakdownInfo = [sysCalendar components:unitFlags fromDate:date1  toDate:date2  options:0];
//    
//    if ([breakdownInfo month] > 0)
//    {
//        timeAgo = [breakdownInfo month];
//        if (timeAgo>1) {
//            unit = @"months";
//        }
//        else{
//            unit = @"month";
//        }
//    }
//    else if([breakdownInfo day] > 0)
//    {
//        timeAgo = [breakdownInfo day];
//        if (timeAgo>1) {
//            unit = @"days";
//            w = 30.0;
//        }
//        else{
//            unit = @"day";
//            w = 23.0;
//        }
//    }
//    else if([breakdownInfo hour] > 0)
//    {
//        timeAgo = [breakdownInfo hour];
//        if (timeAgo>1) {
//            unit = @"hours";
//            w = 35.0;
//        }
//        else{
//            unit = @"hour";
//            w = 28.0;
//        }
//    }
//    else if([breakdownInfo minute] > 0)
//    {
//        timeAgo = [breakdownInfo minute];
//        if (timeAgo>1) {
//            unit = @"mins";
//            w = 30.0;
//        }
//        else{
//            unit = @"min";
//            w = 23.0;
//        }
//    }
//    else if([breakdownInfo second] > 0)
//    {
//        timeAgo = [breakdownInfo second];
//        if (timeAgo>1) {
//            unit = @"secs";
//            w = 29.0;
//        }
//        else{
//            unit = @"sec";
//            w = 22.0;
//        }
//    }
//    
//     
//    
//    
//    
//    userLabel.text = user;
//    detailLabel.text = detail;  detailLabel.backgroundColor = [UIColor clearColor];
//    timeAgoLabel.text = [NSString stringWithFormat:@"%d",timeAgo];
//    timeLabel.text = unit;
//    
//  }


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
