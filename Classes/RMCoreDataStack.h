//
//  RMCoreDataStack.h
//
//  Created by Robert MacEachern on 2014-03-29.
//  Copyright (c) 2014 Robert MacEachern. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RMCoreDataConfiguration.h"
#import <CoreData/CoreData.h>

@protocol RMCoreDataStackDelegate;

@interface RMCoreDataStack : NSObject

@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, weak) id<RMCoreDataStackDelegate> delegate;

- (void)constructWithConfiguration:(RMCoreDataConfiguration *)configuration;

@end


@protocol RMCoreDataStackDelegate <NSObject>
@required
- (void)coreDataStack:(RMCoreDataStack *)stack didFinishInitializingWithInfo:(NSDictionary *)info;
- (void)coreDataStack:(RMCoreDataStack *)stack failedInitializingWithInfo:(NSDictionary *)info;

@optional
- (void)coreDataStack:(RMCoreDataStack *)stack willResetManagedObjectContext:(NSManagedObjectContext *)moc;
- (void)coreDataStack:(RMCoreDataStack *)stack didResetManagedObjectContext:(NSManagedObjectContext *)moc;
- (void)coreDataStack:(RMCoreDataStack *)stack persistentStoreCoordinatorStoresDidChange:(NSDictionary *)info;

@end
