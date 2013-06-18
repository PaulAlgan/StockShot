//
//  Datahandler.m
//  StockShot
//
//  Created by Phatthana Tongon on 6/15/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import "Datahandler.h"
#import "AFJSONRequestOperation.h"
#import "Stock+addition.h"
#import "User+addition.h"
#import "ChatMessage+addition.h"
#import "Conversation+addition.h"
#import "Photo+addition.h"
#import "AppDelegate.h"
@implementation Datahandler

+ (void)getAllStockOnComplete:(void (^)(bool success, NSArray *allstock))block
{
    AppDelegate *appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSURL *url = [NSURL URLWithString:@"http://210.1.59.181/stockshot/AllStock.aspx"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:7];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation
                                         JSONRequestOperationWithRequest:request
                                         success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
                                         {
//                                             NSLog(@"JSON: %@",JSON);
                                             NSMutableArray *allStock = [[NSMutableArray alloc] init];
                                             NSArray *stocks = [JSON objectForKey:@"stock"];
                                             if (stocks.count>0) {
                                                 for (int i=0; i<stocks.count; i++){
//                                                     NSString *stockName = [stocks objectAtIndex:i];
                                                     Stock *stock = [Stock stockWithName:[stocks objectAtIndex:i]];
                                                     [allStock addObject:stock];
                                                 }
                                                 [appdelegate saveContext];
                                             }
                                             
                                             if (block) {
                                                 block(YES,allStock);
                                             }
                                             
                                         } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
                                         {
                                             if (block) {
                                                 block(NO,nil);
                                             }
                                             [Utility alertWithMessage:[NSString stringWithFormat:@"ERROR: %@",url]];
                                         }];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    
    [operation start];
    
}

+ (void)getStockDetail:(NSString*)stockName OnComplete:(void (^)(BOOL success, Stock *stock))block
{
    AppDelegate *appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://210.1.59.181/stockshot/GetDataStockByName.aspx?symbol=%@",stockName]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:20];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
                                         {
                                             NSDictionary *stockDetail = [NSDictionary dictionaryWithDictionary:JSON];
                                             Stock *stock = [Stock stockWithName:stockName];
                                             stock.dividendYield = [[stockDetail objectForKey:@"DividendYield"] stringValue];
                                             stock.high = [[stockDetail objectForKey:@"High"] stringValue];
                                             stock.last = [[stockDetail objectForKey:@"Last"] stringValue];
                                             stock.low = [[stockDetail objectForKey:@"Low"] stringValue];
                                             stock.marketCap = [[stockDetail objectForKey:@"MarketCap"] stringValue];
                                             stock.open = [[stockDetail objectForKey:@"Open"] stringValue];
                                             stock.pbRatio = [[stockDetail objectForKey:@"PBRatio"] stringValue];
                                             stock.peRatio = [[stockDetail objectForKey:@"PERatio"] stringValue];
                                             stock.persentChange = [[stockDetail objectForKey:@"PersentChange"] stringValue];
                                             stock.previousClose = [[stockDetail objectForKey:@"PreviousClose"] stringValue];
//                                             stock.symbol = [stockDetail objectForKey:@"Symbol"];
                                             stock.volume = [[stockDetail objectForKey:@"Volume"] stringValue];
                                             [appdelegate saveContext];
                                             if (block) {
                                                 block(YES, stock);
                                             }
                                         } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
                                         {
                                             if (block) {
                                                 block(NO, nil);
                                             }
                                         }];
    
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    [operation start];
    
}

+ (void)getRandomPhotosOnComplete:(void (^)(BOOL success, NSArray *photos))block
{
    NSURL *url = [NSURL URLWithString:@"https://stockshot-kk.appspot.com/api/explore"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:20];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
                                         {
//                                             NSLog(@"PhotoRandom: %@",[JSON objectForKey:@"photo_list"]);
                                             NSMutableArray *photoArray = [[NSMutableArray alloc] init];
                                             NSArray *photos = [JSON objectForKey:@"photo_list"];
                                             for (int i=0; i<photos.count; i++)
                                             {
                                                 NSDictionary *photoDict = [photos objectAtIndex:i];
                                                 Photo *photo = [Photo photoWithKey:[photoDict objectForKey:@"key"]];
                                                 photo.createDate = [photoDict objectForKey:@"create_date"];
                                                 photo.likeCount = [[photoDict objectForKey:@"like_count"] stringValue];
                                                 photo.message = [photoDict objectForKey:@"message"];
                                                 [photoArray addObject:photo];
                                             }
                                            if (block) {
                                                 block(YES, [NSArray arrayWithArray:photoArray]);
                                             }
                                         } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
                                         {
                                             if (block) {
                                                 block(NO, nil);
                                             }
                                         }];
    
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    [operation start];
    
}

