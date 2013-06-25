//
//  AppDelegate.h
//  StockShot
//
//  Created by Phatthana Tongon on 4/21/56 BE.
//  Copyright (c) 2556 Phatthana Tongon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IIViewDeckController.h"
#import "ProfileViewController.h"
#import <FacebookSDK/FacebookSDK.h>

@interface AppDelegate : UIResponder
<UIApplicationDelegate,UITabBarControllerDelegate,UITabBarDelegate,IIViewDeckControllerDelegate>
{
    IIViewDeckController* deckController;
    int lastTabSelect;
    int currentTabSelect;
    ProfileViewController *profileView;
    UINavigationController *profileNavigation;
    UILabel* notificationLabel;
}
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarController;
@property (nonatomic, retain) NSString *currentSymbol;
//@property (strong, nonatomic) UITabBar *tabbar;


@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (void)backToLastTabbar;
- (void)selectProfilePageWithUser:(User*)user;
- (void)chatWithUser:(User*)user;

- (void)hideStatusBar;
- (void)showStatusBar;
@end
