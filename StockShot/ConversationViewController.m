//
//  ConversationViewController.m
//  StockShot
//
//  Created by Phatthana Tongon on 5/24/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import "ConversationViewController.h"
#import "MessageCell.h"
#import "AppDelegate.h"
#import "ChatMessage+addition.h"    
#import "AFJSONRequestOperation.h"
#import "User+addition.h"
#import "Conversation+addition.h"
static NSString *CellClassName = @"MessageCell";

@interface ConversationViewController ()
{
    NSFetchedResultsController *fetchedResultsController;
    AppDelegate *appdelegate;
    User *me;
    BOOL keyboardShow;
}
@end

@implementation ConversationViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [Utility backButton:self];
    
    cellLoader = [UINib nibWithNibName:CellClassName bundle:[NSBundle mainBundle]];
    appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    me = [User me];
    
    contentTableView.backgroundColor = [UIColor clearColor];
    [contentTableView setShowsVerticalScrollIndicator:YES];
    [contentTableView setSeparatorColor:[UIColor clearColor]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"TestNotification"
                                               object:nil];

    
    NSError *error = nil;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ChatMessage"];
    [request setPredicate:[NSPredicate predicateWithFormat:@"to = %@ OR from = %@",self.targetID,self.targetID]];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"timeDate" ascending:YES];
    
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    fetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                        managedObjectContext:appdelegate.managedObjectContext
                                          sectionNameKeyPath:nil cacheName:nil];
    fetchedResultsController.delegate = self;
    [fetchedResultsController performFetch:&error];

    
    chatTextView.delegate = self;
    chatTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    chatTextView.scrollEnabled = NO; // not initially
    chatTextView.scrollIndicatorInsets = UIEdgeInsetsMake(13, 0, 8, 6);
    chatTextView.clearsContextBeforeDrawing = NO;
    chatTextView.dataDetectorTypes = UIDataDetectorTypeAll;
    chatTextView.backgroundColor = [UIColor colorWithWhite:245/255.0f alpha:1];

    [self scrollToBottomAnimated:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
//    self.hidesBottomBarWhenPushed = YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
//    self.hidesBottomBarWhenPushed = NO;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[fetchedResultsController fetchedObjects] count] ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageCell *cell = (MessageCell *)[tableView dequeueReusableCellWithIdentifier:CellClassName];
    if (!cell)
    {
        NSArray *topLevelItems = [cellLoader instantiateWithOwner:self options:nil];
        cell = [topLevelItems objectAtIndex:0];
    }
    
    if ([[fetchedResultsController fetchedObjects] count] > 0) {
        ChatMessage *chatMessage = [fetchedResultsController objectAtIndexPath:indexPath];
//        ChatMessage *chatMessage = [[fetchedResultsController fetchedObjects] objectAtIndex:0];
        cell.message = chatMessage.message;
        cell.userName = chatMessage.from;
        cell.time = chatMessage.timeDate;
        cell.userID = chatMessage.from;
    }
   
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (keyboardShow) {
        [chatTextView resignFirstResponder];
    }
//    ConversationViewController *conversationView = [[ConversationViewController alloc] init];
//    [self.navigationController pushViewController:contentTableView animated:YES];
}


# pragma mark Keyboard Notifications

- (void)keyboardWillShow:(NSNotification *)notification {
    keyboardShow = YES;
    [self resizeViewWithOptions:[notification userInfo]];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    keyboardShow = NO;
    [self resizeViewWithOptions:[notification userInfo]];
}

- (void)resizeViewWithOptions:(NSDictionary *)options
{
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    [[options objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[options objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[options objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:animationCurve];
    [UIView setAnimationDuration:animationDuration];
    
    CGRect viewFrame = self.view.frame;
    NSLog(@"viewFrame y: %@", NSStringFromCGRect(viewFrame));
    
    CGRect keyboardFrameEndRelative = [self.view convertRect:keyboardEndFrame fromView:nil];
    NSLog(@"self.view: %@", self.view);
    NSLog(@"keyboardFrameEndRelative: %@", NSStringFromCGRect(keyboardFrameEndRelative));
    
    viewFrame.size.height =  keyboardFrameEndRelative.origin.y;// - textInputView.frame.size.height;
    self.view.frame = viewFrame;
    [self scrollToBottomAnimated:YES];

    [UIView commitAnimations];
}

- (void)scrollToBottomAnimated:(BOOL)animated {
    NSInteger bottomRow = [[fetchedResultsController fetchedObjects] count] - 1;
    if (bottomRow >= 0) {
        NSIndexPath *indexpath = [NSIndexPath indexPathForItem:[[fetchedResultsController fetchedObjects] count]-1 inSection:0];
        [contentTableView scrollToRowAtIndexPath:indexpath
                           atScrollPosition:UITableViewScrollPositionBottom animated:animated];
    }
}

#pragma mark UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
//    NSString *string = textView.text;
    NSLog(@"textViewDidChange");
    
    if ([textView hasText])
    {
        sendButton.enabled = YES;
    }
    else
    {
        sendButton.enabled = NO;
    }

}

// Fix a scrolling quirk.
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    textView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 3.0f, 0.0f);
    
    return YES;
}

