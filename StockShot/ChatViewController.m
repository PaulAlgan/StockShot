//
//  ChatViewController.m
//  StockShot
//
//  Created by Phatthana Tongon on 4/21/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import "ChatViewController.h"
#import "AFJSONRequestOperation.h"
#import "AppDelegate.h"
#import "User+addition.h"
#import "ChatMessage+addition.h"
#import "Conversation+addition.h"
#import "ConversationViewController.h"

static NSString *CellClassName = @"ChatRoomCell";

@interface ChatViewController ()
{
    AppDelegate *appdelegate;
    User *me;
    NSArray *chatRooms;
    NSFetchedResultsController *fetchedResultsController;
}
- (NSArray*)queryChatRoom;
@end

@implementation ChatViewController

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
    self.navigationItem.title = @"Chats";

    cellLoader = [UINib nibWithNibName:CellClassName bundle:[NSBundle mainBundle]];

    self.navigationItem.leftBarButtonItem = [Utility menuBarButtonWithID:self];
    appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    contentTableView.backgroundColor = [UIColor clearColor];
    contentTableView.separatorColor = [UIColor clearColor];
    self.view.backgroundColor = [Utility backgroundColor];
    
    NSError *error = nil;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Conversation"];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"lastmessage.timeDate" ascending:NO];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    fetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                        managedObjectContext:appdelegate.managedObjectContext
                                          sectionNameKeyPath:nil cacheName:nil];
    fetchedResultsController.delegate = self;
    [fetchedResultsController performFetch:&error];
    
    UIButton *createChatButton = [[UIButton alloc] init];
    [createChatButton addTarget:self
                         action:@selector(createChatRoom)
               forControlEvents:UIControlEventTouchUpInside];

}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    me = [User me];
    [self getPrivateMessage];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
}
- (void)createChatRoom
{
    NSLog(@"CreateRoom");
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[fetchedResultsController fetchedObjects] count];
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatRoomCell *cell = (ChatRoomCell *)[tableView dequeueReusableCellWithIdentifier:CellClassName];
    if (!cell)
    {
        NSArray *topLevelItems = [cellLoader instantiateWithOwner:self options:nil];
        cell = [topLevelItems objectAtIndex:0];
    }
    
    if ([[fetchedResultsController fetchedObjects] count] > 0) {
        Conversation *conversation = [fetchedResultsController objectAtIndexPath:indexPath];
        cell.roomName = conversation.toUserID;
        cell.message = conversation.lastmessage.message;
        cell.time = conversation.lastmessage.timeDate;
//        NSLog(@"TIME: %@",chat.time);
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;

}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    Conversation *conversation = [fetchedResultsController objectAtIndexPath:indexPath];
    ConversationViewController *conversationView = [[ConversationViewController alloc] init];

    conversationView.targetID = conversation.toUserID;
    [self.navigationController pushViewController:conversationView animated:YES];
    [self setHidesBottomBarWhenPushed:NO];
}

- (void)chatToUser:(User*)targetUser
{
    Conversation *conversation = [Conversation conversationWithUser:targetUser.facebookID lastMessage:nil
                                                            context:appdelegate.managedObjectContext];
    ConversationViewController *conversationView = [[ConversationViewController alloc] init];
    conversationView.targetID = conversation.toUserID;
    [self.navigationController pushViewController:conversationView animated:YES];
    [self setHidesBottomBarWhenPushed:NO];
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
            //            [self configureCell:[tableView cellForRowAtIndexPath:newIndexPath] atIndexPath:newIndexPath];
            
            [contentTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
            
            //            cellMap = [NSMutableArray arrayWithArray:[fetchedResultsController fetchedObjects]];
            //            [chatContent reloadData];
            [appdelegate saveContext];
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
}

- (void)getPrivateMessage
{
    if (!appdelegate)
    {
        appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    }
    NSURL *url = [NSURL URLWithString:@"https://stockshot-kk.appspot.com/api/get_private_message"];
    NSString *params = [[NSString alloc] initWithFormat:@"facebook_id=%@",me.facebookID];
    
    NSLog(@"param: %@",params);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    [request setTimeoutInterval:7];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
                                         {
                                            NSLog(@"JSON: %@",JSON);
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
                                                 
                                                 Conversation *conver = nil;
//                                                 NSLog(@"FROM:%@ TO:%@ ME:%@",chatMessage.from,chatMessage.to,me.facebookID);
                                                 if ([chatMessage.from isEqualToString:chatMessage.to]) {
                                                     
                                                 }
                                                 else
                                                 {
                                                     if ([chatMessage.from isEqualToString:me.facebookID])
                                                     {
//                                                         NSLog(@"USE: %@",chatMessage.to);
                                                         conver = [Conversation conversationWithUser:chatMessage.to
                                                                                         lastMessage:chatMessage
                                                                                             context:appdelegate.managedObjectContext];
                                                     }
                                                     else
                                                     {
//                                                         NSLog(@"USE: %@",chatMessage.from);
                                                         conver = [Conversation conversationWithUser:chatMessage.from
                                                                                         lastMessage:chatMessage
                                                                                             context:appdelegate.managedObjectContext];
                                                     }

                                                 }
                                                
                                             }

                                             [appdelegate saveContext];
                                             [contentTableView reloadData];
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
