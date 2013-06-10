//
//  ImageViewCell.m
//  StockShot
//
//  Created by Phatthana Tongon on 5/5/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import "ImageViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AFJSONRequestOperation.h"
#import "User+addition.h"
#import "AppDelegate.h"
@interface ImageViewCell()
{
    
}

@end
@implementation ImageViewCell
@synthesize urlStringImage;
@synthesize delegate;

- (void)setUrlStringImage:(NSString *)aurlStringImage
{
//    NSLog(@"URL: %@",aurlStringImage);
    [contentImageView setImageWithURL:[NSURL URLWithString:aurlStringImage] placeholderImage:nil];
}

- (void)setMessage:(NSString *)message
{
    messageLabel.text = message;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)like:(id)sender
{
    if (self.photoKey.length > 1){
        [self likePhotoWithID:self.photoKey];
    }
    else{
        [Utility alertWithMessage:@"ERROE: DON'T HAVE PHOTO_KEY"];
    }
}

- (IBAction)comment:(id)sender
{
    [self.delegate touchCommentInKey:self.photoKey];
}

- (void)likePhotoWithID:(NSString*)photoKey
{
    AppDelegate *appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    User *me = [User me];
    NSURL *url = [NSURL URLWithString:@"https://stockshot-kk.appspot.com/api/like"];
    NSString *params = [[NSString alloc] initWithFormat:@"facebook_id=%@&photo_key=%@",me.facebookID,photoKey];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    [request setTimeoutInterval:7];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation
                                         JSONRequestOperationWithRequest:request
                                         success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
                                         {;
                                             [Utility alertWithMessage:[NSString stringWithFormat:@"Like: %@",[JSON objectForKey:@"result"]]];
                                             
                                         } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
                                         {
                                             [Utility alertWithMessage:[NSString stringWithFormat:@"ERROR: %@",url]];
                                         }];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    [operation start];    
}



@end
