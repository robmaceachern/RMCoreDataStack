//
//  RMAppDelegate.m
//  BasicDemo
//
//  Created by Rob MacEachern on 2014-06-15.
//  Copyright (c) 2014 Rob MacEachern. All rights reserved.
//

#import "RMAppDelegate.h"
#import <RMCoreDataStack/RMCoreDataStack.h>
#import "RMMasterViewController.h"

@interface RMAppDelegate () <RMCoreDataStackDelegate>
@property RMCoreDataStack *coreDataStack;
@end

@implementation RMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.coreDataStack = [[RMCoreDataStack alloc] init];
    self.coreDataStack.delegate = self;
    [self.coreDataStack constructWithConfiguration:nil];
    
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
        UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
        splitViewController.delegate = (id)navigationController.topViewController;
        
        UINavigationController *masterNavigationController = splitViewController.viewControllers[0];
        RMMasterViewController *controller = (RMMasterViewController *)masterNavigationController.topViewController;
        controller.managedObjectContext = self.coreDataStack.managedObjectContext;
    } else {
        UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
        RMMasterViewController *controller = (RMMasterViewController *)navigationController.topViewController;
        controller.managedObjectContext = self.coreDataStack.managedObjectContext;
    }
    return YES;
}

# pragma mark - RMCoreDataStackDelegate

- (void)coreDataStack:(RMCoreDataStack *)stack didFinishInitializingWithInfo:(NSDictionary *)info {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)coreDataStack:(RMCoreDataStack *)stack failedInitializingWithInfo:(NSDictionary *)info {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

@end
