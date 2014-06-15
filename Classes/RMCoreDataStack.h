//
//  RMCoreDataStack.h
//
//  Created by Robert MacEachern on 2014-03-29.
//  Copyright (c) 2014 Robert MacEachern. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RMCoreDataConfiguration.h"

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

@end
