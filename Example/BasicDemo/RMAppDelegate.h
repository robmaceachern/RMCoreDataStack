//
//  RMAppDelegate.h
//  BasicDemo
//
//  Created by Rob MacEachern on 2014-06-15.
//  Copyright (c) 2014 Rob MacEachern. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RMAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
