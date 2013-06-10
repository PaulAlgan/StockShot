//
//  NewsCell.h
//  StockShot
//
//  Created by Phatthana Tongon on 6/10/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsCell : UITableViewCell
{
    IBOutlet UILabel *contentLabel;
    IBOutlet UIImageView *profileImageView;
    IBOutlet UIImageView *targetImageView;
}
@property (nonatomic, retain) NSDictionary *newsFeed;
- (void)setNewsFeed:(NSDictionary *)newsFeed;
- (int)getRowHeightWithNewsFeed:(NSDictionary*)newsFeed;
@end
