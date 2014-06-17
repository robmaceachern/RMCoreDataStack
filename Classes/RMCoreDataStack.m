//
//  RMCoreDataStack.m
//  Aloe Vera
//
//  Created by Robert MacEachern on 2014-03-29.
//  Copyright (c) 2014 Robert MacEachern. All rights reserved.
//

#import "RMCoreDataStack.h"
#import "RMCoreDataMacros.h"
#import "RMCoreDataConfiguration.h"

@interface RMCoreDataStack ()

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObjectContext *privateContext; // the parent MOC. Writes to disk on saves.

@end

@implementation RMCoreDataStack

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)constructWithConfiguration:(RMCoreDataConfiguration *)configuration {
    
    if (!configuration) {
        configuration = [[RMCoreDataConfiguration alloc] init];
    }
    
    NSURL *modelURL = configuration.modelURL;
    ZAssert(modelURL, @"Failed to find model URL");
    
    NSManagedObjectModel *mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    ZAssert(mom, @"Failed to initialize model");
    
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    ZAssert(psc, @"Failed to initialize persistent store coordinator");
    
    NSManagedObjectContext *private = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [private setPersistentStoreCoordinator:psc];
    
    NSManagedObjectContext *moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [moc setParentContext:private];
    
    self.privateContext = private;
    self.managedObjectContext = moc;
    
    self.privateContext.mergePolicy = configuration.mergePolicy;
    self.managedObjectContext.mergePolicy = configuration.mergePolicy;
    
    [self registerForNotificationsUsingPersistentStoreCoordinator:psc
                                             managedObjectContext:self.managedObjectContext
                                                    configuration:configuration];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSError *error = nil;
        NSPersistentStore *store = [psc addPersistentStoreWithType:configuration.persistentStoreType
                                                     configuration:nil
                                                               URL:configuration.persistentStoreURL
                                                           options:configuration.persistentStoreOptions
                                                             error:&error];
        NSLog(@"%s NSPersistentStore added", __PRETTY_FUNCTION__);
        if (!store) {
            ALog(@"Error adding persistent store to coordinator %@\n%@", [error localizedDescription], [error userInfo]);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate coreDataStack:self failedInitializingWithInfo:@{}]; // TODO
            });
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate coreDataStack:self didFinishInitializingWithInfo:@{}]; // TODO
        });
    });
}

- (void)registerForNotificationsUsingPersistentStoreCoordinator:(NSPersistentStoreCoordinator *)persistentStoreCoordinator
                                           managedObjectContext:(NSManagedObjectContext *)managedObjectContext
                                                  configuration:(RMCoreDataConfiguration *)configuration {
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	
    [notificationCenter addObserver:self
                           selector:@selector(mainManagedObjectContextDidSave:)
                               name:NSManagedObjectContextDidSaveNotification
                             object:managedObjectContext];
    
#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
    [notificationCenter addObserver:self
                           selector:@selector(appWillResignActive:)
                               name:UIApplicationWillResignActiveNotification
                             object:nil];
#else
    [notificationCenter addObserver:self
                           selector:@selector(appWillResignActive:)
                               name:NSApplicationWillResignActiveNotification
                             object:nil];
#endif
    
    if (configuration.iCloudEnabled) {
        [notificationCenter addObserver:self
                               selector:@selector(persistentStoreCoordinatorStoresWillChange:)
                                   name:NSPersistentStoreCoordinatorStoresWillChangeNotification
                                 object:persistentStoreCoordinator];
        
        [notificationCenter addObserver:self
                               selector:@selector(persistentStoreCoordinatorStoresDidChange:)
                                   name:NSPersistentStoreCoordinatorStoresDidChangeNotification
                                 object:persistentStoreCoordinator];
        
        [notificationCenter addObserver:self
                               selector:@selector(persistentStoreDidImportUbiquitousContentChanges:)
                                   name:NSPersistentStoreDidImportUbiquitousContentChangesNotification
                                 object:persistentStoreCoordinator];
    }
    
}

- (void)saveManagedObjectContext:(NSManagedObjectContext *)context wait:(BOOL)wait {
    NSParameterAssert(context);

    void (^saveBlock) (void) = ^{
        NSError *error = nil;
        ZAssert([context save:&error], @"Error saving moc: %@\n%@",
                [error localizedDescription], [error userInfo]);
    };
    
    if ([context hasChanges]) {
        if (wait) {
            [context performBlockAndWait:saveBlock];
        } else {
            [context performBlock:saveBlock];
        }
    }
}

#pragma mark - NSNotificationCenter handlers

- (void)mainManagedObjectContextDidSave:(NSDictionary *)info {
    NSLog(@"%s Saving privateContext", __PRETTY_FUNCTION__);
    [self saveManagedObjectContext:self.privateContext wait:NO];
}

- (void)appWillResignActive:(NSDictionary *)info {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    // TODO add support for saving in a background task
    [self saveManagedObjectContext:self.managedObjectContext wait:YES];
    [self saveManagedObjectContext:self.privateContext wait:YES];
}

- (void)persistentStoreCoordinatorStoresWillChange:(NSDictionary *)info {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self saveManagedObjectContext:self.managedObjectContext wait:YES];
    [self.managedObjectContext performBlockAndWait:^{
        [self.managedObjectContext reset];
    }];
}

- (void)persistentStoreCoordinatorStoresDidChange:(NSDictionary *)info {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
}

- (void)persistentStoreDidImportUbiquitousContentChanges:(NSDictionary *)info {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
}

@end
