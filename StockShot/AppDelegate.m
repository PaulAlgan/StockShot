
//  AppDelegate.m
//  StockShot
//
//  Created by Phatthana Tongon on 4/21/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "SearchViewController.h"
#import "ThirdViewController.h"
#import "CameraViewController.h"
#import "FeedViewController.h"
#import "ChatViewController.h"
#import "MenuViewController.h"
#import "LoginViewController.h"
#import "ProfileViewController.h"
#import "User+addition.h"
@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize tabBarController;
@synthesize currentSymbol;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.

    HomeViewController *homeView = [[HomeViewController alloc] init];
    UINavigationController *homeNavi = [[UINavigationController alloc] initWithRootViewController:homeView];
//    homeView.title = @"Home";
    
    SearchViewController *searchView = [[SearchViewController alloc] init];
    UINavigationController *searchNavi = [[UINavigationController alloc] initWithRootViewController:searchView];
//    searchView.title = @"Explorer";
    
    ThirdViewController *thirdView = [[ThirdViewController alloc] init];
//    CameraViewController *thirdView = [[CameraViewController alloc] init];
    UINavigationController *cameraNavi = [[UINavigationController alloc] initWithRootViewController:thirdView];
    
    FeedViewController *feedView = [[FeedViewController alloc] init];
    UINavigationController *feedNavi = [[UINavigationController alloc] initWithRootViewController:feedView];
//    feedView.title = @"Feed";
    
    ChatViewController *chatView = [[ChatViewController alloc] init];
    UINavigationController *chatNavi = [[UINavigationController alloc] initWithRootViewController:chatView];
//    chatView.title = @"Chat";
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"bg_navigation.png"]
                                       forBarMetrics:UIBarMetricsDefault];
    
    MenuViewController *menuView = [[MenuViewController alloc] init];    
    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:
                                             homeNavi,
                                             searchNavi,
                                             cameraNavi,
                                             feedNavi,
                                             chatNavi,
                                             nil];
    self.tabBarController.delegate = self;
    
    
    UIImage *selectedImage0 = [UIImage imageNamed:@"1.png"];
    UIImage *selectedImage1 = [UIImage imageNamed:@"2.png"];
    UIImage *selectedImage2 = [UIImage imageNamed:@"3.png"];
    UIImage *selectedImage3 = [UIImage imageNamed:@"4.png"];
    UIImage *selectedImage4 = [UIImage imageNamed:@"5.png"];
    
    UIImage *unselectedImage0 = [UIImage imageNamed:@"1.png"];
    UIImage *unselectedImage1 = [UIImage imageNamed:@"2.png"];
    UIImage *unselectedImage2 = [UIImage imageNamed:@"3.png"];
    UIImage *unselectedImage3 = [UIImage imageNamed:@"4.png"];
    UIImage *unselectedImage4 = [UIImage imageNamed:@"5.png"];
    
    
    UITabBar *tabbar = [self.tabBarController tabBar];
    tabbar.selectionIndicatorImage = [UIImage imageNamed:@"tabbarBG_select.png"];
    tabbar.backgroundImage = [UIImage imageNamed:@"bg_tabbar.png"];
    
    UITabBarItem *item0 = [tabbar.items objectAtIndex:0];
    UITabBarItem *item1 = [tabbar.items objectAtIndex:1];
    UITabBarItem *item2 = [tabbar.items objectAtIndex:2];
    UITabBarItem *item3 = [tabbar.items objectAtIndex:3];
    UITabBarItem *item4 = [tabbar.items objectAtIndex:4];
    
    [item0 setFinishedSelectedImage:selectedImage0 withFinishedUnselectedImage:unselectedImage0];
    [item1 setFinishedSelectedImage:selectedImage1 withFinishedUnselectedImage:unselectedImage1];
    [item2 setFinishedSelectedImage:selectedImage2 withFinishedUnselectedImage:unselectedImage2];
    [item3 setFinishedSelectedImage:selectedImage3 withFinishedUnselectedImage:unselectedImage3];
    [item4 setFinishedSelectedImage:selectedImage4 withFinishedUnselectedImage:unselectedImage4];
    
    deckController =  [[IIViewDeckController alloc] initWithCenterViewController:self.tabBarController
                                                              leftViewController:menuView
                                                             rightViewController:nil];
    deckController.delegate = self;
    deckController.leftLedge = 83-20;
    deckController.centerhiddenInteractivity = IIViewDeckCenterHiddenNotUserInteractiveWithTapToClose;
    [self.window setRootViewController:deckController];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    lastTabSelect = currentTabSelect = 0;
    
    notificationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
    notificationLabel.textAlignment = NSTextAlignmentCenter;
    notificationLabel.backgroundColor = [UIColor colorWithRed:15.0/255.0 green:32.0/255.0 blue:40.0/255.0 alpha:1];
    notificationLabel.textColor = [UIColor colorWithRed:253.0/255.0 green:253.0/255.0 blue:253.0/255.0 alpha:1];
    notificationLabel.font = [UIFont boldSystemFontOfSize:14];
    
    User *me = [User me];
    if (me.facebookID)
    {
        [Datahandler getNewMessageWithuserID:me.facebookID
                                  OnComplete:^(BOOL success, int newMsgCount)
        {
            if (success && (newMsgCount > 0)) {
                [self showNotificationViewFor:4 value:[NSString stringWithFormat:@"%d",newMsgCount]];
            }
        }];
    }
    
