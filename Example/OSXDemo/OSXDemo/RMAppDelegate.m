//
//  RMAppDelegate.m
//  OSXDemo
//
//  Created by Rob MacEachern on 2014-06-16.
//  Copyright (c) 2014 Rob MacEachern. All rights reserved.
//

#import "RMAppDelegate.h"
#import <RMCoreDataStack.h>

@interface RMAppDelegate () <RMCoreDataStackDelegate>
@property (nonatomic, strong) RMCoreDataStack *coreDataStack;
@end

@implementation RMAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.coreDataStack = [[RMCoreDataStack alloc] init];
    self.coreDataStack.delegate = self;
    [self.coreDataStack constructWithConfiguration:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (int i = 0; i < 100; i++) {
            [self insertNewObject];
        }
    });
}


// Returns the NSUndoManager for the application. In this case, the manager returned is that of the managed object context for the application.
- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window
{
    return [self.coreDataStack.managedObjectContext undoManager];
}

// Performs the save action for the application, which is to send the save: message to the application's managed object context. Any encountered errors are presented to the user.
- (IBAction)saveAction:(id)sender
{
    NSError *error = nil;
    
    if (![self.coreDataStack.managedObjectContext commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing before saving", [self class], NSStringFromSelector(_cmd));
    }
    
    if (![self.coreDataStack.managedObjectContext save:&error]) {
        [[NSApplication sharedApplication] presentError:error];
    }
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
    // Save changes in the application's managed object context before the application terminates.
    
    if (!self.coreDataStack.managedObjectContext) {
        return NSTerminateNow;
    }
    
    if (![self.coreDataStack.managedObjectContext commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing to terminate", [self class], NSStringFromSelector(_cmd));
        return NSTerminateCancel;
    }
    
    if (![self.coreDataStack.managedObjectContext hasChanges]) {
        return NSTerminateNow;
    }
    
    NSError *error = nil;
    if (![self.coreDataStack.managedObjectContext save:&error]) {

        // Customize this code block to include application-specific recovery steps.              
        BOOL result = [sender presentError:error];
        if (result) {
            return NSTerminateCancel;
        }

        NSString *question = NSLocalizedString(@"Could not save changes while quitting. Quit anyway?", @"Quit without saves error question message");
        NSString *info = NSLocalizedString(@"Quitting now will lose any changes you have made since the last successful save", @"Quit without saves error question info");
        NSString *quitButton = NSLocalizedString(@"Quit anyway", @"Quit anyway button title");
        NSString *cancelButton = NSLocalizedString(@"Cancel", @"Cancel button title");
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:question];
        [alert setInformativeText:info];
        [alert addButtonWithTitle:quitButton];
        [alert addButtonWithTitle:cancelButton];

        NSInteger answer = [alert runModal];
        
        if (answer == NSAlertAlternateReturn) {
            return NSTerminateCancel;
        }
    }

    return NSTerminateNow;
}

- (void)insertNewObject
{
    NSManagedObjectContext *context = self.coreDataStack.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:self.coreDataStack.managedObjectContext];
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    
    // If appropriate, configure the new managed object.
    // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
    [newManagedObject setValue:[NSDate date] forKey:@"timeStamp"];
    
    // Save the context.
    NSError *error = nil;
    NSLog(@"About to save new object");
    if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

#pragma mark - RMCoreDataStackDelegate

- (void)coreDataStack:(RMCoreDataStack *)stack didFinishInitializingWithInfo:(NSDictionary *)info {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)coreDataStack:(RMCoreDataStack *)stack failedInitializingWithInfo:(NSDictionary *)info {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

@end
