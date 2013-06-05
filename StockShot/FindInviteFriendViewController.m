//
//  FindInviteFriendViewController.m
//  StockShot
//
//  Created by Phatthana Tongon on 4/23/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import "FindInviteFriendViewController.h"
#import "IIViewDeckController.h"
#import "FacebookFriendViewController.h"
#import "ContactViewController.h"
#import "SuggestFriendViewController.h"


@interface FindInviteFriendViewController ()

@end

@implementation FindInviteFriendViewController

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
        self.title = @"Find Friend";
    }
    return  self;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [Utility menuBarButtonWithID:self];
    self.view.backgroundColor = [UIColor colorWithRed:207.0/255.0 green:207.0/255.0 blue:207.0/255.0 alpha:1.0];
    contentTableView.backgroundColor = [UIColor clearColor];
    contentTableView.separatorColor = [UIColor clearColor];
}


#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 38;
}
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return 2;
    else if(section == 1)
        return 1;
    else
        return 1;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    cell.backgroundColor = [UIColor clearColor];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *CellIdentifier = @"Header";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
        
    return cell;
}

- (UITableViewCell *)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UIView *background = [[UIView alloc] initWithFrame:CGRectMake(5, 0, 310, 38)];
    background.backgroundColor = [UIColor colorWithRed:125.0/255.0 green:136.0/255.0 blue:146.0/255.0 alpha:1.0];
    UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(298, 10, 10, 15)];
    arrowImageView.image = [UIImage imageNamed:@"arrow_right.png"];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    for (UIView *view in cell.contentView.subviews){
        [view removeFromSuperview];
    }
    
    [cell.contentView addSubview:background];
    [background sendSubviewToBack:cell.contentView];
    [cell.contentView addSubview:arrowImageView];
    [arrowImageView sendSubviewToBack:cell.contentView];
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
            cell.textLabel.text = @"Facebook Friends";
        else
            cell.textLabel.text = @"From My Contact List";

    }
    else if (indexPath.section == 1)
    {
        cell.textLabel.text = @"Invite Friends";
    }
    else
    {
        cell.textLabel.text = @"Suggested Users";
    }
    
    NSLog(@"FRAME: %@",NSStringFromCGRect(cell.backgroundView.frame));
    
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:17];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            FacebookFriendViewController *facebookFriendView = [[FacebookFriendViewController alloc] init];
            [self.navigationController pushViewController:facebookFriendView animated:YES];
        }
        else
        {
            FacebookFriendViewController *facebookFriendView = [[FacebookFriendViewController alloc] init];
            [self.navigationController pushViewController:facebookFriendView animated:YES];

        }
    }
    else if (indexPath.section == 1)
    {
        ABPeoplePickerNavigationController *picker =
        [[ABPeoplePickerNavigationController alloc] init];
        picker.displayedProperties = [NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:kABPersonJobTitleProperty],
                                      [NSNumber numberWithInt:kABPersonEmailProperty],
                                      [NSNumber numberWithInt:kABPersonPhoneProperty],
                                      nil];
        
        
        picker.peoplePickerDelegate = self;
        picker.title = @"Contacts";
        [self presentViewController:picker animated:YES completion:^{ }];
    }
    else
    {
        SuggestFriendViewController *suggestionView = [[SuggestFriendViewController alloc] init];
        [self.navigationController pushViewController:suggestionView animated:YES];
    }
}


//- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
//{
//    return YES;
//}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier
{
    if (kABPersonEmailProperty == property)
    {
        ABMultiValueRef multi = ABRecordCopyValue(person, kABPersonEmailProperty);
        NSString *email = (__bridge NSString *)ABMultiValueCopyValueAtIndex(multi, identifier);
        NSLog(@"email: %@", email);
        
        MFMailComposeViewController* mailComposer = [[MFMailComposeViewController alloc] init];
        mailComposer.mailComposeDelegate = self;
        [mailComposer setToRecipients:[NSArray arrayWithObjects:email, nil]];
        [mailComposer setSubject:@"Invite to StockShot"];
        [mailComposer setMessageBody:@"Hello there." isHTML:NO];
        if (mailComposer)
        {
            [self dismissViewControllerAnimated:NO completion:nil];
            [self presentModalViewController:mailComposer animated:YES];
        }
    
        
    }
    else if (kABPersonPhoneProperty == property)
    {
        ABMultiValueRef multi = ABRecordCopyValue(person, kABPersonPhoneProperty);
        NSString *phone = (__bridge NSString *)ABMultiValueCopyValueAtIndex(multi, identifier);
        NSLog(@"phone: %@", phone);
    }
//    NSLog(@"Select: %d / %d",property,kABPersonEmailProperty);
    return YES;
}




- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    if (result == MFMailComposeResultSent) {
        NSLog(@"GO");
    }
    else if (result == MFMailComposeResultCancelled ||
             result == MFMailComposeResultSaved)
    {
        
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
