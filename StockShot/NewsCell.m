//
//  NewsCell.m
//  StockShot
//
//  Created by Phatthana Tongon on 6/10/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import "NewsCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@implementation NewsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (int)getRowHeightWithNewsFeed:(NSDictionary*)newsFeed
{
    int rowHeight = 0;
    int labelWidth;
    
    NSString *contentString = [self contentStringFromNewsFeed:newsFeed];
    
    if ([newsFeed objectForKey:@"photo"]){
        labelWidth = 205;
    }
    else{
        labelWidth = 251;
    }
    
    CGSize size;
    size = [contentString sizeWithFont:[UIFont systemFontOfSize:13]
              constrainedToSize:CGSizeMake(labelWidth, CGFLOAT_MAX)
                  lineBreakMode:NSLineBreakByWordWrapping];
    rowHeight = size.height;
    return rowHeight;
}

- (void)setNewsFeed:(NSDictionary *)newsFeed
{
    _newsFeed = newsFeed;
    NSDictionary *player = [newsFeed objectForKey:@"action_player"];
    NSString *contentString = [self contentStringFromNewsFeed:newsFeed];
    
    NSDictionary *photo = nil;
    NSString *photoKey = nil;
    if ([[newsFeed objectForKey:@"photo"] isKindOfClass:[NSDictionary class]])
    {
        photo = [newsFeed objectForKey:@"photo"];
        photoKey = [photo objectForKey:@"key"];
    }
    else if ([[newsFeed objectForKey:@"photo"] isKindOfClass:[NSString class]])
    {
        photoKey = [newsFeed objectForKey:@"photo"];
    }
    contentLabel.text = contentString;
    [profileImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture",[player objectForKey:@"facebook_id"]]]
                     placeholderImage:[UIImage imageNamed:@"profileImage.png"]];
    
    
    CGRect labelRect = contentLabel.frame;
    if (photoKey) {
        [targetImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://stockshot-kk.appspot.com/api/photo?photo_key=%@",photoKey]]
                        placeholderImage:[UIImage imageNamed:@"profileImage.png"]];
        labelRect.size.width = 205;
    }
    else{
        labelRect.size.width = 251;
    }
    
    CGSize size;
    size = [contentString sizeWithFont:[UIFont systemFontOfSize:13]
                     constrainedToSize:CGSizeMake(labelRect.size.width, CGFLOAT_MAX)
                         lineBreakMode:NSLineBreakByWordWrapping];
    labelRect.size.height = size.height;
//    NSLog(@"LABEL_H: %f",labelRect.size.height);
    contentLabel.frame = labelRect;

}

- (NSString*)contentStringFromNewsFeed:(NSDictionary*)newsFeed
{
    NSDictionary *player = [newsFeed objectForKey:@"action_player"];
    NSDictionary *comment = nil;
    NSDictionary *photo = nil;
    if ([newsFeed objectForKey:@"comment"]){
        comment = [newsFeed objectForKey:@"comment"];
    }
    if ([newsFeed objectForKey:@"photo"]){
        photo = [newsFeed objectForKey:@"photo"];
    }
    
    NSString *contentString = [[NSString alloc] init];
    
    if ([[newsFeed objectForKey:@"kind"] isEqualToString:@"comment"])
    {
        if (photo)
        {
            if ([photo objectForKey:@"message"])
            {
                contentString = [NSString stringWithFormat:@"%@ left a comment on your photo: %@"
                                 ,[player objectForKey:@"name"]
                                 ,[photo objectForKey:@"message"]];
            }
            else
            {
                contentString = [NSString stringWithFormat:@"%@ left a comment on your photo",[player objectForKey:@"name"]];
            }
        }
    }
    else if ([[newsFeed objectForKey:@"kind"] isEqualToString:@"follow"])
    {
        contentString = [NSString stringWithFormat:@"%@ started following you",[player objectForKey:@"name"]];
    }
    else if ([[newsFeed objectForKey:@"kind"] isEqualToString:@"like_photo"])
    {
        contentString = [NSString stringWithFormat:@"%@ liked your photo",[player objectForKey:@"name"]];
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSSSS";
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    NSString *dateAgoString = [Utility timeAgoWithDate:[formatter dateFromString:[newsFeed objectForKey:@"date"]]];

    contentString = [contentString stringByAppendingFormat:@" %@",dateAgoString];
    
    return contentString;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

@end
