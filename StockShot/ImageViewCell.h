//
//  ImageViewCell.h
//  StockShot
//
//  Created by Phatthana Tongon on 5/5/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImageViewCellDelegate;

@interface ImageViewCell : UITableViewCell
{
    IBOutlet UIImageView *contentImageView;
    IBOutlet UILabel *likeListsLabel;
    IBOutlet UILabel *messageLabel;
    
    IBOutlet UIButton *commentButton;
    IBOutlet UIButton *likeButton;
    
}
@property (nonatomic, assign) id<ImageViewCellDelegate, NSObject> delegate;
@property (nonatomic, retain) NSString *urlStringImage;
@property (nonatomic, strong) NSString *photoKey;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *key;

- (IBAction)like:(id)sender;
- (IBAction)comment:(id)sender;
@end


@protocol ImageViewCellDelegate
- (void)touchCommentInKey:(NSString*)key;
@end