#pragma mark NSFetchedResultsControllerDelegate methods

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [contentTableView beginUpdates];
    NSLog(@"controllerWillChangeContent");
    
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
		   atIndex:(NSUInteger)sectionIndex
	 forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type)
	{
        case NSFetchedResultsChangeInsert:
            NSLog(@"Insert");
            break;
			
        case NSFetchedResultsChangeDelete:
            NSLog(@"Delete");
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
	   atIndexPath:(NSIndexPath *)indexPath
	 forChangeType:(NSFetchedResultsChangeType)type
	  newIndexPath:(NSIndexPath *)newIndexPath
{
	
    switch(type)
	{
        case NSFetchedResultsChangeInsert:
            NSLog(@"Insert");
            [contentTableView insertRowsAtIndexPaths:[NSMutableArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            break;
			
        case NSFetchedResultsChangeDelete:
            
            NSLog(@"Delete");
            break;
			
        case NSFetchedResultsChangeUpdate:
            NSLog(@"Update");
            NSLog(@"Index: %d",indexPath.row);
            [contentTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
//            [appdelegate saveContext];
            break;
			
        case NSFetchedResultsChangeMove:
            
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    NSLog(@"controllerDidChangeContent");
    [contentTableView endUpdates];
    [appdelegate saveContext];
    [self scrollToBottomAnimated:YES];
}

- (IBAction)sendMessage:(id)sender
{
    [self sendPrivateMessage:chatTextView.text];
    chatTextView.text = @"";
}

//https://stockshot-kk.appspot.com/api/send_private_message

- (void)sendPrivateMessage:(NSString*)message
{
    if (!appdelegate)
    {
        appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    }
    NSURL *url = [NSURL URLWithString:@"https://stockshot-kk.appspot.com/api/send_private_message"];
    NSString *params = [[NSString alloc] initWithFormat:@"facebook_id=%@&receiver_id=%@&message=%@",me.facebookID,self.targetID,message];
 
    NSLog(@"SEND: %@",params);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    [request setTimeoutInterval:7];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
                                         {
                                             NSLog(@"SEND RESULT: %@",JSON);
                                             [self performSelector:@selector(getPrivateMessage) withObject:nil afterDelay:0.1];
//                                             [self getPrivateMessage];
                                             
                                         } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
                                         {
                                             [Utility alertWithMessage:[NSString stringWithFormat:@"ERROR: %@",url]];
                                             [self dismissViewControllerAnimated:YES completion:nil];
                                         }];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    [operation start];
}

- (void)getPrivateMessage
{
    if (!appdelegate)
    {
        appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    }
    NSURL *url = [NSURL URLWithString:@"https://stockshot-kk.appspot.com/api/get_private_message"];
    NSString *params = [[NSString alloc] initWithFormat:@"facebook_id=%@",me.facebookID];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    [request setTimeoutInterval:7];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
                                         {
                                             NSArray *chats = [JSON objectForKey:@"chat"];
                                             for (int i=0; i<chats.count; i++)
                                             {
                                                 NSDictionary *msgDict = [chats objectAtIndex:i];
                                                 ChatMessage *chatMessage = [ChatMessage messageByTime:[msgDict objectForKey:@"time"]
                                                                                               message:[msgDict objectForKey:@"message"]
                                                                                              receiver:[msgDict objectForKey:@"receiver"]
                                                                                                sender:[msgDict objectForKey:@"sender"]
                                                                                                status:[msgDict objectForKey:@"status"]
                                                                                InManagedObjectContext:appdelegate.managedObjectContext];
                                             }
                                             [appdelegate saveContext];
                                         } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
                                         {
                                             [Utility alertWithMessage:[NSString stringWithFormat:@"ERROR: %@",url]];
                                             [self dismissViewControllerAnimated:YES completion:nil];
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