+ (void)addWatchListWithSymbol:(NSString*)symbol userID:(NSString*)userID OnComplete:(void (^)(BOOL success, NSString *result))block
{
    NSURL *url = [NSURL URLWithString:@"https://stockshot-kk.appspot.com/api/add_wish_list"];
    NSString *params = [NSString stringWithFormat:@"facebook_id=%@&wish_item=%@",userID,symbol];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    [request setTimeoutInterval:20];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
                                         {
                                            NSString *result = [JSON objectForKey:@"result"];
                                            if (block) {
                                                 block(YES, result);
                                             }
                                         } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
                                         {
                                             if (block) {
                                                 block(NO, nil);
                                             }
                                         }];
    
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    [operation start];
    
}

+ (void)removeWatchListWithSymbol:(NSString*)symbol userID:(NSString*)userID OnComplete:(void (^)(BOOL success, NSString *result))block
{
    NSURL *url = [NSURL URLWithString:@"https://stockshot-kk.appspot.com/api/remove_wish_list"];
    NSString *params = [NSString stringWithFormat:@"facebook_id=%@&wish_item=%@",userID,symbol];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    [request setTimeoutInterval:20];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
                                         {
                                             NSString *result = [JSON objectForKey:@"result"];
                                             if (block) {
                                                 block(YES, result);
                                             }
                                         } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
                                         {
                                             if (block) {
                                                 block(NO, nil);
                                             }
                                         }];
    
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    [operation start];
    
}

+ (void)requestUserInfo:(NSString*)userID OnComplete:(void (^)(BOOL success, User *user))block
{
    AppDelegate *appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];

    NSString *requestType = [[NSString alloc] init];
    requestType = @"request_info";
    
    NSURL *url = [NSURL URLWithString:@"https://stockshot-kk.appspot.com/api/player"];
    NSString *params = [[NSString alloc] initWithFormat:@"facebook_id=%@&request_type=%@",userID,requestType];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    [request setTimeoutInterval:7];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
                                         {
                                             NSDictionary *dictionary = [NSDictionary dictionaryWithDictionary:JSON];
                                             NSArray *watchList = [dictionary objectForKey:@"wish_list"];
                                             
                                             User *user = [User userWithFacebookID:userID InManagedObjectContext:appdelegate.managedObjectContext];
                                             user.username = [dictionary objectForKey:@"username"];
                                             user.name = [dictionary objectForKey:@"name"];
                                             user.firstName = [dictionary objectForKey:@"first_name"];
                                             user.lastName = [dictionary objectForKey:@"last_name"];
                                             user.facebookID = [dictionary objectForKey:@"facebook_id"];
                                             user.email = [dictionary objectForKey:@"email"];
                                             user.deviceToken = [dictionary objectForKey:@"device_token"];
                                             user.locale = [dictionary objectForKey:@"locale"];
                                             
                                             user.notiComment = [dictionary objectForKey:@"notification_comment"];
                                             user.notiContact = [dictionary objectForKey:@"notification_contact"];
                                             user.notiLike = [dictionary objectForKey:@"notification_like"];
                                             
                                             user.followerCount =
                                             [NSNumber numberWithLong:[[dictionary objectForKey:@"follower_count"] longValue]];
                                             user.followingCount =
                                             [NSNumber numberWithLong:[[dictionary objectForKey:@"following_count"] longValue]];
                                             user.photoCount =
                                             [NSNumber numberWithLong:[[dictionary objectForKey:@"photo_count"] longValue]];
                                             user.photoLikeCount =
                                             [NSNumber numberWithLong:[[dictionary objectForKey:@"photo_like_count"] longValue]];
                                             
                                             for (int i=0; i<watchList.count; i++)
                                             {
                                                 NSString *symbol = [watchList objectAtIndex:i];
                                                 Stock *stock = [Stock stockWithName:symbol];
                                                 [user addWatchObject:stock];
                                             }
                                             [appdelegate saveContext];
                                             
                                             if (block) {
                                                 block(YES, user);
                                             }
                                             
                                         } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
                                         {
                                             if (block) {
                                                 block(NO, nil);
                                             }
                                         }];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    [operation start];

}

@end
