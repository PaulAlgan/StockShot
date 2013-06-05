//
//  ChatRoomCell.h
//  StockShot
//
//  Created by Phatthana Tongon on 5/5/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatRoomCell : UITableViewCell
{
    IBOutlet UIImageView *chatImageView;
    IBOutlet UILabel *roomNameLabel;
    IBOutlet UILabel *messageLabel;
    IBOutlet UILabel *timeLabel;
    IBOutlet UILabel *unreadLabel;
}
@property (nonatomic,retain) NSString *roomName;
@property (nonatomic,retain) NSString *message;
@property (nonatomic,retain) NSDate *time;
@property int unreadN;

@end
