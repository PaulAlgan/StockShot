//
//  CommentCell.h
//  StockShot
//
//  Created by Phatthana Tongon on 6/10/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentCell : UITableViewCell
{
    
}
@property (nonatomic, retain) NSDictionary *comment;
- (void)setComment:(NSDictionary *)comment;

@end
