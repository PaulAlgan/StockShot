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
                                             NSMutableArray *allStock = [[NSMutableArray alloc] init];
                                             NSArray *stocks = [JSON objectForKey:@"stock"];
                                             if (stocks.count>0) {
                                                 for (int i=0; i<stocks.count; i++){
                                                     NSString *stockName = [stocks objectAtIndex:i];
                                                     Stock *stock = [Stock stockWithName:stockName];
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
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://210.1.59.181/stockshot/GetDataStockByName.aspx?symbol=%@",@"kk"]];
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
                                             stock.symbol = [stockDetail objectForKey:@"Symbol"];
                                             stock.volume = [[stockDetail objectForKey:@"Volume"] stringValue];

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


@end
