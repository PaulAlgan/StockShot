//
//  MessageCell.h
//  StockShot
//
//  Created by Phatthana Tongon on 5/24/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageCell : UITableViewCell
{
    IBOutlet UILabel *nameLabel;
    IBOutlet UILabel *messageLabel;
    IBOutlet UILabel *timeLabel;
    IBOutlet UIImageView *profileImageView;
}
@property (nonatomic, retain) NSString *message;
@property (nonatomic, retain) NSString *userName;
@property (nonatomic, retain) NSDate *time;
@property (nonatomic, retain) NSString *userID;

@end
