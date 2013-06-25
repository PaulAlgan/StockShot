//
//  LikedViewController.m
//  StockShot
//
//  Created by Phatthana Tongon on 4/23/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import "LikedViewController.h"
#import "IIViewDeckController.h"
#import "User+addition.h"
#import <QuartzCore/QuartzCore.h>
#import <SDWebImage/UIImageView+WebCache.h>
@interface LikedViewController ()
{
    User *me;
    NSArray *photosLike;
    __gm_weak GMGridView *_gmGridView;

}
@end

@implementation LikedViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.title = @"Likes";
    }
    return  self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIButton *refreshButton = [Utility refreshButton];
    [refreshButton addTarget:self action:@selector(reloadPhotos) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [Utility menuBarButtonWithID:self];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:refreshButton];
    
    [self loadGridView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self reloadPhotos];

}

- (void)reloadPhotos
{
    me = [User me];
    if (me.facebookID) {
        [Datahandler getLikedPhotosFromUserID:me.facebookID
                                   OnComplete:^(BOOL success, NSArray *photos)
         {
             photosLike = photos;
             [_gmGridView reloadData];
         }];
    }
}

- (void)loadGridView
{
    NSInteger spacing = 5;
    GMGridView *gmGridView = [[GMGridView alloc] initWithFrame:CGRectMake(0, 0,
                                                                          photoGridView.frame.size.width,
                                                                          photoGridView.frame.size.height)];
    gmGridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    gmGridView.backgroundColor = [UIColor clearColor];
    [photoGridView addSubview:gmGridView];
    _gmGridView = gmGridView;
    _gmGridView.style = GMGridViewStyleSwap;
    _gmGridView.itemSpacing = spacing;
    _gmGridView.centerGrid = NO;
    _gmGridView.enableEditOnLongPress = NO;
    _gmGridView.actionDelegate = self;
    _gmGridView.dataSource = self;
    _gmGridView.mainSuperView = photoGridView;
    [_gmGridView setClipsToBounds:YES];
}

#pragma mark GMGridViewDataSource
- (NSInteger)numberOfItemsInGMGridView:(GMGridView *)gridView
{
    return photosLike.count;
}

- (CGSize)GMGridView:(GMGridView *)gridView sizeForItemsInInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    return CGSizeMake(70, 70);
}
#pragma mark GMGridViewActionDelegate

- (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)position
{
    NSLog(@"Did tap at index %d", position);
    //    PhotoViewController *photoViewController = [[PhotoViewController alloc] init];
    //    photoViewController.photo = [userPhotos objectAtIndex:position];
    //    [self.navigationController pushViewController:photoViewController animated:YES];
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
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        imageView.tag = IMAGE_VIEW_TAG;
        imageView.backgroundColor = [UIColor redColor];
        imageView.layer.masksToBounds = NO;
        cell.contentView = imageView;
    }
    else
    {
        imageView = (UIImageView*)[cell.contentView viewWithTag:IMAGE_VIEW_TAG];
    }
    //    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (photosLike.count > 0)
    {
        NSDictionary *photo = [photosLike objectAtIndex:index];
        [imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://stockshot-kk.appspot.com/api/photo?photo_key=%@",[photo objectForKey:@"key"]]]
                  placeholderImage:[UIImage imageNamed:@"profileImage.png"]];
    }
    return cell;
}


- (BOOL)GMGridView:(GMGridView *)gridView canDeleteItemAtIndex:(NSInteger)index
{
    return NO; //index % 2 == 0;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
