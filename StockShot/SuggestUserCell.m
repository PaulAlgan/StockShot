//
//  SuggestUserCell.m
//  StockShot
//
//  Created by Phatthana Tongon on 6/20/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import "SuggestUserCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "User+addition.h"

@implementation SuggestUserCell
@synthesize playerDict;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (IBAction)touchFollow:(id)sender
{
    User *me = [User me];
    if (me.facebookID)
    {
        [Datahandler followUserID:[playerDict objectForKey:@"id"]
                           FromID:me.facebookID
                       OnComplete:^(BOOL success, NSString *result) {
                           if (success) {
                               [Utility alertWithMessage:[NSString stringWithFormat:@"Follow: %@",result]];
                           }
                           else{
                               [Utility alertWithMessage:@"Follow: error"];
                           }
                       }];
    }
    
}

- (void)setPlayerDict:(NSDictionary *)aplayerDict
{
    playerDict = aplayerDict;
    statusLabel.hidden = YES;
    userNameLabel.text = [self.playerDict objectForKey:@"username"];
    
    [profileImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture",
                                                            [self.playerDict objectForKey:@"id"]]]
                     placeholderImage:[UIImage imageNamed:@"profileImage.png"]];

    
    NSArray *photos = [self.playerDict objectForKey:@"photo"];
    if (photos.count > 0)
    {
        if(photos.count>=4)
        {
            [photo1ImageView setImageWithURL:[NSURL URLWithString:[Utility urlStringForPhotoKey:[[photos objectAtIndex:0] objectForKey:@"key"]]]
                            placeholderImage:nil];
            
            [photo2ImageView setImageWithURL:[NSURL URLWithString:[Utility urlStringForPhotoKey:[[photos objectAtIndex:1] objectForKey:@"key"]]]
                            placeholderImage:nil];
        
            [photo3ImageView setImageWithURL:[NSURL URLWithString:[Utility urlStringForPhotoKey:[[photos objectAtIndex:2] objectForKey:@"key"]]]
                            placeholderImage:nil];
            
            [photo4ImageView setImageWithURL:[NSURL URLWithString:[Utility urlStringForPhotoKey:[[photos objectAtIndex:3] objectForKey:@"key"]]]
                            placeholderImage:nil];
        }
        else if(photos.count == 3)
        {
            [photo1ImageView setImageWithURL:[NSURL URLWithString:[Utility urlStringForPhotoKey:[[photos objectAtIndex:0] objectForKey:@"key"]]]
                            placeholderImage:nil];
            
            [photo2ImageView setImageWithURL:[NSURL URLWithString:[Utility urlStringForPhotoKey:[[photos objectAtIndex:1] objectForKey:@"key"]]]
                            placeholderImage:nil];
            
            [photo3ImageView setImageWithURL:[NSURL URLWithString:[Utility urlStringForPhotoKey:[[photos objectAtIndex:2] objectForKey:@"key"]]]
                            placeholderImage:nil];
        }
        else if(photos.count == 2)
        {
            [photo1ImageView setImageWithURL:[NSURL URLWithString:[Utility urlStringForPhotoKey:[[photos objectAtIndex:0] objectForKey:@"key"]]]
                            placeholderImage:nil];
            
            [photo2ImageView setImageWithURL:[NSURL URLWithString:[Utility urlStringForPhotoKey:[[photos objectAtIndex:1] objectForKey:@"key"]]]
                            placeholderImage:nil];
        }
        else if(photos.count == 1)
        {
            [photo1ImageView setImageWithURL:[NSURL URLWithString:[Utility urlStringForPhotoKey:[[photos objectAtIndex:0] objectForKey:@"key"]]]
                            placeholderImage:nil];

        }
    
    }
    else
    {
        CGRect lineRect = lineView.frame;
        lineRect.origin.y = 45;
        lineView.frame = lineRect;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
