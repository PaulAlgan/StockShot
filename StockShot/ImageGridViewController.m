//
//  ImageGridViewController.m
//  StockShot
//
//  Created by Phatthana Tongon on 6/3/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import "ImageGridViewController.h"
#import "AFJSONRequestOperation.h"
#import "CommentViewController.h"
#import "PhotoViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <SDWebImage/UIImageView+WebCache.h>
@interface ImageGridViewController ()
{
    NSArray *resultImages;
    __gm_weak GMGridView *_gmGridView;

}
@end

@implementation ImageGridViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithHashTagName:(NSString *)tag
{
    self = [super init];
    if (self) {
        self.hashTag = tag;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadGridView];
    
    self.navigationItem.leftBarButtonItem = [Utility backButton:self];
    self.title = [NSString stringWithFormat:@"#%@",self.hashTag];
    NSLog(@"Hash: %@",self.hashTag);
    hashTagLabel.text = [NSString stringWithFormat:@"#%@",self.hashTag];
    [self getPhotoFromHashTag:self.hashTag];
}

- (void)loadGridView
{
    NSInteger spacing = 5;
    
    GMGridView *gmGridView = [[GMGridView alloc] initWithFrame:CGRectMake(0, 3,
                                                                          contentView.frame.size.width,
                                                                          contentView.frame.size.height-3)];
    gmGridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    gmGridView.backgroundColor = [UIColor clearColor];
    [contentView addSubview:gmGridView];
    _gmGridView = gmGridView;
    _gmGridView.style = GMGridViewStyleSwap;
    _gmGridView.itemSpacing = spacing;
    _gmGridView.scrollEnabled = YES;
    [_gmGridView setBounces:YES];
    _gmGridView.centerGrid = NO;
    _gmGridView.enableEditOnLongPress = NO;
    _gmGridView.actionDelegate = self;
    _gmGridView.dataSource = self;
    _gmGridView.mainSuperView = contentView;
    [_gmGridView setClipsToBounds:YES];
}

#pragma mark GMGridViewDataSource
//////////////////////////////////////////////////////////////

- (NSInteger)numberOfItemsInGMGridView:(GMGridView *)gridView
{
    return resultImages.count;
}

- (CGSize)GMGridView:(GMGridView *)gridView sizeForItemsInInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    return CGSizeMake(70, 70);
}
#pragma mark GMGridViewActionDelegate

- (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)position
{
    NSLog(@"Did tap at index %d", position);
    PhotoViewController *photoVC = [[PhotoViewController alloc] init];
    photoVC.photo = [resultImages objectAtIndex:position];
    [self.navigationController pushViewController:photoVC animated:YES];
}

- (void)GMGridViewDidTapOnEmptySpace:(GMGridView *)gridView
{
    NSLog(@"Tap on empty space");
}

#define IMAGE_VIEW_TAG 101

- (GMGridViewCell *)GMGridView:(GMGridView *)gridView cellForItemAtIndex:(NSInteger)index
{
    CGSize size = [self GMGridView:gridView sizeForItemsInInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    
    GMGridViewCell *cell = [gridView dequeueReusableCell];
    UIImageView *imageView;
    
    if (!cell)
    {
        cell = [[GMGridViewCell alloc] init];
        cell.deleteButtonIcon = [UIImage imageNamed:@"close_x.png"];
        cell.deleteButtonOffset = CGPointMake(-15, -15);
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        imageView.tag = IMAGE_VIEW_TAG;
        imageView.backgroundColor = [UIColor lightGrayColor];
        imageView.layer.masksToBounds = NO;
        cell.contentView = imageView;
    }
    else
    {
        imageView = (UIImageView*)[cell.contentView viewWithTag:IMAGE_VIEW_TAG];
    }
    //    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (resultImages.count > 0)
    {
        NSDictionary *photo = [resultImages objectAtIndex:index];
        [imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://stockshot-kk.appspot.com/api/photo?photo_key=%@",[photo objectForKey:@"key"]]]
                  placeholderImage:[UIImage imageNamed:@"profileImage.png"]];
    }
    return cell;
}


- (BOOL)GMGridView:(GMGridView *)gridView canDeleteItemAtIndex:(NSInteger)index
{
    return NO; //index % 2 == 0;
}


- (void)getPhotoFromHashTag:(NSString*)hashTag
{
    NSURL *url = [NSURL URLWithString:@"https://stockshot-kk.appspot.com/api/search"];
    NSString *params = [[NSString alloc] initWithFormat:@"hashtag=%@",hashTag];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    [request setTimeoutInterval:7];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
                                         {
//                                             NSLog(@"JSON: %@",JSON);
                                             resultImages = [JSON objectForKey:@"photo"];
//                                             NSLog(@"Photo: %@",[resultImages objectAtIndex:0]);
                                             numberPhotosLabel.text = [NSString stringWithFormat:@"%d Photos",resultImages.count];
                                             [_gmGridView reloadData];
                                             
                                         } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
                                         {
                                             [Utility alertWithMessage:[NSString stringWithFormat:@"ERROR: %@",url]];
                                         }];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    [operation start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
