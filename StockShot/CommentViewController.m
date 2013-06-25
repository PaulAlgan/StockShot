//
//  CommentViewController.m
//  StockShot
//
//  Created by Phatthana Tongon on 6/5/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import "CommentViewController.h"
//#import "MessageCell.h"
#import "CommentCell.h"
#import "User+addition.h"
#import "AFJSONRequestOperation.h"
static NSString *CellClassName = @"CommentCell";

@interface CommentViewController ()
{
    NSMutableArray *comments;
    BOOL keyboardShow;
    User *me;
    UIButton *editButton;
    UIButton *doneButton;
}
@end

@implementation CommentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithPhotoDict:(NSDictionary*)dict;
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        self.photoDict = dict;
        NSArray *commentTempArray = [dict objectForKey:@"comment"];
        comments = [[NSMutableArray alloc] init];
        for (int i=0; i<commentTempArray.count; i++){
            [comments insertObject:[commentTempArray objectAtIndex:i] atIndex:0];
        }
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Comments";
    self.navigationItem.leftBarButtonItem = [Utility backButton:self];
  
    editButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [editButton setImage:[UIImage imageNamed:@"editComment_bt.png"] forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(setEditTable) forControlEvents:UIControlEventTouchUpInside];
    
    doneButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [doneButton setImage:[UIImage imageNamed:@"editComment_bt.png"] forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(setDoneTable) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:editButton];
    
    cellLoader = [UINib nibWithNibName:CellClassName bundle:[NSBundle mainBundle]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"TestNotification"
                                               object:nil];
    NSLog(@"Comments: %@",comments);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self scrollToBottomAnimated:NO];
}

- (void)setEditTable
{
    [contentTableView setEditing:YES animated:YES];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
    
}

- (void)setDoneTable
{
    [contentTableView setEditing:NO animated:YES];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:editButton];
    
}

#pragma mark - IBAction
- (IBAction)sendMessage:(id)sender
{
    [self commentOnPhotoKey:[self.photoDict objectForKey:@"key"] message:chatTextView.text];
    chatTextView.text = @"";
}
#pragma mark - UITabelViewDatasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (comments.count > 0)
    {
        CommentCell *cell = [[CommentCell alloc] init];
        NSDictionary *comment = [comments objectAtIndex:indexPath.row];
        int rowHeight = [cell rowHeightWithComment:comment];
        
        if (rowHeight < 60) {
            return 60;
        }
        else{
            return rowHeight + 20+13;
        }
    }
    else
    {
        return 60;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentCell *cell = (CommentCell *)[tableView dequeueReusableCellWithIdentifier:CellClassName];
    if (!cell)
    {
        NSArray *topLevelItems = [cellLoader instantiateWithOwner:self options:nil];
        cell = [topLevelItems objectAtIndex:0];
    }
    
    if (comments > 0) {
        NSDictionary *comment = [comments objectAtIndex:indexPath.row];
        [cell setComment:comment];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
//        NSLog(@"CommentDel: %@",[comments objectAtIndex:indexPath.row]);
        NSDictionary *dict = [[NSDictionary alloc] initWithDictionary:[comments objectAtIndex:indexPath.row]];
        [Datahandler removeCommentWithKey:[dict objectForKey:@"key"] userID:me.facebookID
                               OnComplete:^(BOOL success, NSString *result)
        {
            [comments removeObjectAtIndex:indexPath.row];
            [contentTableView reloadData];
        }];
    }
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
    //    NSLog(@"viewFrame y: %@", NSStringFromCGRect(viewFrame));
    
    CGRect keyboardFrameEndRelative = [self.view convertRect:keyboardEndFrame fromView:nil];
    //    NSLog(@"self.view: %@", self.view);
    //    NSLog(@"keyboardFrameEndRelative: %@", NSStringFromCGRect(keyboardFrameEndRelative));
    
    viewFrame.size.height =  keyboardFrameEndRelative.origin.y;// - textInputView.frame.size.height;
    self.view.frame = viewFrame;
    [self scrollToBottomAnimated:YES];
    
    [UIView commitAnimations];
}

- (void)scrollToBottomAnimated:(BOOL)animated {
    NSInteger bottomRow = [comments count] - 1;
    if (bottomRow >= 0) {
        NSIndexPath *indexpath = [NSIndexPath indexPathForItem:bottomRow inSection:0];
        [contentTableView scrollToRowAtIndexPath:indexpath
                                atScrollPosition:UITableViewScrollPositionBottom animated:animated];
    }
}

#pragma mark UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    if ([textView hasText])
    {
        sendButton.enabled = YES;
    }
    else
    {
        sendButton.enabled = NO;
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //    [chatTextView resignFirstResponder];
}

#pragma mark - DATA
- (void)commentOnPhotoKey:(NSString*)key message:(NSString*)msg
{
    me = [User me];
    NSURL *url = [NSURL URLWithString:@"https://stockshot-kk.appspot.com/api/comment"];
    NSString *params = [[NSString alloc] initWithFormat:@"facebook_id=%@&photo_key=%@&message=%@",me.facebookID,key,msg];
    
    NSLog(@"SEND: %@",params);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    [request setTimeoutInterval:7];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
                                         {
                                             NSDate *todaydate = [NSDate date];
                                             NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                                             formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSSSS";
                                             [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
                                             
                                             //                                             NSLog(@"SEND RESULT: %@",JSON);
                                             NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                                   msg, @"comment",
                                                                   [formatter stringFromDate:todaydate] , @"date",
                                                                   me.facebookID, @"player",
                                                                   nil];
                                             [comments addObject:dict];
                                             [contentTableView reloadData];
                                             [self scrollToBottomAnimated:YES];
                                             //                                             [Utility alertWithMessage:[NSString stringWithFormat:@"Comment: %@",[JSON objectForKey:@"result"]]];
                                             
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
