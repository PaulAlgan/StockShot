//
//  PhotoViewController.m
//  StockShot
//
//  Created by Phatthana Tongon on 6/11/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import "PhotoViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <SDWebImage/UIImageView+WebCache.h>
static NSString *CellClassName = @"ImageViewCell";

@interface PhotoViewController ()

@end

@implementation PhotoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id)init{
    self = [super init];
    if (self) {
        self.title = @"Photo";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [Utility backButton:self];
    cellLoader = [UINib nibWithNibName:CellClassName bundle:[NSBundle mainBundle]];

}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 45;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 400;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
        return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

#pragma mark - ImageCell Delegate
- (void)touchCommentInKey:(NSString *)key
{
    CommentViewController *commentVC = [[CommentViewController alloc] initWithPhotoDict:self.photo];
    [self.navigationController pushViewController:commentVC animated:YES];
    [self setHidesBottomBarWhenPushed:NO];
}

#define IMAGE_VIEW_TAG 101
#define USERNAME 200
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *CellIdentifier = @"Header";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UIImageView *userImageView = nil;
    UIButton *userNameButton = nil;
    UIImageView *clockImageView = nil;
    UILabel *timeLabel = nil;
    
    userImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 35, 35)];
    userImageView.backgroundColor = [UIColor redColor];
    userImageView.layer.masksToBounds = NO;
    
    userNameButton = [[UIButton alloc] initWithFrame:CGRectMake(45, 0, 180, 45)];
    userNameButton.tag = USERNAME+section;
    userNameButton.backgroundColor = [UIColor clearColor];
    userNameButton.titleLabel.textColor = [UIColor whiteColor];
    userNameButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    userNameButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    userNameButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [userNameButton addTarget:self
                       action:@selector(touchUserName:) forControlEvents:UIControlEventTouchUpInside];
    
    clockImageView = [[UIImageView alloc] initWithFrame:CGRectMake(258-15, 15, 14, 14)];
    clockImageView.image = [UIImage imageNamed:@"clock.png"];
    clockImageView.backgroundColor = [UIColor clearColor];
    
    timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(275-15, 15, 55, 14)];
    timeLabel.textColor = [UIColor whiteColor];
    timeLabel.font = [UIFont boldSystemFontOfSize:14];
    timeLabel.backgroundColor = [UIColor clearColor];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    for (UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    [cell.contentView addSubview:userImageView];
    [cell.contentView addSubview:userNameButton];
    [cell.contentView addSubview:clockImageView];
    [cell.contentView addSubview:timeLabel];
    
    
    
    NSDictionary *player = [self.photo objectForKey:@"player"];
    
    cell.backgroundColor = [UIColor colorWithRed:125.0/255.0 green:136.0/255.0 blue:146.0/255.0 alpha:1.0];
    
    NSString *playerName = [player objectForKey:@"name"];
    [userNameButton setTitle:playerName forState:UIControlStateNormal];
    
    [userImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture",[player objectForKey:@"facebook_id"]]]
                  placeholderImage:[UIImage imageNamed:@"profileImage.png"]];
    
    NSString *dateString = [self.photo objectForKey:@"create_date"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSSSS";
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    timeLabel.text = [Utility shortTimeAgoWithDate:[formatter dateFromString:dateString]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ImageViewCell *cell = (ImageViewCell *)[tableView dequeueReusableCellWithIdentifier:CellClassName];
    if (!cell)
    {
        NSArray *topLevelItems = [cellLoader instantiateWithOwner:self options:nil];
        cell = [topLevelItems objectAtIndex:0];
    }
    
    cell.delegate = self;
    cell.backgroundColor = [UIColor greenColor];
    NSDictionary *player = [self.photo objectForKey:@"player"];
    
    cell.urlStringImage = [NSString stringWithFormat:@"https://stockshot-kk.appspot.com/api/photo?photo_key=%@",[self.photo objectForKey:@"key"]];
    cell.message = [NSString stringWithFormat:@"%@ %@",
                    [player objectForKey:@"name"],[self.photo objectForKey:@"message"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.photoKey = [self.photo objectForKey:@"key"];
    return cell;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
