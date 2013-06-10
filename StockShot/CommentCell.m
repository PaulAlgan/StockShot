//
//  CommentCell.m
//  StockShot
//
//  Created by Phatthana Tongon on 6/10/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import "CommentCell.h"
#import "User+addition.h"
#import "AppDelegate.h"
#import <SDWebImage/UIImageView+WebCache.h>
@implementation CommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (int)rowHeightWithComment:(NSDictionary*)comment
{
    NSString *contentString = [self contentByComment:comment];
    CGSize size;
    size = [contentString sizeWithFont:[UIFont systemFontOfSize:13]
                     constrainedToSize:CGSizeMake(242, CGFLOAT_MAX)
                         lineBreakMode:NSLineBreakByWordWrapping];
    NSLog(@"H: %@  contentW: %f",NSStringFromCGSize(size),contentLable.frame.size.width);
    return size.height;
}

- (void)setComment:(NSDictionary *)comment
{
    NSString *userID = [comment objectForKey:@"player"];

    NSString *contentString = [self contentByComment:comment];
    CGSize size;
    size = [contentString sizeWithFont:[UIFont systemFontOfSize:13]
                     constrainedToSize:CGSizeMake(242, CGFLOAT_MAX)
                         lineBreakMode:NSLineBreakByWordWrapping];

    

    [profileImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture",userID]]
                     placeholderImage:[UIImage imageNamed:@"profileImage.png"]];
    
    CGRect contentRect = contentLable.frame;
    contentRect.size = size;
    contentLable.frame = contentRect;
    contentLable.text = contentString;
    
//    CGRect timeRect = timeLable.frame;
//    timeRect.origin.y = contentRect.origin.y+contentRect.size.height;
//    timeLable.frame = timeRect;
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSSSS";
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];

    timeLable.text = [Utility timeAgoWithDate:[formatter dateFromString:[comment objectForKey:@"date"]]];
}

- (NSString*)contentByComment:(NSDictionary*)comment
{
    AppDelegate *appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *commentString = [comment objectForKey:@"comment"];
    NSString *userID = [comment objectForKey:@"player"];
    User *user = [User userWithFacebookID:userID InManagedObjectContext:appdelegate.managedObjectContext];
    NSString *contentString = [[NSString alloc] init];
    
    if (user.username) {
        contentString = [contentString stringByAppendingString:user.username];
    }else{
        contentString = [contentString stringByAppendingString:userID];
    }
    contentString = [contentString stringByAppendingFormat:@" %@",commentString];
    
    return contentString;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
