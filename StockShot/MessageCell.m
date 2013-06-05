//
//  MessageCell.m
//  StockShot
//
//  Created by Phatthana Tongon on 5/24/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import "MessageCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@implementation MessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUserID:(NSString *)userID
{
    [profileImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture",userID]]
                     placeholderImage:[UIImage imageNamed:@"profileImage.png"]];
}

- (void)setMessage:(NSString *)amessage
{
    messageLabel.text = amessage;
}

- (void)setUserName:(NSString *)auserName
{
    nameLabel.text = auserName;
}

- (void)setTime:(NSDate *)time
{
    NSCalendar *sysCalendar = [NSCalendar currentCalendar];
    NSDate *dateNow = [NSDate date];
    int timeAgo;
    NSString *unit = [[NSString alloc] init];
    
    unsigned int unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit;
    
    NSDateComponents *breakdownInfo = [sysCalendar components:unitFlags fromDate:time  toDate:dateNow  options:0];
    
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
            unit = @"minutes";
        else
            unit = @"minute";
    }
    else
    {
        timeAgo = [breakdownInfo second];
        if (timeAgo>1 && timeAgo < 60)
            unit = @"secs";
        else
        {
            unit = @"sec";
            timeAgo = 1;
        }
        
    }
    timeLabel.text = [NSString stringWithFormat:@"%d %@ ago",timeAgo,unit];
}


@end