//    notificationLabel.text = @"1";
    return YES;
}


#pragma mark - Method

- (CGFloat) locationFor:(NSUInteger)tabIndex
{
    CGFloat tabItemWidth = self.tabBarController.tabBar.frame.size.width / self.tabBarController.tabBar.items.count;
    CGFloat halfTabItemWidth = (tabItemWidth / 2.0) - (notificationLabel.frame.size.width / 2.0);
    return (tabIndex * tabItemWidth) + halfTabItemWidth;
}
- (void)showNotificationViewFor:(NSUInteger)tabIndex value:(NSString*)value
{
    CGFloat tabItemWidth = self.tabBarController.tabBar.frame.size.width / self.tabBarController.tabBar.items.count;
    int notiX = (tabIndex * tabItemWidth) + (tabItemWidth - notificationLabel.frame.size.width - 5);
    
    notificationLabel.text = value;
    notificationLabel.frame = CGRectMake(notiX, 2,
                                        notificationLabel.frame.size.width, notificationLabel.frame.size.height);
    
    if (!notificationLabel.superview) [self.tabBarController.tabBar addSubview:notificationLabel];
    
    notificationLabel.alpha = 0.0;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    notificationLabel.alpha = 1.0;
    [UIView commitAnimations];
}

- (void)hideNotificationView
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    notificationLabel.alpha = 0.0;
    [UIView commitAnimations];
}

- (void)selectProfilePageWithUser:(User*)user
{
    UITabBar *tabbar = [self.tabBarController tabBar];
    tabbar.selectionIndicatorImage = [UIImage imageNamed:@"tabbarBG.png"];
    
    for (UIView *view in self.tabBarController.view.subviews) {
        if (view == profileNavigation.view) {
//            NSLog(@"NAVI HAVE");
            [view removeFromSuperview];
        }
    }
    
    if (!profileView) profileView = [[ProfileViewController alloc] initWithUser:user];
    else profileView.user = user;
    
    profileNavigation = [[UINavigationController alloc] initWithRootViewController:profileView];
    CGRect naviRect = profileNavigation.view.frame;
//    naviRect.origin.y = -20;
    naviRect.size.height = 480-52-20;
    profileNavigation.view.frame = naviRect;
    [self.tabBarController.view addSubview:profileNavigation.view];

    
//    NSLog(@"H: %lf",profileNavigation.view.frame.size.height);
}
- (BOOL)tabBarController:(UITabBarController *)atabBarController shouldSelectViewController:(UIViewController *)viewController
{
    NSLog(@"SELECT TABBAR");
    if (profileNavigation) {
        [profileNavigation.view removeFromSuperview];
    }
    
    UITabBar *tabbar = [self.tabBarController tabBar];
    tabbar.selectionIndicatorImage = [UIImage imageNamed:@"tabbarBG_select.png"];
    
    for (int i=0; i<atabBarController.viewControllers.count; i++)
    {
        if (viewController == [atabBarController.viewControllers objectAtIndex:i]) {
            lastTabSelect = currentTabSelect;
            currentTabSelect = i;
            
            if (i == 4) {
                [self hideNotificationView];
            }
        }
    }
    return YES;
}

- (void)chatWithUser:(User*)user
{
    NSLog(@"chatWithUser: %@",user.name);
    [self.tabBarController setSelectedIndex:4];
    
    [profileNavigation.view removeFromSuperview];
    UITabBar *tabbar = [self.tabBarController tabBar];
    tabbar.selectionIndicatorImage = [UIImage imageNamed:@"tabbarBG_select.png"];
    lastTabSelect = currentTabSelect;
    currentTabSelect = 4;
    
    UINavigationController *chatNavi = [[self.tabBarController viewControllers] objectAtIndex:4];
    [chatNavi popToRootViewControllerAnimated:YES];
    NSLog(@"NAVIn: %d",chatNavi.viewControllers.count);
    ChatViewController *chatView = [chatNavi.viewControllers objectAtIndex:0];
    [chatView chatToUser:user];
}

- (void)tabBarController:(UITabBarController *)atabBarController didSelectViewController:(UIViewController *)viewController
{
    if (viewController == [atabBarController.viewControllers objectAtIndex:2]){
        [self hideStatusBar];
    }
}

- (void)backToLastTabbar
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    self.window.rootViewController.view.frame = [UIScreen mainScreen].applicationFrame;

    currentTabSelect = lastTabSelect;
    [self.tabBarController setSelectedIndex:lastTabSelect];
}

- (void)showStatusBar
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    self.window.rootViewController.view.frame = [UIScreen mainScreen].applicationFrame;
}


- (void)hideStatusBar
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    self.window.rootViewController.view.frame = [UIScreen mainScreen].applicationFrame;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [FBSession.activeSession handleOpenURL:url];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [FBSession.activeSession close];

    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"StockShot" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"StockShot.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
