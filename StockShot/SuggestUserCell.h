//
//  SuggestUserCell.h
//  StockShot
//
//  Created by Phatthana Tongon on 6/20/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SuggestUserCell : UITableViewCell
{
    IBOutlet UILabel *userNameLabel;
    IBOutlet UILabel *statusLabel;
    IBOutlet UIImageView *profileImageView;
    IBOutlet UIImageView *photo1ImageView;
    IBOutlet UIImageView *photo2ImageView;
    IBOutlet UIImageView *photo3ImageView;
    IBOutlet UIImageView *photo4ImageView;
    IBOutlet UIView *lineView;

}
- (void)setPlayerDict:(NSDictionary *)playerDict;
- (IBAction)touchFollow:(id)sender;
@property (nonatomic,retain) NSDictionary *playerDict;

@end
